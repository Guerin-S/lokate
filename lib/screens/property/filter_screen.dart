import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  PropertyType? _type;
  String _city = 'Douala';
  RangeValues _priceRange = const RangeValues(50000, 500000);
  int _minBedrooms = 1;

  final List<String> _cities = ['Douala', 'Yaoundé', 'Bafoussam', 'Bamenda', 'Kribi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtres'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _type = null;
                _city = 'Douala';
                _priceRange = const RangeValues(50000, 500000);
                _minBedrooms = 1;
              });
            },
            child: const Text('Réinitialiser', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Type de logement',
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: [null, ...PropertyType.values].map((t) {
                final label = t == null ? 'Tous' : t.name[0].toUpperCase() + t.name.substring(1);
                final selected = _type == t;
                return GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
                    ),
                    child: Text(label, style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textSecondaryLight,
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Ville',
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: _cities.map((c) {
                final selected = _city == c;
                return GestureDetector(
                  onTap: () => setState(() => _city = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
                    ),
                    child: Text(c, style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textSecondaryLight,
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Budget mensuel (FCFA)',
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${_priceRange.start.toInt()} FCFA', style: AppTextStyles.label),
                  Text('${_priceRange.end.toInt()} FCFA', style: AppTextStyles.label),
                ]),
                RangeSlider(
                  values: _priceRange,
                  min: 10000,
                  max: 2000000,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _priceRange = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Chambres minimum',
            child: Row(
              children: [1, 2, 3, 4, 5].map((n) {
                final selected = _minBedrooms == n;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _minBedrooms = n),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
                      ),
                      child: Center(
                        child: Text('$n', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textSecondaryLight)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<PropertyService>().setFilter(PropertyFilter(
                type: _type,
                city: _city,
                minPrice: _priceRange.start,
                maxPrice: _priceRange.end,
                minBedrooms: _minBedrooms,
              ));
              context.pop();
            },
            child: const Text('Appliquer les filtres'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h4),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
