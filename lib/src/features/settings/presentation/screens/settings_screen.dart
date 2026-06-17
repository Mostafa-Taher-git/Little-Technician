import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile card
          FutureBuilder<UserModel?>(
            future: AuthService.getCurrentUser(),
            builder: (_, snap) {
              final user = snap.data;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [scheme.surface, scheme.surface.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(user?.avatarIcon ?? '🔧', style: const TextStyle(fontSize: 28)),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.username ?? 'User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                          Text('Points: ${0}', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Gap(24),

          // Section: Account
          Text('Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface.withValues(alpha: 0.6), letterSpacing: 0.5)),
          const Gap(10),
          _SettingsTile(
            icon: Icons.swap_horiz,
            label: 'Switch Account',
            onTap: () => Nav.replaceAll(context, const LoginScreen()),
            scheme: scheme,
          ),
          const Gap(8),
          _SettingsTile(
            icon: Icons.info_outline,
            label: 'About LittleTech',
            subtitle: 'Version 2.0.0',
            onTap: () => _showAboutDialog(context),
            scheme: scheme,
          ),
          const Gap(24),

          // Section: Danger zone
          Text('Session', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface.withValues(alpha: 0.6), letterSpacing: 0.5)),
          const Gap(10),
          _SettingsTile(
            icon: Icons.logout,
            label: 'Logout',
            iconColor: scheme.error,
            textColor: scheme.error,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Logout', style: TextStyle(color: scheme.error)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await AuthService.logout();
                if (context.mounted) Nav.replaceAll(context, const LoginScreen());
              }
            },
            scheme: scheme,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.build_circle_rounded, color: Colors.white70, size: 20),
            ),
            const Gap(10),
            const Text('LittleTech'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expert Troubleshooting System', style: TextStyle(fontWeight: FontWeight.w600)),
            Gap(4),
            Text('Version 2.0.0', style: TextStyle(color: Colors.white60, fontSize: 13)),
            Gap(12),
            Text(
              'LittleTech helps you solve common computer hardware and software problems with step-by-step solutions across 11 categories.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.iconColor,
    this.textColor,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? scheme.primary;
    final effectiveTextColor = textColor ?? scheme.onSurface;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: effectiveIconColor, size: 20),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: effectiveTextColor)),
                    if (subtitle != null)
                      Text(subtitle!, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurface.withValues(alpha: 0.6), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
