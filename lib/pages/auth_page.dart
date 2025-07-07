import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talksy/services/auth/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final List<String> imagePaths = [
    'assets/images/auth/auth_1.png',
    'assets/images/auth/auth_2.png',
    'assets/images/auth/auth_3.png',
    'assets/images/auth/auth_4.png',
    'assets/images/auth/auth_5.png',
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔄 Auto Image Carousel
            CarouselSlider(
              items: imagePaths.map((path) {
                return Image.asset(
                  path,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  frameBuilder: (context, child, frame, wasSyncLoaded) {
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: child,
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: size.height * 0.45,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              carouselController: _carouselController,
            ),

            const SizedBox(height: 16),

            /// 🟢 Page Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imagePaths.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: _currentIndex == entry.key ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentIndex == entry.key
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// 👋 Welcome Title & Subtitle
            Text(
              "Welcome to Zynk",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "A modern app for smart users. Stay organized, stay ahead.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            /// 🔐 Google Sign-In Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Material(
                color: colorScheme.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () {
                    AuthService().signInWithGoogle(context);
                  },
                  borderRadius: BorderRadius.circular(16),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.05),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Google Logo
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surfaceVariant,
                                ),
                                child: Image.asset(
                                  'assets/icons/google.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Text
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
