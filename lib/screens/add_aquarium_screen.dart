import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/aquarium.dart';
import '../theme/app_theme.dart';

class AddAquariumScreen extends StatefulWidget {
  const AddAquariumScreen({this.initialAquarium, super.key});

  final Aquarium? initialAquarium;

  @override
  State<AddAquariumScreen> createState() => _AddAquariumScreenState();
}

class _AddAquariumScreenState extends State<AddAquariumScreen> {
  final _nameController = TextEditingController();
  final _volumeController = TextEditingController();
  AquariumType? _type;
  String _volumeUnit = 'gal';
  DateTime _createdAt = DateTime.now();
  XFile? _photo;
  Future<Uint8List>? _photoBytes;
  Uint8List? _existingPhotoBytes;

  @override
  void initState() {
    super.initState();
    final aquarium = widget.initialAquarium;
    if (aquarium != null) {
      _nameController.text = aquarium.name;
      _volumeController.text = _formatVolume(aquarium.volume);
      _type = aquarium.type;
      _volumeUnit = aquarium.volumeUnit;
      _createdAt = aquarium.createdAt;
      _existingPhotoBytes = aquarium.photoBytes;
    }
  }

  bool get _isEditing => widget.initialAquarium != null;

  bool get _canCreate {
    final name = _nameController.text.trim();
    final volume = double.tryParse(_volumeController.text.trim());
    return name.isNotEmpty && _type != null && volume != null && volume > 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Future<void> _createAquarium() async {
    final volume = double.parse(_volumeController.text.trim());
    final photoBytes = _photo == null
        ? _existingPhotoBytes
        : await _photo!.readAsBytes();
    if (!mounted) return;
    Navigator.of(context).pop(
      Aquarium(
        name: _nameController.text.trim(),
        type: _type!,
        volume: volume,
        volumeUnit: _volumeUnit,
        createdAt: _createdAt,
        photoBytes: photoBytes,
        inhabitants: widget.initialAquarium?.inhabitants ?? const [],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete aquarium?'),
        content: Text(
          'Are you sure you want to delete "${widget.initialAquarium!.name}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: VivariColors.error),
            child: const Text('Delete Aquarium'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _selectPhoto() async {
    try {
      final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (photo != null && mounted) {
        setState(() {
          _photo = photo;
          _photoBytes = photo.readAsBytes();
          _existingPhotoBytes = null;
        });
      }
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open photos: ${error.message}')),
      );
    }
  }

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(1900),
      lastDate: DateTime(today.year + 1),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: VivariColors.primary,
            surface: VivariColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (selectedDate != null && mounted) {
      setState(() => _createdAt = selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Aquarium' : 'Add Aquarium'),
        actions: [
          TextButton(
            onPressed: _canCreate ? _createAquarium : null,
            style: TextButton.styleFrom(
              foregroundColor: _canCreate
                  ? VivariColors.primary
                  : VivariColors.textMuted,
            ),
            child: Text(_isEditing ? 'Save' : 'Create'),
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.small,
            AppSpacing.screen,
            AppSpacing.large,
          ),
          children: [
            _FieldLabel('Aquarium Name'),
            const SizedBox(height: AppSpacing.small),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDecoration('e.g. Betta tank'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.large),
            _FieldLabel('Type'),
            const SizedBox(height: AppSpacing.small),
            Row(
              children: [
                for (final type in AquariumType.values) ...[
                  if (type != AquariumType.values.first)
                    const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: _AquariumTypeButton(
                      type: type,
                      selected: _type == type,
                      onPressed: () => setState(() => _type = type),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            _FieldLabel('Volume'),
            const SizedBox(height: AppSpacing.small),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _volumeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: _inputDecoration('Enter volume'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Row(
                    children: [
                      for (final unit in ['gal', 'L']) ...[
                        if (unit != 'gal')
                          const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: _VolumeUnitButton(
                            unit: unit,
                            selected: _volumeUnit == unit,
                            onPressed: () => setState(() => _volumeUnit = unit),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            _FieldLabel('Aquarium photo (optional)'),
            const SizedBox(height: AppSpacing.small),
            _PhotoPicker(
              photo: _photo,
              photoBytes: _photoBytes,
              existingPhotoBytes: _existingPhotoBytes,
              onPressed: _selectPhoto,
            ),
            const SizedBox(height: AppSpacing.large),
            _FieldLabel('Creation date'),
            const SizedBox(height: AppSpacing.small),
            OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(_formatDate(_createdAt)),
              style: OutlinedButton.styleFrom(
                foregroundColor: VivariColors.textPrimary,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: 18,
                ),
                side: const BorderSide(color: VivariColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.large),
              const Divider(),
              const SizedBox(height: AppSpacing.medium),
              OutlinedButton.icon(
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Aquarium'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: VivariColors.error,
                  minimumSize: const Size(0, 52),
                  side: const BorderSide(color: VivariColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: VivariColors.textMuted),
    filled: true,
    fillColor: VivariColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.medium,
      vertical: 18,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: VivariColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: VivariColors.border),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _AquariumTypeButton extends StatelessWidget {
  const _AquariumTypeButton({
    required this.type,
    required this.selected,
    required this.onPressed,
  });

  final AquariumType type;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: selected
            ? VivariColors.background
            : VivariColors.textPrimary,
        backgroundColor: selected ? VivariColors.primary : VivariColors.surface,
        minimumSize: const Size(0, 56),
        side: BorderSide(
          color: selected ? VivariColors.primary : VivariColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(type.label),
    );
  }
}

class _VolumeUnitButton extends StatelessWidget {
  const _VolumeUnitButton({
    required this.unit,
    required this.selected,
    required this.onPressed,
  });

  final String unit;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: selected
            ? VivariColors.background
            : VivariColors.textPrimary,
        backgroundColor: selected ? VivariColors.primary : VivariColors.surface,
        minimumSize: const Size(0, 56),
        padding: EdgeInsets.zero,
        side: BorderSide(
          color: selected ? VivariColors.primary : VivariColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(unit),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photo,
    required this.photoBytes,
    required this.existingPhotoBytes,
    required this.onPressed,
  });

  final XFile? photo;
  final Future<Uint8List>? photoBytes;
  final Uint8List? existingPhotoBytes;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 132,
        decoration: BoxDecoration(
          color: VivariColors.surface,
          border: Border.all(color: VivariColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: photo == null && existingPhotoBytes == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 28),
                  SizedBox(height: AppSpacing.small),
                  Text('Add photo'),
                ],
              )
            : photo == null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(existingPhotoBytes!, fit: BoxFit.cover),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.small),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              )
            : FutureBuilder<Uint8List>(
                future: photoBytes,
                builder: (context, snapshot) => Stack(
                  fit: StackFit.expand,
                  children: [
                    if (snapshot.hasData)
                      Image.memory(snapshot.data!, fit: BoxFit.cover)
                    else if (snapshot.hasError)
                      const Center(
                        child: Text(
                          'Could not load photo',
                          style: TextStyle(color: VivariColors.textMuted),
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.small),
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

String _formatVolume(double volume) => volume == volume.roundToDouble()
    ? volume.toInt().toString()
    : volume.toString();
