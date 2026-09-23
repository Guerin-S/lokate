import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/auth_service.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lokate_text_field.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _surfaceCtrl = TextEditingController();

  PropertyType _type = PropertyType.appartement;
  String _city = 'Douala';
  final PriceDisplay _priceDisplay = PriceDisplay.exact;
  ReservationMode _reservationMode = ReservationMode.approval;
  int _bedrooms = 1;
  int _bathrooms = 1;
  List<File> _photos = [];
  final List<File> _tour360 = [];
  bool _publishing = false;
  int _step = 0;

  final List<String> _cities = [
    'Douala',
    'Yaoundé',
    'Bafoussam',
    'Bamenda',
    'Kribi'
  ];
  final List<String> _amenitiesOptions = [
    'WiFi',
    'Parking',
    'Climatisation',
    'Gardien',
    'Groupe électrogène',
    'Eau chaude',
    'Balcon',
    'Cuisine équipée',
    'Piscine'
  ];
  final Set<String> _selectedAmenities = {};

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final imgs = await picker.pickMultiImage(imageQuality: 80);
    setState(() => _photos = imgs.map((x) => File(x.path)).toList());
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _publishing = true);
    try {
      final user = context.read<AuthService>().currentUser!;
      final property = Property(
        id: '',
        ownerId: user.id,
        ownerName: user.name,
        ownerPhotoUrl: user.photoUrl,
        ownerVerified: user.isVerified,
        ownerTrusted: user.isTrusted,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        type: _type,
        city: _city,
        district: _districtCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        latitude: 4.0511, // Default Douala — à remplacer par géocodage
        longitude: 9.7679,
        photoUrls: [],
        priceDisplay: _priceDisplay,
        exactPrice: _priceDisplay == PriceDisplay.exact
            ? double.tryParse(_priceCtrl.text)
            : null,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        surface: double.tryParse(_surfaceCtrl.text) ?? 0,
        amenities: _selectedAmenities.toList(),
        reservationMode: _reservationMode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await context
          .read<PropertyService>()
          .addProperty(property, _photos, _tour360);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bien publié avec succès !')));
      context.go('/owner/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la publication')));
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier un logement'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: IndexedStack(
          index: _step,
          children: [_step1(), _step2(), _step3()],
        ),
      ),
    );
  }

  Widget _step1() => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Informations générales', style: AppTextStyles.h4),
          const SizedBox(height: 6),
          Text('Étape 1 sur 3',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),
          LokateTextField(
              controller: _titleCtrl,
              label: 'Titre du bien',
              hint: 'Ex: Bel appartement 3 pièces à Bonapriso',
              validator: (v) => v!.length > 5 ? null : 'Titre trop court'),
          const SizedBox(height: 14),
          Text('Type de bien',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PropertyType.values.map((t) {
                final selected = _type == t;
                final labels = {
                  'appartement': 'Appartement',
                  'studio': 'Studio',
                  'villa': 'Villa',
                  'chambre': 'Chambre',
                  'autre': 'Autre'
                };
                return GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.borderLight),
                    ),
                    child: Text(labels[t.name] ?? t.name,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500)),
                  ),
                );
              }).toList()),
          const SizedBox(height: 14),
          LokateTextField(
              controller: _descCtrl,
              label: 'Description',
              hint: 'Décrivez votre logement en détail...',
              maxLines: 4,
              validator: (v) =>
                  v!.length > 20 ? null : 'Description trop courte'),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              child: const Text('Suivant →')),
        ]),
      );

  Widget _step2() => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Localisation & Prix', style: AppTextStyles.h4),
          const SizedBox(height: 6),
          Text('Étape 2 sur 3',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),
          Text('Ville',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _city,
            items: _cities
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _city = v ?? _city),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_city_outlined)),
          ),
          const SizedBox(height: 14),
          LokateTextField(
              controller: _districtCtrl,
              label: 'Quartier',
              hint: 'Ex: Bonapriso, Akwa, Bastos...',
              validator: (v) => v!.isNotEmpty ? null : 'Champ requis'),
          const SizedBox(height: 14),
          LokateTextField(
              controller: _addressCtrl,
              label: 'Adresse complète',
              hint: 'Rue, numéro...',
              validator: (v) => v!.isNotEmpty ? null : 'Champ requis'),
          const SizedBox(height: 20),
          Text('Loyer mensuel (FCFA)',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          LokateTextField(
              controller: _priceCtrl,
              label: '',
              hint: 'Ex: 150000',
              keyboardType: TextInputType.number,
              validator: (v) =>
                  double.tryParse(v ?? '') != null ? null : 'Prix invalide'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Chambres',
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 8),
                  _Counter(
                      value: _bedrooms,
                      onChanged: (v) => setState(() => _bedrooms = v),
                      min: 0,
                      max: 10),
                ])),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Salles de bain',
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 8),
                  _Counter(
                      value: _bathrooms,
                      onChanged: (v) => setState(() => _bathrooms = v),
                      min: 1,
                      max: 10),
                ])),
          ]),
          const SizedBox(height: 14),
          LokateTextField(
              controller: _surfaceCtrl,
              label: 'Surface (m²)',
              hint: 'Ex: 80',
              keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () => setState(() => _step = 0),
                    child: const Text('← Retour'))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
                    onPressed: () => setState(() => _step = 2),
                    child: const Text('Suivant →'))),
          ]),
        ]),
      );

  Widget _step3() => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Photos & Équipements', style: AppTextStyles.h4),
          const SizedBox(height: 6),
          Text('Étape 3 sur 3',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),

          // Photos
          Text('Photos du logement',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickPhotos,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    style: BorderStyle.solid),
              ),
              child: _photos.isEmpty
                  ? const Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.primary, size: 32),
                      SizedBox(height: 8),
                      Text('Ajouter des photos',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500)),
                    ]))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(8),
                      itemCount: _photos.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => i == _photos.length
                          ? GestureDetector(
                              onTap: _pickPhotos,
                              child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: AppColors.primary)),
                                  child: const Center(
                                      child: Icon(Icons.add,
                                          color: AppColors.primary))))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_photos[i],
                                  width: 90, height: 90, fit: BoxFit.cover)),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Amenities
          Text('Équipements',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenitiesOptions.map((a) {
              final selected = _selectedAmenities.contains(a);
              return FilterChip(
                label: Text(a,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondaryLight)),
                selected: selected,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.transparent,
                side: BorderSide(
                    color:
                        selected ? AppColors.primary : AppColors.borderLight),
                onSelected: (v) => setState(() => v
                    ? _selectedAmenities.add(a)
                    : _selectedAmenities.remove(a)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Reservation mode
          Text('Mode de réservation',
              style: AppTextStyles.label
                  .copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 8),
          Column(
            children: ReservationMode.values
                .map((m) => RadioListTile<ReservationMode>(
                      value: m,
                      groupValue: _reservationMode,
                      onChanged: (v) => setState(() => _reservationMode = v!),
                      activeColor: AppColors.primary,
                      title: Text(
                          m == ReservationMode.immediate
                              ? 'Réservation immédiate'
                              : 'Approbation requise',
                          style: AppTextStyles.body2),
                      subtitle: Text(
                          m == ReservationMode.immediate
                              ? 'Les locataires peuvent réserver directement'
                              : 'Vous approuvez chaque demande avant confirmation',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textSecondaryLight)),
                      contentPadding: EdgeInsets.zero,
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),

          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () => setState(() => _step = 1),
                    child: const Text('← Retour'))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton.icon(
              onPressed: _publishing ? null : _publish,
              icon: _publishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.publish, size: 18),
              label: Text(_publishing ? 'Publication...' : 'Publier'),
            )),
          ]),
          const SizedBox(height: 40),
        ]),
      );
}

class _Counter extends StatelessWidget {
  final int value, min, max;
  final ValueChanged<int> onChanged;

  const _Counter(
      {required this.value,
      required this.onChanged,
      required this.min,
      required this.max});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: value > min ? () => onChanged(value - 1) : null,
        child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                      value > min ? AppColors.primary : AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.remove,
                size: 16,
                color:
                    value > min ? AppColors.primary : AppColors.borderLight)),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$value', style: AppTextStyles.h4)),
      GestureDetector(
        onTap: value < max ? () => onChanged(value + 1) : null,
        child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.add, size: 16, color: Colors.white)),
      ),
    ]);
  }
}
