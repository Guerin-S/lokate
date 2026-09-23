import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationService {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.success, Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.error, Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.primary, Icons.info_outline);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.warning, Icons.warning_amber_outlined);
  }

  static void _showSnackBar(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
            ),
          ],
        ),
        backgroundColor: color,
      ),
    );
  }
}
