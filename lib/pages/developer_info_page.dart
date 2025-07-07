import 'package:flutter/material.dart';

class DeveloperInfoPage extends StatelessWidget {
  const DeveloperInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About the Developer"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: const AssetImage("assets/images/dev.png"),
              backgroundColor: colorScheme.surface,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: Text(
                "Sourav",
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Flutter Developer | Firebase | AI Enthusiast",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // About
            _infoSection(
              context,
              icon: Icons.info_outline,
              title: "About Me",
              content:
                  "Hey there! 👋 I'm Sourav, a creative developer who builds modern, real-world Flutter apps. From chat apps to AI-powered tools — my goal is to turn ideas into powerful, beautiful experiences.",
            ),

            // Skills
            _infoSection(
              context,
              icon: Icons.star_outline,
              title: "Skills",
              content:
                  "✅ Flutter & Dart\n✅ Firebase (Auth, Firestore, Storage, FCM)\n✅ Node.js & MongoDB\n✅ Bloc, Clean Architecture\n✅ REST APIs, UI/UX Design\n✅ Exploring AI & ML",
            ),

            // Projects
            _infoSection(
              context,
              icon: Icons.rocket_launch_outlined,
              title: "Projects",
              content:
                  "📱 Zynk – Chat app with Firebase & Bloc\n🤖 Flexx – Social media app with AI chatbot\n💬 LinkUp – Messenger app (neumorphism UI)\n🧠 RiseAbove – Mental health assistant\n🛒 ForEasy – eCommerce solution",
            ),

            const SizedBox(height: 30),
            Text(
              "“Code what you dream. Build what the world needs.”",
              style: textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Info Card Section
  Widget _infoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(content, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
