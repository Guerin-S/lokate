import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SocialAuthButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const SocialAuthButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
