import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class PropertyCardHorizontal extends StatelessWidget {
  final Property property;
  const PropertyCardHorizontal({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/property/${property.id}'),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: 120,
                child: property.photoUrls.isNotEmpty
                    ? Image.network(property.photoUrls.first, fit: BoxFit.cover)
                    : Container(color: AppColors.primaryLight,
                        child: const Center(child: Text('🏠', style: TextStyle(fontSize: 36)))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(property.title, style: AppTextStyles.label,
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                        if (property.isCertified)
                          const Icon(Icons.verified, color: AppColors.badgeCertified, size: 16),
                      ],
                    ),
                    Row(children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 2),
                      Text('${property.district}, ${property.city}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                    ]),
                    Row(children: [
                      const Icon(Icons.bed_outlined, size: 13, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text('${property.bedrooms} ch.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                      const SizedBox(width: 10),
                      const Icon(Icons.square_foot, size: 13, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text('${property.surface.toInt()} m²', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                    ]),
                    Text(property.priceLabel,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

