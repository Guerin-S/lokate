import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: property.photoUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: property.photoUrls.first,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: Colors.grey.shade200,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                            errorWidget: (_, __, ___) => _PlaceholderImage(type: property.type),
                          )
                        : _PlaceholderImage(type: property.type),
                  ),
                  // Badge disponibilité
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: property.isAvailable ? AppColors.success : AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        property.isAvailable ? 'Disponible' : 'Occupé',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  // Certified badge
                  if (property.isCertified)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.badgeCertified, shape: BoxShape.circle),
                        child: const Icon(Icons.verified, color: Colors.white, size: 14),
                      ),
                    ),
                  // 360 badge
                  if (property.tour360Urls.isNotEmpty)
                    Positioned(
                      bottom: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.threesixty, color: Colors.white, size: 12),
                            SizedBox(width: 3),
                            Text('360°', style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title, style: AppTextStyles.label,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text('${property.district}, ${property.city}',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (property.ratingCount > 0)
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: property.rating,
                          itemSize: 12,
                          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                        ),
                        const SizedBox(width: 4),
                        Text('(${property.ratingCount})',
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                      ],
                    ),
                  const SizedBox(height: 6),
                  Text(property.priceLabel,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final PropertyType type;
  const _PlaceholderImage({required this.type});

  @override
  Widget build(BuildContext context) {
    final emojis = {
      PropertyType.appartement: '🏢',
      PropertyType.studio: '🏠',
      PropertyType.villa: '🏡',
      PropertyType.chambre: '🛏️',
      PropertyType.autre: '🏘️',
    };
    return Container(
      color: AppColors.primaryLight,
      child: Center(child: Text(emojis[type] ?? '🏠', style: const TextStyle(fontSize: 40))),
    );
  }
}


