import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../data/cameroun.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Abonnements'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(20)),
                    child: const Text('POUR LES PROPRIÉTAIRES', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primaryDark, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 12),
                  const Text('Faites rayonner\nvos biens', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 8),
                  Text('Publiez sur les 10 régions, badge vérifié, top recherche.', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white.withValues(alpha: 0.7), height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Choisissez votre plan', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.primary)),
            const SizedBox(height: 4),
            Text('Changez ou annulez à tout moment.', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondaryLight)),
            const SizedBox(height: 16),
            // Tiers
            ...SubscriptionHelper.tiers.entries.map((e) {
              final tier = e.key;
              final data = e.value;
              final isPopular = tier == 'pro';
              final isPremium = tier == 'premium';
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPopular ? AppColors.gold : isPremium ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isPopular || isPremium ? 1.5 : 1,
                  ),
                  boxShadow: isPopular ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 4))] : [],
                ),
                child: Column(
                  children: [
                    if (isPopular)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                        child: const Text('★ LE PLUS POPULAIRE', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryDark, letterSpacing: 1)),
                      ),
                    if (isPremium)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                        child: const Text('◆ PRESTIGE', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(color: Color(data['color'] as int).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                                child: Icon(tier == 'gratuit' ? Icons.home_outlined : tier == 'decouverte' ? Icons.star_outline : tier == 'pro' ? Icons.workspace_premium_outlined : Icons.diamond_outlined, color: Color(data['color'] as int)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(data['name'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.primary)),
                                  Text('${data['maxProperties'] == 999 ? 'Illimité' : '${data['maxProperties']} biens'}', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondaryLight)),
                                ]),
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  Text('${data['price']}', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.primary)),
                                  const SizedBox(width: 2),
                                  Padding(padding: const EdgeInsets.only(bottom: 3), child: Text('FCFA', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight))),
                                ]),
                                Text('/mois', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textTertiaryLight)),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ... (data['features'] as List<String>).map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(children: [
                              Container(width: 18, height: 18, decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.check, size: 12, color: AppColors.success)),
                              const SizedBox(width: 8),
                              Text(f, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight)),
                            ]),
                          )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Abonnement ${data['name']} — bientôt disponible !'), backgroundColor: AppColors.primary));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPopular ? AppColors.gold : isPremium ? AppColors.primary : (isDark ? AppColors.surfaceMutedDark : AppColors.primary),
                                foregroundColor: isPopular ? AppColors.primaryDark : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(tier == 'gratuit' ? 'Commencer gratuit' : 'Choisir ${data['name']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Center(child: Text('Paiement par MTN MoMo • Orange Money • Carte', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textTertiaryLight))),
            const SizedBox(height: 4),
            Center(child: TextButton(onPressed: () => context.pop(), child: const Text('Plus tard', style: TextStyle(fontFamily: 'Poppins', fontSize: 13)))),
          ],
        ),
      ),
    );
  }
}
