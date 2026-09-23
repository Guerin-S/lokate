import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo LOKATE premium — Sobre & pro
/// Utilisé sur Splash, AppBar, Onboarding
class LokateLogo extends StatelessWidget {
  final double size;
  final bool dark;
  final bool showTagline;

  const LokateLogo({
    super.key,
    this.size = 48,
    this.dark = false,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône maison premium
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: dark ? AppColors.gold : AppColors.primary,
                borderRadius: BorderRadius.circular(size * 0.22),
              ),
              child: Icon(
                Icons.home_rounded,
                color: dark ? AppColors.primaryDark : Colors.white,
                size: size * 0.52,
              ),
            ),
            SizedBox(width: size * 0.28),
            // Texte LOKATE
            Text(
              'LOKATE',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size * 0.62,
                fontWeight: FontWeight.w800,
                color: dark ? Colors.white : AppColors.primary,
                letterSpacing: 3.5,
                height: 1,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          SizedBox(height: size * 0.18),
          Text(
            'LOUE DEPUIS CHEZ TOI',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size * 0.15,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white.withValues(alpha: 0.65) : AppColors.textSecondaryLight,
              letterSpacing: 2.8,
            ),
          ),
        ],
      ],
    );
  }
}

/// Petite version pour AppBar
class LokateAppBarLogo extends StatelessWidget {
  const LokateAppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? AppColors.gold : AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.home_rounded,
            color: isDark ? AppColors.primaryDark : Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'LOKATE',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.primary,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }
}
