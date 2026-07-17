import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class VirtualTourScreen extends StatefulWidget {
  final String propertyId;
  const VirtualTourScreen({super.key, required this.propertyId});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  Property? _property;
  final _pageController = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await context.read<PropertyService>().getProperty(widget.propertyId);
    setState(() => _property = p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Visite virtuelle 360°', style: TextStyle(color: Colors.white)),
        leading: BackButton(onPressed: () => context.pop(), color: Colors.white),
      ),
      body: _property == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _property!.tour360Urls.isEmpty
              ? _NoTourState(propertyId: widget.propertyId, photos: _property!.photoUrls)
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _property!.tour360Urls.length,
                        onPageChanged: (i) => setState(() => _current = i),
                        itemBuilder: (_, i) => _Tour360Viewer(imageUrl: _property!.tour360Urls[i]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: Colors.black,
                      child: Column(
                        children: [
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: _property!.tour360Urls.length,
                            effect: const WormEffect(dotHeight: 6, dotWidth: 6, activeDotColor: AppColors.primary, dotColor: Colors.white24),
                          ),
                          const SizedBox(height: 12),
                          Text('Pièce ${_current + 1} / ${_property!.tour360Urls.length}',
                            style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins', fontSize: 13)),
                          const SizedBox(height: 8),
                          const Text('← Glissez pour naviguer →',
                            style: TextStyle(color: Colors.white38, fontFamily: 'Poppins', fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _Tour360Viewer extends StatefulWidget {
  final String imageUrl;
  const _Tour360Viewer({required this.imageUrl});

  @override
  State<_Tour360Viewer> createState() => _Tour360ViewerState();
}

class _Tour360ViewerState extends State<_Tour360Viewer> {
  double _offsetX = 0;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _offsetX += details.primaryDelta! * 0.5;
          if (_offsetX > 200) _offsetX = 200;
          if (_offsetX < -200) _offsetX = -200;
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = details.scale.clamp(1.0, 3.0);
        });
      },
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offsetX, 0.0)
            ..scale(_scale),
          alignment: Alignment.center,
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (_, child, progress) => progress == null ? child
                : Center(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text('Chargement de la vue 360°...', style: TextStyle(color: Colors.white70, fontFamily: 'Poppins', fontSize: 12)),
                    ],
                  )),
          ),
        ),
      ),
    );
  }
}

class _NoTourState extends StatelessWidget {
  final String propertyId;
  final List<String> photos;
  const _NoTourState({required this.propertyId, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎥', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text('Visite 360° non disponible', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Ce logement n\'a pas encore de visite virtuelle.', style: TextStyle(color: Colors.white54, fontFamily: 'Poppins', fontSize: 13)),
          const SizedBox(height: 24),
          if (photos.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Voir les photos'),
            ),
        ],
      ),
    );
  }
}
