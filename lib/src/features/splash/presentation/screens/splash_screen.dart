import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/home/presentation/screens/home_screen.dart';
import 'package:littletech/src/features/onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isLoggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      Nav.replaceAll(context, const HomeScreen());
    } else {
      Nav.replaceAll(context, const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const Gap(24),
            Animate(
              effects: [
                FadeEffect(delay: 300.ms),
                MoveEffect(begin: const Offset(0, 20), delay: 300.ms),
              ],
              child: const Text(
                'LittleTech',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Gap(8),
            Animate(
              effects: [FadeEffect(delay: 500.ms)],
              child: const Text(
                'You Are The Only Expert',
                style: TextStyle(fontSize: 14, color: Colors.white54, letterSpacing: 2),
              ),
            ),
            const Gap(60),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.accent),
            ).animate(delay: 700.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}