import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _verificationId = '';
  String _otp = '';
  bool _loading = true;
  bool _verifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  Future<void> _sendOtp() async {
    setState(() { _loading = true; _error = null; });
    await context.read<AuthService>().sendOtp(
      phone: widget.phone,
      onCodeSent: (id) => setState(() { _verificationId = id; _loading = false; }),
      onError: (e) => setState(() { _error = e; _loading = false; }),
    );
  }

  Future<void> _verify() async {
    if (_otp.length != 6) return;
    setState(() { _verifying = true; _error = null; });
    try {
      await context.read<AuthService>().verifyOtp(
        verificationId: _verificationId,
        smsCode: _otp,
        name: 'Utilisateur',
        role: UserRole.locataire,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _error = 'Code incorrect. Réessayez.');
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification SMS')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('📱', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            const Text('Code de vérification', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Nous avons envoyé un code SMS au\n${widget.phone}',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 40),
            if (_loading)
              const CircularProgressIndicator()
            else ...[
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (v) => setState(() => _otp = v),
                onCompleted: (_) => _verify(),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: AppColors.primaryLight,
                  inactiveFillColor: Colors.grey.shade50,
                  selectedFillColor: AppColors.primaryLight,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.borderLight,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _verifying || _otp.length != 6 ? null : _verify,
                child: _verifying
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Vérifier'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _sendOtp,
                child: const Text('Renvoyer le code', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
