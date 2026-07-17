import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Property? _selectedProperty;

  // Centre Douala
  static const _initialPosition = CameraPosition(
    target: LatLng(4.0511, 9.7679),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildMarkers());
  }

  void _buildMarkers() {
    final properties = context.read<PropertyService>().properties;
    setState(() {
      _markers = properties.map((p) => Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.latitude, p.longitude),
        onTap: () => setState(() => _selectedProperty = p),
        infoWindow: InfoWindow(title: p.title, snippet: p.priceLabel),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          p.isAvailable ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed,
        ),
      )).toSet();
    });
  }

  Future<void> _goToMyLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    try {
      final pos = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(pos.latitude, pos.longitude), 15,
      ));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final properties = context.watch<PropertyService>().properties;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) {
              _mapController = c;
              _buildMarkers();
            },
            onTap: (_) => setState(() => _selectedProperty = null),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text('Rechercher sur la carte...', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondaryLight)),
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

          // Counter badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${properties.length} logements', style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ),
          ),

          // My location button
          Positioned(
            bottom: _selectedProperty != null ? 220 : 100,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: _goToMyLocation,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // Selected property card
          if (_selectedProperty != null)
            Positioned(
              bottom: 80, left: 16, right: 16,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90, height: 90,
              child: property.photoUrls.isNotEmpty
                  ? Image.network(property.photoUrls.first, fit: BoxFit.cover)
                  : Container(color: AppColors.primaryLight, child: const Center(child: Text('🏠', style: TextStyle(fontSize: 36)))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.title, style: AppTextStyles.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on, size: 12, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 2),
                  Text('${property.district}, ${property.city}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondaryLight)),
                ]),
                const SizedBox(height: 8),
                Text(property.priceLabel, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onClose),
              ElevatedButton(
                onPressed: () => context.push('/property/${property.id}'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600),
                ),
                child: const Text('Voir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
