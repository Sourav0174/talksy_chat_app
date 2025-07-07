import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:talksy/pages/chat_page.dart';
import 'package:talksy/pages/profile_page.dart';
import 'package:talksy/services/auth/auth_service.dart';
import 'package:talksy/services/chat/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  Future<void> _refreshUsers() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  List<Map<String, dynamic>> _searchedUsers = [];
  bool _isSearching = false;
  Timer? _debounce;

  void _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchedUsers = [];
      });
      return;
    }

    final results = await _chatService.searchUsers(query);
    setState(() {
      _isSearching = true;
      _searchedUsers = results;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          _buildMainContent(colorScheme, textTheme),
          _buildTopBar(colorScheme),
          _buildSearchBar(colorScheme),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
    );
  }

  Widget _buildTopBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Zynk',
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.background,
            ),
          ),
          IconButton(
            icon: Icon(Icons.person, color: colorScheme.background),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.16,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          style: TextStyle(color: colorScheme.onSurface),
          controller: searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(ColorScheme colorScheme, TextTheme textTheme) {
    final currentUser = _authService.getCurrentUser();

    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.23,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isSearching ? "Search Results" : "Chats",
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              color: textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LiquidPullToRefresh(
              color: colorScheme.background,
              backgroundColor: colorScheme.primary,
              onRefresh: _refreshUsers,
              child: _isSearching
                  ? _searchedUsers.isEmpty
                        ? Center(child: Text("No users found"))
                        : ListView.builder(
                            itemCount: _searchedUsers.length,
                            itemBuilder: (context, index) {
                              final userData = _searchedUsers[index];
                              // Don't show current user
                              if (userData["uid"] == currentUser?.uid) {
                                return const SizedBox();
                              }
                              return _buildUserListItem(
                                userData,
                                context,
                                colorScheme,
                                textTheme,
                              );
                            },
                          )
                  : StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _chatService.getChatContactsStream(
                        currentUser!.uid,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }

                        final users = snapshot.data ?? [];

                        if (users.isEmpty) {
                          return Center(child: Text("No chats yet"));
                        }

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final userData = users[index];
                            return _buildChatListItem(
                              userData,
                              context,
                              colorScheme,
                              textTheme,
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatListItem(
    Map<String, dynamic> userData,
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final Timestamp timestamp = userData["timestamp"];
    final int unreadCount = userData["unreadCount"] ?? 0;

    // Format time like WhatsApp (e.g., 11:30 AM or 3 Jul)
    String formattedTime = '';
    if (timestamp != null) {
      final date = timestamp.toDate();
      final now = DateTime.now();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      formattedTime = isToday
          ? TimeOfDay.fromDateTime(date).format(context)
          : "${date.day}/${date.month}";
    }

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 1,
            vertical: 1,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                  name: userData["name"],
                  profileUrl: userData["Image"],
                ),
              ),
            );
          },
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(userData["Image"]),
            backgroundColor: colorScheme.background,
            onBackgroundImageError: (_, __) {},
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  userData["name"],
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
              Text(
                formattedTime,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  userData["lastMessage"] ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: unreadCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(thickness: 0.1, color: colorScheme.onSurface.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
                name: userData["name"] ?? userData["email"],
                profileUrl: userData["Image"] ?? "",
              ),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(userData["Image"] ?? ""),
          backgroundColor: colorScheme.background,
          onBackgroundImageError: (_, __) {},
        ),
        title: Text(
          userData["name"] ?? userData["email"],
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          userData["email"],
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chat_bubble_outline,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}
