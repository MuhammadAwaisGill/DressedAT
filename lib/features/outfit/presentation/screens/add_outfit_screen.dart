import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/data/outfit_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddOutfitScreen extends StatefulWidget {
  const AddOutfitScreen({super.key});

  @override
  State<AddOutfitScreen> createState() => _AddOutfitScreenState();
}

class _AddOutfitScreenState extends State<AddOutfitScreen> {
  final _locationController = TextEditingController();
  final _peopleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  // Form selections
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
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _saveOutfit() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = OutfitRepository();
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final imageUrl = await repo.uploadImage(_image!, user.id);

      // Combine tags into description
      final tags = [
        if (_topColor != null) 'Top: $_topColor',
        if (_bottomType != null) 'Bottom: $_bottomType',
        if (_outfitType != null) 'Type: $_outfitType',
        if (_colorTheme != null) 'Theme: $_colorTheme',
      ].join(' · ');

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

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
            // Image Picker
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

            // Outfit Type Tags
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