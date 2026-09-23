import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class ContractScreen extends StatefulWidget {
  final String reservationId;
  const ContractScreen({super.key, required this.reservationId});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  Map<String, dynamic>? _reservation;
  bool _loading = true;
  bool _accepted = false;
  bool _signing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() { _reservation = {'propertyTitle': 'Logement', 'tenantId': 'user', 'ownerId': 'owner', 'startDate': DateTime.now(), 'amount': 250000.0}; _loading = false; });
  }

  Future<void> _sign() async {
    if (!_accepted) return;
    setState(() => _signing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) _showSuccess();
    if (mounted) setState(() => _signing = false);
  }

  void _showSuccess() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🎉', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        const Text('Contrat signé !', style: AppTextStyles.h3, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Félicitations ! Votre contrat de location a été signé avec succès.',
          textAlign: TextAlign.center, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
      ]),
      actions: [
        ElevatedButton(
          onPressed: () { Navigator.pop(context); context.go('/home'); },
          child: const Text('Retour à l\'accueil'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Contrat de location')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(children: [
                      const Text('📄', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      Text('CONTRAT DE LOCATION', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                      Text('LOKATE — ${DateTime.now().year}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  _ContractSection(title: 'Bien loué', content: _reservation?['propertyTitle'] ?? ''),
                  _ContractSection(title: 'Date de début', content: _formatDate(_reservation?['startDate'])),
                  _ContractSection(title: 'Loyer', content: '${(_reservation?['amount'] ?? 0).toStringAsFixed(0)} FCFA'),
                  _ContractSection(title: 'Fréquence', content: _reservation?['paymentFrequency'] == 'monthly' ? 'Mensuel' : 'Annuel'),

                  const Divider(height: 32),
                  const Text('Conditions générales', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  _contractText(),
                  const SizedBox(height: 24),

                  // Accept checkbox
                  GestureDetector(
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            color: _accepted ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _accepted ? AppColors.primary : AppColors.borderLight, width: 2),
                          ),
                          child: _accepted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('J\'ai lu et j\'accepte les conditions générales du contrat de location.',
                            style: AppTextStyles.body2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: ElevatedButton.icon(
              onPressed: (_accepted && !_signing) ? _sign : null,
              icon: const Icon(Icons.draw_outlined, size: 18),
              label: _signing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Signer le contrat'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return '—';
    DateTime date;
    if (ts is DateTime) {
      date = ts;
    } else {
      try {
        date = (ts as dynamic).toDate() as DateTime;
      } catch (_) {
        date = DateTime.now();
      }
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _contractText() {
    const text = '''
Article 1 – OBJET DU CONTRAT
Le présent contrat a pour objet la location du bien immobilier décrit ci-dessus, conclu via la plateforme LOKATE.

Article 2 – DURÉE
Le contrat prend effet à la date de début indiquée et se renouvelle automatiquement selon la fréquence choisie, sauf résiliation avec un préavis de 30 jours.

Article 3 – LOYER ET CHARGES
Le locataire s'engage à payer le loyer aux échéances convenues. Tout retard de paiement entraîne des pénalités de 5% par semaine de retard.

Article 4 – OBLIGATIONS DU LOCATAIRE
Le locataire s'engage à :
• Utiliser le bien conformément à sa destination (usage d'habitation)
• Entretenir le bien en bon état
• Ne pas sous-louer sans accord écrit du propriétaire

Article 5 – OBLIGATIONS DU PROPRIÉTAIRE
Le propriétaire s'engage à :
• Délivrer le bien en bon état d'usage
• Assurer la jouissance paisible du bien
• Effectuer les réparations nécessaires

Article 6 – RÉSILIATION
Chacune des parties peut résilier le contrat sous réserve de respecter un préavis de 30 jours par notification via la plateforme LOKATE.

Article 7 – DROIT APPLICABLE
Le présent contrat est soumis au droit camerounais et aux lois en vigueur en matière de baux d'habitation.
''';
    return Text(text, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight, height: 1.6));
  }
}

class _ContractSection extends StatelessWidget {
  final String title, content;
  const _ContractSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(title, style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight))),
          Expanded(child: Text(content, style: AppTextStyles.body2)),
        ],
      ),
    );
  }
}
