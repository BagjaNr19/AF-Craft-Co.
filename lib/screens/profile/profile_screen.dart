import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/af_button.dart';

class ProfileScreen extends StatelessWidget {
  final bool isEmbedded;

  const ProfileScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: isEmbedded
          ? null
          : AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, isEmbedded ? 24 : 16, 24, 40),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.champagne, AppTheme.mutedGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user?.initials ?? 'U',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkBrown,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'Pengguna',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 13,
                          color: AppTheme.champagne.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stats ─────────────────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      _StatItem(label: 'Pesanan', value: '0'),
                      _Divider(),
                      _StatItem(label: 'Wishlist', value: '0'),
                      _Divider(),
                      _StatItem(label: 'Ulasan', value: '0'),
                    ],
                  ),
                ),
              ),
            ),

            // ── Menu ──────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Akun Saya'),
                  const SizedBox(height: 12),
                  _MenuCard(
                    items: [
                      _MenuItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Edit Profil',
                          onTap: () {}),
                      _MenuItem(
                          icon: Icons.location_on_outlined,
                          label: 'Alamat Saya',
                          onTap: () {}),
                      _MenuItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Ubah Password',
                          onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('Informasi'),
                  const SizedBox(height: 12),
                  _MenuCard(
                    items: [
                      _MenuItem(
                          icon: Icons.info_outline_rounded,
                          label: 'Tentang Aplikasi',
                          onTap: () => _showAbout(context)),
                      _MenuItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Bantuan',
                          onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AfButton(
                    label: 'Keluar',
                    onPressed: () => _confirmLogout(context, auth),
                    isFullWidth: true,
                    variant: AfButtonVariant.outlined,
                    icon: Icons.logout_rounded,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'AF Craft & Co. v1.0.0',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        color: AppTheme.warmBrown.withOpacity(0.4),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Keluar',
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w700,
              color: AppTheme.darkBrown,
            )),
        content: Text('Apakah kamu yakin ingin keluar dari akun?',
            style: GoogleFonts.playfairDisplay(color: AppTheme.warmBrown)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.logout();
              if (context.mounted) {
                AppRoutes.pushAndClearStack(context, AppRoutes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.terracotta, AppTheme.dustyRose],
                ),
              ),
              child: const Icon(Icons.card_giftcard_rounded,
                  size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text('AF Craft & Co.',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkBrown,
                  fontSize: 18,
                )),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"The Art of Aesthetic Gifting"',
                style: GoogleFonts.playfairDisplay(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.warmBrown.withOpacity(0.8),
                )),
            const SizedBox(height: 12),
            Text('Aplikasi UAS Praktikum Pemrograman Mobile.\nVersi 1.0.0',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: AppTheme.warmBrown,
                )),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup')),
        ],
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkBrown,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 12,
                color: AppTheme.warmBrown.withOpacity(0.7),
              )),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFF0E8DF),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkBrown,
        ));
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                const Divider(
                    height: 1, indent: 56, color: Color(0xFFF5EDE0)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.softRose.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppTheme.terracotta),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkBrown,
                  )),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppTheme.warmBrown.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}
