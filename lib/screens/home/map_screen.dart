import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/property_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Property? _selectedProperty;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final properties = context.watch<PropertyService>().properties;

    return Scaffold(
      body: Stack(
        children: [
          // Placeholder map premium
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.bgDark, AppColors.surfaceDark]
                    : [AppColors.primaryLight, Colors.white],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.map_rounded, size: 44, color: AppColors.gold),
                  ),
                  const SizedBox(height: 16),
                  Text('Carte interactive', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.primary)),
                  const SizedBox(height: 6),
                  Text('Bientôt disponible', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                    child: const Text('10 RÉGIONS • TOUT LE CAMEROUN', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.8)),
                  ),
                ],
              ),
            ),
          ),

          // Search bar overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16, right: 16,
            child: GestureDetector(
              onTap: () => context.push('/filters'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text('Rechercher sur la carte...', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textSecondaryLight)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.tune, color: AppColors.gold, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Counter badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
              child: Text('${properties.length} logements', style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ),
          ),

          // Quick list bottom
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Text('À proximité', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.primary)),
                      const Spacer(),
                      Text('${properties.length} résultats', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textSecondaryLight)),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: properties.length > 6 ? 6 : properties.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final p = properties[i];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedProperty = p),
                          child: SizedBox(
                            width: 160,
                            child: PropertyCard(property: p),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Selected property card (overlay on list)
          if (_selectedProperty != null)
            Positioned(
              bottom: 230, left: 16, right: 16,
              child: _PropertyMapCard(
                property: _selectedProperty!,
                onClose: () => setState(() => _selectedProperty = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _PropertyMapCard extends StatelessWidget {
  final Property property;
  final VoidCallback onClose;

  const _PropertyMapCard({required this.property, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80, height: 80,
              child: property.photoUrls.isNotEmpty
                  ? Image.network(property.photoUrls.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.primaryLight, child: const Center(child: Text('🏠', style: TextStyle(fontSize: 28)))) )
                  : Container(color: AppColors.primaryLight, child: const Center(child: Text('🏠', style: TextStyle(fontSize: 28)))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on, size: 11, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 2),
                  Expanded(child: Text('${property.district}, ${property.city}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textSecondaryLight), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 8),
                Text(property.priceLabel, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClose, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              ElevatedButton(
                onPressed: () => context.push('/property/${property.id}'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(60, 32), padding: const EdgeInsets.symmetric(horizontal: 12), textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600)),
                child: const Text('Voir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
