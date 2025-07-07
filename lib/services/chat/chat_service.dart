import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talksy/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔄 Get stream of all users (for search)
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // ✅ Send a message
  Future<void> sendMessage(String receiverID, String message) async {
    try {
      final String currentUserID = _auth.currentUser!.uid;
      final String currentUserEmail = _auth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      // Construct chatRoomID using sorted IDs
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join("_");
      final chatRoomRef = _firestore.collection("chats_rooms").doc(chatRoomID);

      // Create or update chat room
      await chatRoomRef.set({
        "users": [currentUserID, receiverID],
        "lastUpdated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Create message object
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      // Save message (add isRead: false for tracking)
      await chatRoomRef.collection("messages").add({
        ...newMessage.toMap(),
        "isRead": false,
      });
    } catch (e) {
      print("Error sending message: $e");
      rethrow;
    }
  }

  // 📥 Get messages between two users
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
        .collection("chats_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // 🔍 Search users by keyword
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection('users')
        .where('keywords', arrayContains: query.toLowerCase())
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // 📡 Get chat contacts stream with last message, time, and unread count
  Stream<List<Map<String, dynamic>>> getChatContactsStream(
    String currentUserId,
  ) {
    return _firestore
        .collection("chats_rooms")
        .orderBy("lastUpdated", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final contacts = <Map<String, dynamic>>[];

          for (final doc in snapshot.docs) {
            final chatRoomId = doc.id;
            final ids = chatRoomId.split("_");

            if (!ids.contains(currentUserId)) continue;

            final otherUserId = ids.firstWhere((id) => id != currentUserId);

            // Get last message
            final messagesSnapshot = await _firestore
                .collection("chats_rooms")
                .doc(chatRoomId)
                .collection("messages")
                .orderBy("timestamp", descending: true)
                .limit(1)
                .get();

            if (messagesSnapshot.docs.isEmpty) continue;

            final lastMessageDoc = messagesSnapshot.docs.first;
            final lastMessageData = lastMessageDoc.data();
            final String lastMessage = lastMessageData["message"] ?? "";
            final Timestamp timestamp = lastMessageData["timestamp"];

            // 🔴 Count unread messages
            final unreadSnapshot = await _firestore
                .collection("chats_rooms")
                .doc(chatRoomId)
                .collection("messages")
                .where("receiverID", isEqualTo: currentUserId)
                .where("isRead", isEqualTo: false)
                .get();

            final int unreadCount = unreadSnapshot.docs.length;

            // Get user data
            final userDoc = await _firestore
                .collection("users")
                .doc(otherUserId)
                .get();
            if (!userDoc.exists) continue;

            final userData = userDoc.data()!;
            contacts.add({
              "uid": otherUserId,
              "name": userData["name"] ?? userData["email"],
              "email": userData["email"],
              "Image": userData["Image"] ?? "",
              "lastMessage": lastMessage,
              "timestamp": timestamp,
              "unreadCount": unreadCount,
            });
          }

          return contacts;
        });
  }

  // ✅ Mark messages as read
  Future<void> markMessagesAsRead(String receiverID) async {
    final currentUserID = _auth.currentUser!.uid;
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    final unreadMessages = await _firestore
        .collection("chats_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("receiverID", isEqualTo: currentUserID)
        .where("isRead", isEqualTo: false)
        .get();

    for (final doc in unreadMessages.docs) {
      await doc.reference.update({"isRead": true});
    }
  }
}
