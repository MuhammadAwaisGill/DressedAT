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
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _peopleController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _saveOutfit() async {
    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }

    try {
      final repo = OutfitRepository();
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) throw Exception("User not logged in");

      /// 1️⃣ Upload Image
      final imageUrl = await repo.uploadImage(_image!, user.id);

      /// 2️⃣ Create Outfit Object
      final outfit = Outfit(
        id: '',
        userId: user.id,
        imageUrl: imageUrl,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        people: _peopleController.text.trim(),
        date: DateTime.now(),
      );

      /// 3️⃣ Save to DB
      await repo.addOutfit(outfit);

      /// 4️⃣ Go Back
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Add Outfit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE PICKER
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.white54,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Tap to add outfit photo",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            /// DESCRIPTION
            _InputField(
              controller: _descriptionController,
              label: "Description",
              hint: "Red dress with white heels",
              icon: Icons.description,
            ),

            const SizedBox(height: 16),

            /// LOCATION
            _InputField(
              controller: _locationController,
              label: "Location / Event",
              hint: "Office, Wedding, Dinner",
              icon: Icons.location_on,
            ),

            const SizedBox(height: 16),

            /// PEOPLE
            _InputField(
              controller: _peopleController,
              label: "People Present",
              hint: "Ali, Sara, Team",
              icon: Icons.people,
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _saveOutfit,
                child: const Text(
                  "Save Outfit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

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

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
