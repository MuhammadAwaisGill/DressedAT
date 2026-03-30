import 'dart:io';
import 'package:dressedat/features/outfit/logic/similarity_service.dart';
import 'package:dressedat/features/outfit/presentation/providers/outfit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/data/outfit_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddOutfitScreen extends ConsumerStatefulWidget {
  const AddOutfitScreen({super.key});

  @override
  ConsumerState<AddOutfitScreen> createState() => _AddOutfitScreenState();
}

class _AddOutfitScreenState extends ConsumerState<AddOutfitScreen> {
  final _locationController = TextEditingController();
  final _peopleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  String? _topColor;
  String? _bottomType;
  String? _outfitType;
  String? _colorTheme;

  final List<String> _topColors = ['White', 'Black', 'Red', 'Blue', 'Green', 'Yellow', 'Pink', 'Grey', 'Brown', 'Other'];
  final List<String> _bottomTypes = ['Jeans', 'Trousers', 'Skirt', 'Shorts', 'Shalwar', 'Leggings', 'Other'];
  final List<String> _outfitTypes = ['Casual', 'Formal', 'Semi-Formal', 'Traditional', 'Sportswear', 'Other'];
  final List<String> _colorThemes = ['Dark', 'Light', 'Colorful', 'Neutral', 'Monochrome'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  /// Builds a temporary outfit from current form state for similarity checking.
  /// When you upgrade to ML/image similarity later, just update SimilarityService
  /// — this method and the rest of the flow stays the same.
  Outfit _buildTempOutfit() {
    return Outfit(
      id: 'temp',
      userId: '',
      imageUrl: '',
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      people: _peopleController.text.trim(),
      date: DateTime.now(),
      topColor: _topColor,
      bottomType: _bottomType,
      outfitType: _outfitType,
      colorTheme: _colorTheme,
    );
  }

  Future<void> _saveOutfit() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    // Check similarity before saving
    final outfitsState = ref.read(outfitsProvider);
    final existingOutfits = outfitsState.value ?? [];

    if (existingOutfits.isNotEmpty) {
      final tempOutfit = _buildTempOutfit();
      final similarOutfits = SimilarityService().findSimilar(tempOutfit, existingOutfits);

      if (similarOutfits.isNotEmpty && mounted) {
        final shouldProceed = await _showSimilarityWarning(similarOutfits);
        if (!shouldProceed) return;
      }
    }

    await _uploadAndSave();
  }

  Future<bool> _showSimilarityWarning(List<Outfit> similarOutfits) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          '⚠️ Similar Outfit Detected',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You may have worn a similar outfit before:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ...similarOutfits.take(3).map((o) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(o.imageUrl, height: 50, width: 50, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (o.location.isNotEmpty)
                          Text(o.location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (o.people.isNotEmpty)
                          Text(o.people, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
            const Text(
              'Save anyway?',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Anyway'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _uploadAndSave() async {
    setState(() => _isLoading = true);

    try {
      final repo = OutfitRepository();
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final imageUrl = await repo.uploadImage(_image!, user.id);

      final outfit = Outfit(
        id: '',
        userId: user.id,
        imageUrl: imageUrl,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        people: _peopleController.text.trim(),
        date: DateTime.now(),
        topColor: _topColor,
        bottomType: _bottomType,
        outfitType: _outfitType,
        colorTheme: _colorTheme,
      );

      await repo.addOutfit(outfit);

      // Refresh Riverpod state so home screen updates
      await ref.read(outfitsProvider.notifier).refresh();

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Add Outfit', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _image == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.white54, size: 50),
                    SizedBox(height: 10),
                    Text("Tap to add outfit photo", style: TextStyle(color: Colors.white54)),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: "Outfit Type"),
            _ChipSelector(options: _outfitTypes, selected: _outfitType, onSelected: (v) => setState(() => _outfitType = v)),
            const SizedBox(height: 16),
            _SectionLabel(label: "Top Color"),
            _ChipSelector(options: _topColors, selected: _topColor, onSelected: (v) => setState(() => _topColor = v)),
            const SizedBox(height: 16),
            _SectionLabel(label: "Bottom Type"),
            _ChipSelector(options: _bottomTypes, selected: _bottomType, onSelected: (v) => setState(() => _bottomType = v)),
            const SizedBox(height: 16),
            _SectionLabel(label: "Color Theme"),
            _ChipSelector(options: _colorThemes, selected: _colorTheme, onSelected: (v) => setState(() => _colorTheme = v)),
            const SizedBox(height: 16),
            _InputField(controller: _locationController, label: "Location / Event", hint: "Office, Wedding, Dinner", icon: Icons.location_on),
            const SizedBox(height: 12),
            _InputField(controller: _peopleController, label: "People Present", hint: "Ali, Sara, Team", icon: Icons.people),
            const SizedBox(height: 12),
            _InputField(controller: _descriptionController, label: "Extra Notes (optional)", hint: "Any extra details...", icon: Icons.notes),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isLoading ? null : _saveOutfit,
                child: _isLoading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black))
                    : const Text("Save Outfit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}

class _ChipSelector extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _ChipSelector({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _InputField({required this.controller, required this.label, required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}