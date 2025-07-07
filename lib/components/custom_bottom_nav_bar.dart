import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:talksy/pages/profile_page.dart';
import 'package:talksy/pages/home_page.dart';
import 'package:talksy/pages/settings_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const SettingsPage(),
    HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey.withOpacity(0.2),
              hoverColor: Colors.grey.withOpacity(0.1),
              gap: 8,
              activeColor: colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: colorScheme.primary.withOpacity(0.1),
              color: colorScheme.onBackground,
              tabs: const [
                GButton(icon: Icons.settings, text: 'Settings'),
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.user, text: 'Profile'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
