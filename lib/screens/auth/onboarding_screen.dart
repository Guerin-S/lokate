import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.map_rounded,
      title: 'Tout le Cameroun',
      subtitle: '10 régions, 50+ villes. De Douala à Maroua, trouvez votre logement partout au Cameroun depuis votre téléphone.',
      features: ['Yaoundé • Douala • Bafoussam', 'Garoua • Bamenda • Buea', '10 régions couvertes'],
    ),
    _OnboardingPage(
      icon: Icons.view_in_ar_rounded,
      title: 'Visite 360° immersive',
      subtitle: 'Photos HD et visite virtuelle pour chaque bien. Visitez sans vous déplacer, comme si vous y étiez.',
      features: ['Photos HD', 'Visite 360°', 'Tout type : villa, terrain, bureau...'],
    ),
    _OnboardingPage(
      icon: Icons.payments_rounded,
      title: 'Payez & signez en ligne',
      subtitle: 'MTN MoMo, Orange Money, carte. Contrat digital signé en 2 minutes. 100% sécurisé.',
      features: ['MTN MoMo • Orange Money', 'Contrat en ligne', 'Paiement sécurisé'],
    ),
    _OnboardingPage(
      icon: Icons.workspace_premium_rounded,
      title: 'Devenez propriétaire Pro',
      subtitle: 'Publiez en illimité, badge vérifié, top recherche. Abonnement dès 5 000 FCFA/mois.',
      features: ['Dès 5 000 FCFA/mois', 'Badge Vérifié & Premium', 'Support dédié'],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i], isDark),
          ),
          // Skip
          Positioned(
            top: 52,
            right: 16,
            child: TextButton(
              onPressed: _finish,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondaryLight,
                backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              ),
              child: const Text('Passer', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
          // Bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.gold,
                    dotColor: AppColors.borderLight,
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3.5,
                    spacing: 6,
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Commencer  →' : 'Suivant',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_currentPage + 1} / ${_pages.length}',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiaryLight, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 140),
      child: Column(
        children: [
          // Icon premium
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.18), width: 1),
            ),
            child: Icon(page.icon, size: 52, color: AppColors.gold),
          ),
          const SizedBox(height: 28),
          // Gold line
          Container(width: 40, height: 3, decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.primary,
              letterSpacing: -0.7,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ...page.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(f, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> features;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.features,
  });
}
