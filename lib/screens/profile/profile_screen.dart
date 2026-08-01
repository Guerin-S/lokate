import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/badge_chip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final themeService = context.watch<ThemeService>();

    return Scaffold(
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                            backgroundColor: Colors.white.withValues(alpha:0.2),
                            child: user.photoUrl == null
                                ? Text(user.name[0], style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(user.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(user.email, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges & rating
                        Row(children: [
                          if (user.isVerified) ...[BadgeChip.verified(), const SizedBox(width: 8)],
                          if (user.isTrusted) BadgeChip.trusted(),
                        ]),
                        if (user.ratingCount > 0) ...[
                          const SizedBox(height: 12),
                          Row(children: [
                            RatingBarIndicator(rating: user.rating, itemSize: 18,
                              itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber)),
                            const SizedBox(width: 8),
                            Text('${user.rating.toStringAsFixed(1)} (${user.ratingCount} avis)',
                              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
                          ]),
                        ],
                        const SizedBox(height: 24),

                        // Menu items
                        _MenuSection(title: 'Mon compte', items: [
                          _MenuItem(icon: Icons.person_outline, label: 'Informations personnelles', onTap: () {}),
                          _MenuItem(icon: Icons.phone_outlined, label: 'Téléphone : ${user.phone ?? "Non renseigné"}', onTap: () {}),
                          _MenuItem(icon: Icons.history, label: 'Historique des locations', onTap: () {}),
                        ]),
                        const SizedBox(height: 16),

                        _MenuSection(title: 'Préférences', items: [
                          _MenuItem(
                            icon: themeService.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            label: themeService.isDark ? 'Mode clair' : 'Mode sombre',
                            trailing: Switch(value: themeService.isDark, onChanged: (_) => themeService.toggleTheme(), activeThumbColor: AppColors.primary),
                            onTap: themeService.toggleTheme,
                          ),
                          _MenuItem(icon: Icons.language, label: 'Langue / Language', onTap: () {}),
                          _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                        ]),
                        const SizedBox(height: 16),

                        _MenuSection(title: 'Support', items: [
                          _MenuItem(icon: Icons.help_outline, label: 'Centre d\'aide', onTap: () {}),
                          _MenuItem(icon: Icons.shield_outlined, label: 'Confidentialité', onTap: () {}),
                          _MenuItem(icon: Icons.info_outline, label: 'À propos de LOKATE', onTap: () {}),
                        ]),
                        const SizedBox(height: 24),

                        OutlinedButton.icon(
                          onPressed: () async {
                            await context.read<AuthService>().signOut();
                            if (context.mounted) context.go('/auth/login');
                          },
                          icon: const Icon(Icons.logout, color: AppColors.error),
                          label: const Text('Se déconnecter', style: TextStyle(color: AppColors.error)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast) const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label, style: AppTextStyles.body2),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight, size: 18),
      onTap: onTap,
      dense: true,
    );
  }
}


