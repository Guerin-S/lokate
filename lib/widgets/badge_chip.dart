import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const BadgeChip({super.key, required this.label, required this.icon, required this.color});

  factory BadgeChip.verified() => const BadgeChip(label: 'Vérifié', icon: Icons.verified_user, color: AppColors.badgeVerified);
  factory BadgeChip.certified() => const BadgeChip(label: 'Certifié', icon: Icons.verified, color: AppColors.badgeCertified);
  factory BadgeChip.trusted() => const BadgeChip(label: 'Fiable', icon: Icons.shield, color: AppColors.badgeTrusted);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}


