import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/property_service.dart';
import '../../services/theme_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_card_horizontal.dart';
import '../../widgets/badge_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedType = 0; // 0=Tous, 1=Appartement, 2=Studio, 3=Villa
  final List<String> _typeLabels = ['Tous', 'Appartement', 'Studio', 'Villa', 'Chambre'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyService>().fetchProperties();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final propertyService = context.watch<PropertyService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour ${user?.name.split(' ').first ?? ''} 👋',
                          style: AppTextStyles.h4.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          )),
                        const SizedBox(height: 2),
                        Text('Trouvez votre logement idéal',
                          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: themeService.toggleTheme,
                    icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => context.push('/messages'),
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GestureDetector(
                onTap: () => context.push('/filters'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text('Rechercher à Douala, Yaoundé...',
                        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.tune, color: AppColors.primary, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Type filter chips
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                itemCount: _typeLabels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    setState(() => _selectedType = i);
                    final filter = i == 0
                        ? const PropertyFilter()
                        : PropertyFilter(type: PropertyType.values[i - 1]);
                    context.read<PropertyService>().setFilter(filter);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedType == i ? AppColors.primary : (isDark ? AppColors.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedType == i ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                    ),
                    child: Text(_typeLabels[i], style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _selectedType == i ? Colors.white : AppColors.textSecondaryLight,
                    )),
                  ),
                ),
              ),
            ),

            // View tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('${propertyService.properties.length} logements trouvés',
                    style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _ViewToggle(icon: Icons.grid_view, selected: _tabController.index == 0,
                          onTap: () { _tabController.animateTo(0); setState(() {}); }),
                        _ViewToggle(icon: Icons.view_list, selected: _tabController.index == 1,
                          onTap: () { _tabController.animateTo(1); setState(() {}); }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Property list
            Expanded(
              child: propertyService.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : propertyService.properties.isEmpty
                      ? _EmptyState()
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            // Grid view
                            GridView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: propertyService.properties.length,
                              itemBuilder: (_, i) => PropertyCard(property: propertyService.properties[i]),
                            ),
                            // List view
                            ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              itemCount: propertyService.properties.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) => PropertyCardHorizontal(property: propertyService.properties[i]),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ViewToggle({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: selected ? Colors.white : AppColors.textSecondaryLight),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏚️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Aucun logement trouvé', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text('Modifiez vos filtres pour voir plus de résultats',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}
