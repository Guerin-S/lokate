import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lokate_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final int initialAuthMethod;

  const RegisterScreen({super.key, this.initialAuthMethod = 0});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;
  UserRole _role = UserRole.locataire;
  int _authMethod = 0; // 0=email, 1=phone

  @override
  void initState() {
    super.initState();
    _authMethod = widget.initialAuthMethod;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_authMethod == 0) {
        final ok = await context.read<AuthService>().registerWithEmail(
              name: _nameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
              role: _role,
            );
        if (ok && mounted) context.go('/home');
      } else {
        final phone = '+237${_phoneCtrl.text.trim()}';
        if (mounted) context.push('/auth/otp', extra: phone);
      }
    } catch (e) {
      setState(() => _error =
          'Inscription échouée. Vérifiez votre configuration Firebase ou continuez en mode démo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Créer un compte'),
          leading: BackButton(onPressed: () => context.pop())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Role selector
              const Text('Je suis...', style: AppTextStyles.h4),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _RoleCard(
                    emoji: '🔍',
                    label: 'Locataire',
                    selected: _role == UserRole.locataire,
                    onTap: () => setState(() => _role = UserRole.locataire),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _RoleCard(
                    emoji: '🏠',
                    label: 'Propriétaire',
                    selected: _role == UserRole.proprietaire,
                    onTap: () => setState(() => _role = UserRole.proprietaire),
                  )),
                ],
              ),
              const SizedBox(height: 28),

              // Auth method tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                        child: _TabButton(
                            label: 'Email',
                            selected: _authMethod == 0,
                            onTap: () => setState(() => _authMethod = 0))),
                    Expanded(
                        child: _TabButton(
                            label: 'Téléphone',
                            selected: _authMethod == 1,
                            onTap: () => setState(() => _authMethod = 1))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(_error!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],

              LokateTextField(
                  controller: _nameCtrl,
                  label: 'Nom complet',
                  hint: 'Jean Dupont',
                  prefixIcon: Icons.person_outlined,
                  validator: (v) => v!.length > 2 ? null : 'Nom trop court'),
              const SizedBox(height: 14),

              if (_authMethod == 0) ...[
                LokateTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'votre@email.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) =>
                        v!.contains('@') ? null : 'Email invalide'),
                const SizedBox(height: 14),
                LokateTextField(
                    controller: _passwordCtrl,
                    label: 'Mot de passe',
                    hint: '••••••••',
                    obscureText: _obscure,
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure)),
                    validator: (v) =>
                        v!.length >= 6 ? null : '6 caractères minimum'),
              ] else ...[
                LokateTextField(
                    controller: _phoneCtrl,
                    label: 'Numéro de téléphone',
                    hint: '6XX XXX XXX',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    prefix: const Text('+237 ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                    validator: (v) =>
                        v!.length == 9 ? null : '9 chiffres requis'),
              ],

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(_authMethod == 0
                        ? 'Créer mon compte'
                        : 'Envoyer le code SMS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji, label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard(
      {required this.emoji,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.grey.shade50,
          border: Border.all(
              color: selected ? AppColors.primary : Colors.grey.shade200,
              width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8)
                ]
              : [],
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondaryLight)),
        ),
      ),
    );
  }
}
