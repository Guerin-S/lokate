import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/property_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/lokate_text_field.dart';
import '../../services/notification_service.dart';

class EditPropertyScreen extends StatefulWidget {
  final Property property;
  const EditPropertyScreen({super.key, required this.property});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _districtCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _surfaceCtrl;
  late PropertyType _type;
  late String _city;
  late int _bedrooms;
  late int _bathrooms;
  late ReservationMode _reservationMode;
  late bool _isAvailable;
  bool _saving = false;

  final List<String> _cities = ['Douala', 'Yaoundé', 'Bafoussam', 'Bamenda', 'Kribi'];

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _titleCtrl = TextEditingController(text: p.title);
    _descCtrl = TextEditingController(text: p.description);
    _districtCtrl = TextEditingController(text: p.district);
    _addressCtrl = TextEditingController(text: p.address);
    _priceCtrl = TextEditingController(text: p.exactPrice?.toStringAsFixed(0) ?? '');
    _surfaceCtrl = TextEditingController(text: p.surface > 0 ? p.surface.toInt().toString() : '');
    _type = p.type;
    _city = p.city;
    _bedrooms = p.bedrooms;
    _bathrooms = p.bathrooms;
    _reservationMode = p.reservationMode;
    _isAvailable = p.isAvailable;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _districtCtrl.dispose();
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _surfaceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await context.read<PropertyService>().updateProperty(widget.property.id, {
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'type': _type.name,
        'city': _city,
        'district': _districtCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'exactPrice': double.tryParse(_priceCtrl.text),
        'bedrooms': _bedrooms,
        'bathrooms': _bathrooms,
        'surface': double.tryParse(_surfaceCtrl.text) ?? 0,
        'reservationMode': _reservationMode.name,
        'isAvailable': _isAvailable,
      });
      if (!mounted) return;
      NotificationService.showSuccess(context, 'Logement mis à jour !');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      NotificationService.showError(context, 'Erreur lors de la mise à jour');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le logement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LokateTextField(
              controller: _titleCtrl,
              label: 'Titre du bien',
              hint: 'Ex: Bel appartement 3 pièces',
              validator: (v) => v!.length > 5 ? null : 'Titre trop court',
            ),
            const SizedBox(height: 14),
            Text('Type de bien', style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: PropertyType.values.map((t) {
                final selected = _type == t;
                final labels = {'appartement': 'Appartement', 'studio': 'Studio', 'villa': 'Villa', 'chambre': 'Chambre', 'autre': 'Autre'};
                return GestureDetector(
                  onTap: () => setState(() => _type = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
                    ),
                    child: Text(labels[t.name] ?? t.name, style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 13, color: selected ? Colors.white : AppColors.textSecondaryLight, fontWeight: FontWeight.w500)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            LokateTextField(
              controller: _descCtrl,
              label: 'Description',
              hint: 'Décrivez votre logement...',
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _city,
              items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _city = v ?? _city),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.location_city_outlined)),
            ),
            const SizedBox(height: 14),
            LokateTextField(controller: _districtCtrl, label: 'Quartier', hint: 'Ex: Bonapriso'),
            const SizedBox(height: 14),
            LokateTextField(controller: _addressCtrl, label: 'Adresse', hint: 'Rue, numéro...'),
            const SizedBox(height: 14),
            LokateTextField(controller: _priceCtrl, label: 'Loyer (FCFA)', hint: 'Ex: 150000', keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            LokateTextField(controller: _surfaceCtrl, label: 'Surface (m²)', hint: 'Ex: 80', keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Chambres', style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 8),
                _EditCounter(value: _bedrooms, min: 0, max: 10, onChanged: (v) => setState(() => _bedrooms = v)),
              ])),
              const SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Salles de bain', style: AppTextStyles.label.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 8),
                _EditCounter(value: _bathrooms, min: 1, max: 10, onChanged: (v) => setState(() => _bathrooms = v)),
              ])),
            ]),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Disponible', style: AppTextStyles.body2),
              value: _isAvailable,
              onChanged: (v) => setState(() => _isAvailable = v),
              activeThumbColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Enregistrer les modifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditCounter extends StatelessWidget {
  final int value, min, max;
  final ValueChanged<int> onChanged;
  const _EditCounter({required this.value, required this.min, required this.max, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: value > min ? () => onChanged(value - 1) : null,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: value > min ? AppColors.primary : AppColors.borderLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.remove, size: 16, color: value > min ? AppColors.primary : AppColors.borderLight),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('$value', style: AppTextStyles.h4),
      ),
      GestureDetector(
        onTap: value < max ? () => onChanged(value + 1) : null,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.add, size: 16, color: Colors.white),
        ),
      ),
    ]);
  }
}
