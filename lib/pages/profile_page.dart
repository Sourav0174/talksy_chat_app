import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:talksy/pages/developer_info_page.dart';
import 'package:talksy/services/auth/auth_service.dart';
import 'package:talksy/services/shared_pref.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = SharedPrefHelper();
    final fetchedName = await prefs.getUserName();
    final fetchedEmail = await prefs.getUserEmail();
    final fetchedImage = await prefs.getUserImage();

    setState(() {
      name = fetchedName;
      email = fetchedEmail;
      imageUrl = fetchedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          /// Gradient circle decoration
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.4),
                    colorScheme.primary,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Avatar + Name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.primary.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: colorScheme.background,
                          backgroundImage:
                              (imageUrl != null && imageUrl!.isNotEmpty)
                              ? NetworkImage(imageUrl!)
                              : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? "Loading...",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email ?? "",
                            style: textTheme.bodySmall?.copyWith(
                              color: textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Glass card stats
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 25,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorScheme.background.withOpacity(0.1),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.onSurface.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text("Bio editing feature coming soon!"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Settings list
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(10, 10),
                          ),
                        ],
                      ),
                      child: ListView(
                        children: const [
                          _ProfileTile(icon: Icons.person, title: "Username"),
                          _ProfileTile(
                            icon: Icons.notifications,
                            title: "Notifications",
                          ),
                          _ProfileTile(icon: Icons.settings, title: "Settings"),
                          _ProfileTile(
                            icon: Icons.lock_outline,
                            title: "Developer Info",
                          ),
                          _ProfileTile(
                            icon: Icons.logout,
                            title: "Logout",
                            isLogout: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats Widget
class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.isLogout = false,
  });

  void _handleTap(BuildContext context) {
    if (isLogout) {
      // 🔒 Logout logic
      AuthService().signOut();
    } else if (title == "Developer Info") {
      // 👉 Navigate to DeveloperInfoPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DeveloperInfoPage()),
      );
    } else {
      // 🚧 Coming soon dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Coming Soon! 🚧"),
          content: Text(
            "The \"$title\" feature is not available yet. Stay tuned!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      onTap: () => _handleTap(context),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.1)
              : colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isLogout ? Colors.red : colorScheme.primary),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          color: isLogout ? Colors.red : textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }
}
