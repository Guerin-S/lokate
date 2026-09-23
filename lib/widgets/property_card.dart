import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/models.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesService>();
    final isFav = favorites.isFavorite(property.id);

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
                    child: AppImage(
                      url: property.photoUrls.isNotEmpty ? property.photoUrls.first : null,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 0,
                      placeholderEmoji: '🏢',
                    ),
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
                  // Favorite button
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => favorites.toggle(property.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isFav ? AppColors.error : Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
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
                  // Certified badge
                  if (property.isCertified)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.badgeCertified, shape: BoxShape.circle),
                        child: const Icon(Icons.verified, color: Colors.white, size: 14),
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
