import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final String reservationId;
  const PaymentScreen({super.key, required this.reservationId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? _reservation;
  bool _loading = true;
  bool _paying = false;
  PaymentMethod _method = PaymentMethod.mtnMomo;
  final _phoneCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('reservations').doc(widget.reservationId).get();
    setState(() { _reservation = doc.data(); _loading = false; });
  }

  Future<void> _pay() async {
    setState(() => _paying = true);
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'reservationId': widget.reservationId,
        'amount': _reservation!['amount'],
        'method': _method.name,
        'status': 'success',
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('reservations').doc(widget.reservationId).update({
        'status': ReservationStatus.active.name,
      });

      if (mounted) context.go('/contract/${widget.reservationId}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paiement échoué. Réessayez.')));
      }
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final amount = (_reservation?['amount'] ?? 0).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Montant à payer', style: TextStyle(color: Colors.white70, fontFamily: 'Poppins', fontSize: 13)),
                  const SizedBox(height: 8),
                  Text('${amount.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(_reservation?['paymentFrequency'] == 'monthly' ? 'Paiement mensuel' : 'Paiement annuel',
                    style: const TextStyle(color: Colors.white54, fontFamily: 'Poppins', fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Payment method selection
            const Text('Mode de paiement', style: AppTextStyles.h4),
            const SizedBox(height: 14),

            _PaymentMethodTile(
              method: PaymentMethod.mtnMomo,
              label: 'MTN Mobile Money',
              icon: '🟡',
              color: const Color(0xFFFFC400),
              selected: _method == PaymentMethod.mtnMomo,
              onTap: () => setState(() => _method = PaymentMethod.mtnMomo),
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              method: PaymentMethod.orangeMoney,
              label: 'Orange Money',
              icon: '🟠',
              color: const Color(0xFFFF6600),
              selected: _method == PaymentMethod.orangeMoney,
              onTap: () => setState(() => _method = PaymentMethod.orangeMoney),
            ),
            const SizedBox(height: 10),
            _PaymentMethodTile(
              method: PaymentMethod.stripe,
              label: 'Carte bancaire (Visa/MasterCard)',
              icon: '💳',
              color: AppColors.primary,
              selected: _method == PaymentMethod.stripe,
              onTap: () => setState(() => _method = PaymentMethod.stripe),
            ),
            const SizedBox(height: 24),

            // Payment form
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _method == PaymentMethod.stripe
                  ? _CardForm(cardCtrl: _cardCtrl, expiryCtrl: _expiryCtrl, cvvCtrl: _cvvCtrl)
                  : _MobileMoneyForm(ctrl: _phoneCtrl, method: _method),
            ),
            const SizedBox(height: 32),

            // Security badge
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.textSecondaryLight),
              const SizedBox(width: 6),
              Text('Paiement 100% sécurisé', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
            ]),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _paying ? null : _pay,
              child: _paying
                  ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Traitement en cours...'),
                    ])
                  : Text('Payer ${amount.toStringAsFixed(0)} FCFA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final String label, icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method, required this.label, required this.icon,
    required this.color, required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha:0.06) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : AppColors.borderLight, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.label)),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? color : Colors.transparent,
                border: Border.all(color: selected ? color : AppColors.borderLight, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileMoneyForm extends StatelessWidget {
  final TextEditingController ctrl;
  final PaymentMethod method;

  const _MobileMoneyForm({required this.ctrl, required this.method});

  @override
  Widget build(BuildContext context) {
    final isMtn = method == PaymentMethod.mtnMomo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Numéro ${isMtn ? "MTN" : "Orange"}', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: isMtn ? '6XX XXX XXX' : '6XX XXX XXX',
            prefixText: '+237 ',
            prefixStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
            prefixIcon: Text(isMtn ? '🟡' : '🟠', style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline, color: AppColors.warning, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vous recevrez un message de confirmation ${isMtn ? "MTN MoMo" : "Orange Money"} sur ce numéro.',
                style: AppTextStyles.caption.copyWith(color: AppColors.warning),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _CardForm extends StatelessWidget {
  final TextEditingController cardCtrl, expiryCtrl, cvvCtrl;
  const _CardForm({required this.cardCtrl, required this.expiryCtrl, required this.cvvCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Numéro de carte', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: cardCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card),
          ),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Expiration', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: expiryCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'MM/AA'),
            ),
          ])),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('CVV', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: cvvCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(hintText: '•••'),
            ),
          ])),
        ]),
      ],
    );
  }
}


