import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lokate_text_field.dart';

class BookingScreen extends StatefulWidget {
  final String propertyId;
  const BookingScreen({super.key, required this.propertyId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Property? _property;
  bool _loading = true;
  bool _submitting = false;
  PaymentFrequency _frequency = PaymentFrequency.monthly;
  DateTime _startDate = DateTime.now().add(const Duration(days: 3));
  final _messageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p =
        await context.read<PropertyService>().getProperty(widget.propertyId);
    setState(() {
      _property = p;
      _loading = false;
    });
  }

  double get _amount {
    if (_property == null) return 0;
    final base = _property!.exactPrice ?? _property!.minPrice ?? 0;
    return _frequency == PaymentFrequency.yearly ? base * 12 * 0.9 : base;
  }

  Future<void> _submit() async {
    if (_property == null) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final mockId = 'res_${DateTime.now().millisecondsSinceEpoch}';
    if (_property!.reservationMode == ReservationMode.immediate) {
      context.go('/payment/$mockId');
    } else {
      _showSuccess();
    }
    if (mounted) setState(() => _submitting = false);
  }

  void _showSuccess() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('✅', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                const Text('Demande envoyée !', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(
                    'Le propriétaire examinera votre demande et vous contactera.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2
                        .copyWith(color: AppColors.textSecondaryLight)),
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/home');
                    },
                    child: const Text('Retour à l\'accueil')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_property == null) {
      return const Scaffold(body: Center(child: Text('Logement introuvable')));
    }

    final p = _property!;

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver ce logement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: p.photoUrls.isNotEmpty
                          ? Image.network(p.photoUrls.first, fit: BoxFit.cover)
                          : Container(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              child: const Center(
                                  child: Text('🏠',
                                      style: TextStyle(fontSize: 30)))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(p.title,
                            style: AppTextStyles.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('${p.district}, ${p.city}',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondaryLight)),
                        const SizedBox(height: 4),
                        Text(p.priceLabel,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ])),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Frequency
            const Text('Fréquence de paiement', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _FrequencyCard(
                label: 'Mensuel',
                sublabel:
                    '${(p.exactPrice ?? p.minPrice ?? 0).toStringAsFixed(0)} FCFA/mois',
                selected: _frequency == PaymentFrequency.monthly,
                onTap: () =>
                    setState(() => _frequency = PaymentFrequency.monthly),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _FrequencyCard(
                label: 'Annuel',
                sublabel: '-10% de réduction',
                selected: _frequency == PaymentFrequency.yearly,
                onTap: () =>
                    setState(() => _frequency = PaymentFrequency.yearly),
                badge: '-10%',
              )),
            ]),
            const SizedBox(height: 24),

            // Start date
            const Text('Date d\'emménagement', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _startDate = date);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      style: AppTextStyles.body1),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textSecondaryLight),
                ]),
              ),
            ),
            const SizedBox(height: 24),

            // Message
            const Text('Message au propriétaire (optionnel)',
                style: AppTextStyles.h4),
            const SizedBox(height: 12),
            LokateTextField(
              controller: _messageCtrl,
              label: '',
              hint: 'Présentez-vous et expliquez votre situation...',
              maxLines: 4,
            ),
            const SizedBox(height: 28),

            // Price summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Loyer de base',
                          style: AppTextStyles.body2
                              .copyWith(color: AppColors.textSecondaryLight)),
                      Text(
                          '${(p.exactPrice ?? p.minPrice ?? 0).toStringAsFixed(0)} FCFA',
                          style: AppTextStyles.body2),
                    ]),
                if (_frequency == PaymentFrequency.yearly) ...[
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Réduction annuelle',
                            style: AppTextStyles.body2
                                .copyWith(color: AppColors.success)),
                        Text('-10%',
                            style: AppTextStyles.body2
                                .copyWith(color: AppColors.success)),
                      ]),
                ],
                const Divider(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total à payer', style: AppTextStyles.label),
                      Text('${_amount.toStringAsFixed(0)} FCFA',
                          style: AppTextStyles.price),
                    ]),
                Text(
                    _frequency == PaymentFrequency.yearly
                        ? 'par an'
                        : 'par mois',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondaryLight)),
              ]),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(p.reservationMode == ReservationMode.immediate
                      ? 'Continuer vers le paiement'
                      : 'Envoyer la demande'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  final String label, sublabel;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  const _FrequencyCard(
      {required this.label,
      required this.sublabel,
      required this.selected,
      required this.onTap,
      this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primaryLight : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.borderLight,
              width: selected ? 2 : 1),
        ),
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimaryLight)),
              const SizedBox(height: 4),
              Text(sublabel,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondaryLight)),
            ]),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(badge!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
