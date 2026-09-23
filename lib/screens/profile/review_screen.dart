import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../services/auth_service.dart';
import '../../services/property_service.dart';
import '../../services/notification_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lokate_text_field.dart';
import '../../widgets/empty_states.dart';

// ─── Review Screen ────────────────────────────────────────────────────────────

class ReviewScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  const ReviewScreen(
      {super.key, required this.targetId, required this.targetType});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 4.0;
  final _commentCtrl = TextEditingController();
  bool _submitting = false;

  Future<void> _submit() async {
    if (_commentCtrl.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      final user = context.read<AuthService>().currentUser!;
      final review = Review(
        id: '',
        authorId: user.id,
        authorName: user.name,
        authorPhotoUrl: user.photoUrl,
        targetId: widget.targetId,
        targetType: widget.targetType,
        rating: _rating,
        comment: _commentCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      await context.read<PropertyService>().addReview(review);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avis publié avec succès !')));
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la publication')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laisser un avis')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('⭐', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            const Text('Votre expérience', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
                'Votre avis aide les autres utilisateurs à faire le bon choix.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textSecondaryLight)),
            const SizedBox(height: 28),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 6),
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: 8),
            Text(_ratingLabel(_rating),
                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            const SizedBox(height: 28),
            LokateTextField(
              controller: _commentCtrl,
              label: 'Votre commentaire',
              hint:
                  'Décrivez votre expérience avec ce logement / propriétaire...',
              maxLines: 5,
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
                  : const Text('Publier mon avis'),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r <= 1) return 'Très mauvais';
    if (r <= 2) return 'Mauvais';
    if (r <= 3) return 'Correct';
    if (r <= 4) return 'Bien';
    return 'Excellent !';
  }
}

// ─── Owner Dashboard ──────────────────────────────────────────────────────────

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon tableau de bord'),
        actions: [
          IconButton(
            onPressed: () => context.push('/owner/add-property'),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Ajouter un bien',
          ),
        ],
      ),
      body: user == null
          ? const LoadingOverlay(message: 'Chargement...')
          : FutureBuilder<List<Property>>(
              future:
                  context.read<PropertyService>().getOwnerProperties(user.id),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingOverlay(message: 'Chargement de vos biens...');
                }
                if (snapshot.hasError) {
                  return ErrorState(
                    onRetry: () {},
                  );
                }
                final properties = snapshot.data ?? [];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats row
                      Row(children: [
                        Expanded(
                            child: _StatCard(
                                value: '${properties.length}',
                                label: 'Biens publiés',
                                icon: Icons.home_outlined,
                                color: AppColors.primary)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _StatCard(
                                value:
                                    '${properties.where((p) => p.isAvailable).length}',
                                label: 'Disponibles',
                                icon: Icons.check_circle_outline,
                                color: AppColors.success)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _StatCard(
                                value:
                                    '${properties.where((p) => !p.isAvailable).length}',
                                label: 'Occupés',
                                icon: Icons.lock_outline,
                                color: AppColors.accent)),
                      ]),
                      const SizedBox(height: 28),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Mes logements',
                                style: AppTextStyles.h4),
                            TextButton.icon(
                              onPressed: () =>
                                  context.push('/owner/reservations'),
                              icon: const Icon(Icons.list_alt, size: 16),
                              label: const Text('Demandes'),
                            ),
                          ]),
                      const SizedBox(height: 12),

                      if (properties.isEmpty)
                        EmptyState(
                          emoji: '🏘️',
                          title: 'Aucun bien publié',
                          subtitle: 'Publiez votre premier logement pour commencer à recevoir des demandes.',
                          actionLabel: 'Publier un bien',
                          onAction: () => context.push('/owner/add-property'),
                        )
                      else
                        ...properties
                            .map((p) => _OwnerPropertyTile(property: p)),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/add-property'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter un bien',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha:0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color)),
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}

class _OwnerPropertyTile extends StatelessWidget {
  final Property property;
  const _OwnerPropertyTile({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 70,
              height: 70,
              child: property.photoUrls.isNotEmpty
                  ? Image.network(property.photoUrls.first, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.primaryLight,
                      child: const Center(
                          child: Text('🏠', style: TextStyle(fontSize: 28)))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.title,
                    style: AppTextStyles.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${property.district}, ${property.city}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 6),
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: property.isAvailable
                          ? AppColors.success.withValues(alpha:0.1)
                          : AppColors.error.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(property.isAvailable ? 'Disponible' : 'Occupé',
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: property.isAvailable
                                ? AppColors.success
                                : AppColors.error)),
                  ),
                  const SizedBox(width: 8),
                  Text(property.priceLabel,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ]),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'edit') {
                context.push('/owner/edit-property', extra: property);
              } else if (v == 'toggle') {
                await context.read<PropertyService>().toggleAvailability(property.id, !property.isAvailable);
                if (context.mounted) {
                  NotificationService.showInfo(context, property.isAvailable ? 'Marqué comme occupé' : 'Marqué comme disponible');
                }
              } else if (v == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Supprimer ce bien ?'),
                    content: const Text('Cette action est irréversible. Toutes les données seront perdues.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Supprimer', style: TextStyle(color: AppColors.error))),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await context.read<PropertyService>().deleteProperty(property.id);
                  if (context.mounted) {
                    NotificationService.showSuccess(context, 'Bien supprimé');
                  }
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Row(children: [
                Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Modifier'),
              ])),
              PopupMenuItem(value: 'toggle', child: Row(children: [
                Icon(property.isAvailable ? Icons.lock_outline : Icons.lock_open_outlined, size: 18),
                const SizedBox(width: 8),
                Text(property.isAvailable ? 'Marquer occupé' : 'Marquer disponible'),
              ])),
              const PopupMenuItem(value: 'delete', child: Row(children: [
                Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                SizedBox(width: 8),
                Text('Supprimer', style: TextStyle(color: AppColors.error)),
              ])),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Owner Reservations ───────────────────────────────────────────────────────

class OwnerReservationsScreen extends StatelessWidget {
  const OwnerReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demandes de location')),
      body: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('📋', style: TextStyle(fontSize: 56)),
        SizedBox(height: 16),
        Text('Aucune demande',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Text('Les demandes de vos locataires apparaîtront ici.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF6B7C8D))),
      ])),
    );
  }
}

class _ReservationTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final String status;

  const _ReservationTile(
      {required this.data, required this.docId, required this.status});

  Color get _statusColor {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'approved':
      case 'active':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'approved':
        return 'Approuvée';
      case 'active':
        return 'Active';
      case 'rejected':
        return 'Rejetée';
      case 'completed':
        return 'Terminée';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(data['tenantName'] ?? '', style: AppTextStyles.label),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(_statusLabel,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor)),
            ),
          ]),
          const SizedBox(height: 6),
          Text(data['propertyTitle'] ?? '',
              style: AppTextStyles.body2
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 4),
          Text(
              '${(data['amount'] ?? 0).toStringAsFixed(0)} FCFA / ${data['paymentFrequency'] == 'monthly' ? 'mois' : 'an'}',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          if (data['message'] != null &&
              data['message'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('"${data['message']}"',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontStyle: FontStyle.italic)),
          ],
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande refusée (démo)'))),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                    minimumSize: const Size(0, 38)),
                child: const Text('Refuser'),
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demande approuvée (démo)'))),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 38)),
                child: const Text('Approuver'),
              )),
            ]),
          ],
        ],
      ),
    );
  }
}

