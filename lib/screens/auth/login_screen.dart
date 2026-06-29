import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/af_button.dart';
import '../../widgets/af_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      AppRoutes.pushAndClearStack(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background blobs ──────────────────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.softRose.withOpacity(0.35),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.champagne.withOpacity(0.3),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.08),

                      // ── Brand ──────────────────────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.terracotta,
                                    AppTheme.dustyRose,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.terracotta.withOpacity(0.30),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.card_giftcard_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'AF Craft & Co.',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkBrown,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'The Art of Aesthetic Gifting',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.warmBrown.withOpacity(0.7),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.06),

                      Text(
                        'Selamat Datang',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Masuk ke akun Anda untuk melanjutkan',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          color: AppTheme.warmBrown.withOpacity(0.7),
                        ),
                      ),

                      const SizedBox(height: 36),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AfTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'nama@email.com',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                                    .hasMatch(v)) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AfTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.warmBrown.withOpacity(0.6),
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (v.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Lupa Password?'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            AfButton(
                              label: 'Masuk',
                              onPressed: auth.isLoading ? null : _handleLogin,
                              isLoading: auth.isLoading,
                              isFullWidth: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: AppTheme.softRose.withOpacity(0.6))),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'atau',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 13,
                                color: AppTheme.warmBrown.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: AppTheme.softRose.withOpacity(0.6))),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14,
                              color: AppTheme.warmBrown.withOpacity(0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                AppRoutes.push(context, AppRoutes.register),
                            child: Text(
                              'Daftar Sekarang',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.terracotta,
                                decoration: TextDecoration.underline,
                                decorationColor: AppTheme.terracotta,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
