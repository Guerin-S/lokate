import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/property_service.dart';
import '../../services/search_service.dart';
import '../../services/theme_service.dart';
import '../../models/models.dart';
import '../../data/cameroun.dart';
import '../../theme/app_theme.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_card_horizontal.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/empty_states.dart';
import '../../widgets/lokate_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedType = 0;
  String _selectedRegion = 'Tout';
  final List<String> _typeLabels = ['Tous', 'Appartement', 'Studio', 'Villa', 'Chambre', 'Maison', 'Duplex', 'Terrain', 'Bureau', 'Commerce'];
  bool _showSearch = false;
  final _searchCtrl = TextEditingController();

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
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;
    final propertyService = context.watch<PropertyService>();
    final searchService = context.watch<SearchService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDark;

    final displayProperties = searchService.query.isNotEmpty
        ? searchService.results
        : propertyService.properties;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header premium
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const LokateAppBarLogo(),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                    ),
                    child: const Text('10 RÉGIONS', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.8)),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: themeService.toggleTheme,
                    icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20),
                    style: IconButton.styleFrom(backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceMutedLight),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => context.push('/messages'),
                        icon: const Icon(Icons.notifications_outlined, size: 20),
                        style: IconButton.styleFrom(backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceMutedLight),
                      ),
                      Positioned(
                        top: 6, right: 6,
                        child: Container(width: 8, height: 8,
                          decoration: BoxDecoration(color: AppColors.gold, shape: BoxShape.circle, border: Border.all(color: isDark ? AppColors.bgDark : Colors.white, width: 1.5))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
                        Text('Tout le Cameroun, tout type de bien',
                          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar premium
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: GestureDetector(
                onTap: () => setState(() => _showSearch = !_showSearch),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: _showSearch ? 4 : 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
                  ),
                  child: _showSearch
                      ? Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Rechercher dans les 10 régions...',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (v) => searchService.search(v),
                              ),
                            ),
                            if (_searchCtrl.text.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  _searchCtrl.clear();
                                  searchService.clear();
                                },
                                icon: const Icon(Icons.close, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Text('Rechercher • 10 régions • Tout type',
                              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
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

            // Type filter chips — Tout type (10)
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                itemCount: _typeLabels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final isSelected = _selectedType == i;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedType = i);
                      final filter = i == 0
                          ? const PropertyFilter()
                          : PropertyFilter(type: PropertyType.values[i - 1]);
                      context.read<PropertyService>().setFilter(filter);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (i > 0) ...[
                            Text(PropertyTypeHelper.icons[PropertyType.values[i - 1].name] ?? '🏠', style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 4),
                          ],
                          Text(_typeLabels[i], style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Région filter — 10 régions
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                itemCount: CamerounData.regions.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (_, i) {
                  final label = i == 0 ? 'Toutes régions' : CamerounData.regions[i - 1].name;
                  final isSelected = _selectedRegion == label;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRegion = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gold : (isDark ? AppColors.surfaceDark : AppColors.surfaceMutedLight),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? AppColors.gold : Colors.transparent),
                      ),
                      child: Text(label, style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primaryDark : AppColors.textSecondaryLight,
                      )),
                    ),
                  );
                },
              ),
            ),

            // View tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('${displayProperties.length} logements trouvés',
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
              child: propertyService.isLoading || searchService.isSearching
                  ? _buildSkeleton()
                  : displayProperties.isEmpty
                      ? searchService.query.isNotEmpty
                          ? EmptyState(
                              emoji: '🔍',
                              title: 'Aucun résultat',
                              subtitle: 'Aucun logement ne correspond à "${searchService.query}". Essayez avec d\'autres mots-clés.',
                            )
                          : const EmptyState(
                              emoji: '🏚️',
                              title: 'Aucun logement trouvé',
                              subtitle: 'Modifiez vos filtres pour voir plus de résultats.',
                            )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            await context.read<PropertyService>().fetchProperties();
                          },
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Grid view
                              GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: displayProperties.length,
                                itemBuilder: (_, i) => PropertyCard(property: displayProperties[i]),
                              ),
                              // List view
                              ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                                itemCount: displayProperties.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (_, i) => PropertyCardHorizontal(property: displayProperties[i]),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return TabBarView(
      controller: _tabController,
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 6,
          itemBuilder: (_, i) => const PropertyCardSkeleton(),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          itemCount: 4,
          itemBuilder: (_, i) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: PropertyCardHorizontalSkeleton(),
          ),
        ),
      ],
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
