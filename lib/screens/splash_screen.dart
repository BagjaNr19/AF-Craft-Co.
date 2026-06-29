import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _taglineController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _taglineFade =
        CurvedAnimation(parent: _taglineController, curve: Curves.easeIn);
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );
  }

  Future<void> _startSplashSequence() async {
    _fadeController.forward();
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    await context.read<AuthProvider>().checkAuthStatus();

    if (!mounted) return;
    final authStatus = context.read<AuthProvider>().status;

    if (authStatus == AuthStatus.authenticated) {
      AppRoutes.pushAndClearStack(context, AppRoutes.home);
    } else {
      AppRoutes.pushAndClearStack(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ────────────────────────────────────────────────────
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.12),
                            border: Border.all(
                              color: AppTheme.champagne.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.goldGradient,
                              ),
                              child: const Icon(
                                Icons.card_giftcard_rounded,
                                size: 36,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'AF Craft & Co.',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Tagline ──────────────────────────────────────────────────
                FadeTransition(
                  opacity: _taglineFade,
                  child: SlideTransition(
                    position: _taglineSlide,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 1,
                          color: AppTheme.champagne.withOpacity(0.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'The Art of Aesthetic Gifting',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.champagne.withOpacity(0.85),
                            letterSpacing: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 60,
                          height: 1,
                          color: AppTheme.champagne.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                FadeTransition(
                  opacity: _taglineFade,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.champagne.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
