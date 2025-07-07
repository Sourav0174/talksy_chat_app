import 'package:flutter/material.dart';
import 'package:talksy/components/custom_drawer_tile.dart';
import 'package:talksy/pages/profile_page.dart';
import 'package:talksy/pages/settings_page.dart';
import 'package:talksy/services/auth/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void logout() {
    AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(6, 6),
                        blurRadius: 12,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.7),
                        offset: const Offset(-6, -6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.secondary),
              // home tile
              CustomDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              // profile tile
              CustomDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              // search tile
              // CustomDrawerTile(
              //   title: "S E A R C H",
              //   icon: Icons.search,
              //   // onTap: () => _navigateToPage(context, const SearchPage()),
              // ),
              // chat_bot_page

              // settings tile
              CustomDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ),
              ),
              const Spacer(),
              // logout tile
              CustomDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
