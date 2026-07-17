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

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '🔍',
      title: 'Trouvez votre logement',
      titleEn: 'Find your home',
      subtitle: 'Parcourez des centaines d\'appartements, studios et villas à Douala et Yaoundé depuis votre téléphone.',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      emoji: '🎥',
      title: 'Visite virtuelle 360°',
      titleEn: 'Virtual 360° tour',
      subtitle: 'Visitez chaque pièce en détail sans bouger de chez vous grâce à notre galerie interactive 360°.',
      color: AppColors.accent,
    ),
    _OnboardingPage(
      emoji: '📱',
      title: 'Payez en Mobile Money',
      titleEn: 'Pay with Mobile Money',
      subtitle: 'MTN MoMo, Orange Money ou carte bancaire — choisissez le mode de paiement qui vous convient.',
      color: const Color(0xFF10B981),
    ),
    _OnboardingPage(
      emoji: '🔑',
      title: 'Signez en ligne',
      titleEn: 'Sign online',
      subtitle: 'Contrat signé, clés récupérées — tout se fait sans paperasse inutile.',
      color: const Color(0xFF8B5CF6),
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
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i]),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _finish,
              child: Text(
                'Passer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: _pages[_currentPage].color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: _pages[_currentPage].color,
                    dotColor: Colors.grey.shade300,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.1),
              ),
              child: Center(
                child: Text(page.emoji, style: const TextStyle(fontSize: 100)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.title,
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.subtitle,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String titleEn;
  final String subtitle;
  final Color color;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.titleEn,
    required this.subtitle,
    required this.color,
  });
}
