import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../services/property_service.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/badge_chip.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  Property? _property;
  List<Review> _reviews = [];
  bool _loading = true;
  final _pageController = PageController();
  int _currentPhoto = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = context.read<PropertyService>();
    final [property, reviews] = await Future.wait([
      service.getProperty(widget.propertyId),
      service.getPropertyReviews(widget.propertyId),
    ]);
    setState(() {
      _property = property as Property?;
      _reviews = reviews as List<Review>;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_property == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Logement introuvable')));

    final p = _property!;
    final user = context.watch<AuthService>().currentUser;
    final isOwner = user?.id == p.ownerId;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Photo gallery app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(icon: const Icon(Icons.arrow_back, size: 20), onPressed: () => context.pop()),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: const Icon(Icons.favorite_border, size: 20), onPressed: () {}),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: p.photoUrls.isEmpty ? 1 : p.photoUrls.length,
                    onPageChanged: (i) => setState(() => _currentPhoto = i),
                    itemBuilder: (_, i) => p.photoUrls.isNotEmpty
                        ? CachedNetworkImage(imageUrl: p.photoUrls[i], fit: BoxFit.cover, width: double.infinity)
                        : Container(color: AppColors.primaryLight, child: const Center(child: Text('🏠', style: TextStyle(fontSize: 80)))),
                  ),
                  if (p.photoUrls.length > 1)
                    Positioned(
                      bottom: 16, left: 0, right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: p.photoUrls.length,
                          effect: const WormEffect(dotHeight: 6, dotWidth: 6, activeDotColor: Colors.white, dotColor: Colors.white54),
                        ),
                      ),
                    ),
                  if (p.tour360Urls.isNotEmpty)
                    Positioned(
                      bottom: 16, right: 16,
                      child: GestureDetector(
                        onTap: () => context.push('/property/${p.id}/tour'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.threesixty, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text('Visite 360°', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + type
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                        child: Text(p.type.name.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, fontFamily: 'Poppins')),
                      ),
                      const SizedBox(width: 8),
                      if (p.isCertified) BadgeChip.certified(),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: p.isAvailable ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p.isAvailable ? '✓ Disponible' : '✗ Occupé',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins',
                            color: p.isAvailable ? AppColors.success : AppColors.error)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(p.title, style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 4),
                    Text('${p.address}, ${p.district}, ${p.city}',
                      style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
                  ]),
                  const SizedBox(height: 16),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Loyer mensuel', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                          Text(p.priceLabel, style: AppTextStyles.price),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats
                  Row(children: [
                    _StatItem(icon: Icons.bed_outlined, value: '${p.bedrooms}', label: 'Chambres'),
                    _StatItem(icon: Icons.bathtub_outlined, value: '${p.bathrooms}', label: 'Salles de bain'),
                    _StatItem(icon: Icons.square_foot, value: '${p.surface.toInt()}', label: 'm²'),
                  ]),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(p.description, style: AppTextStyles.body2.copyWith(height: 1.6,
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                  const SizedBox(height: 20),

                  // Amenities
                  if (p.amenities.isNotEmpty) ...[
                    Text('Équipements', style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: p.amenities.map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(a, style: AppTextStyles.caption),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Owner
                  Text('Propriétaire', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: p.ownerPhotoUrl != null ? NetworkImage(p.ownerPhotoUrl!) : null,
                            backgroundColor: AppColors.primaryLight,
                            child: p.ownerPhotoUrl == null ? Text(p.ownerName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(p.ownerName, style: AppTextStyles.label),
                              Row(children: [
                                if (p.ownerVerified) ...[BadgeChip.verified(), const SizedBox(width: 6)],
                                if (p.ownerTrusted) BadgeChip.trusted(),
                              ]),
                            ]),
                          ),
                          IconButton(
                            onPressed: () => context.push('/chat/${p.ownerId}', extra: {'name': p.ownerName}),
                            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reviews
                  if (_reviews.isNotEmpty) ...[
                    Row(children: [
                      Text('Avis (${_reviews.length})', style: AppTextStyles.h4),
                      const SizedBox(width: 10),
                      RatingBarIndicator(rating: p.rating, itemSize: 16,
                        itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber)),
                      const SizedBox(width: 4),
                      Text(p.rating.toStringAsFixed(1), style: AppTextStyles.label),
                    ]),
                    const SizedBox(height: 12),
                    ..._reviews.take(3).map((r) => _ReviewTile(review: r)),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isOwner ? null : Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/chat/${p.ownerId}', extra: {'name': p.ownerName}),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Contacter'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: p.isAvailable ? () => context.push('/booking/${p.id}') : null,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(p.reservationMode == ReservationMode.immediate ? 'Réserver maintenant' : 'Envoyer une demande'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.h4),
            Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.primaryLight,
            child: Text(review.authorName[0], style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Text(review.authorName, style: AppTextStyles.label)),
          RatingBarIndicator(rating: review.rating, itemSize: 14,
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber)),
        ]),
        const SizedBox(height: 8),
        Text(review.comment, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight, height: 1.4)),
      ]),
    );
  }
}
