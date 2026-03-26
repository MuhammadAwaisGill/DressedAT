import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OutfitDetailScreen extends StatelessWidget {
  final Outfit outfit;

  const OutfitDetailScreen({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, yyyy').format(outfit.date);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Outfit Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO IMAGE
            Hero(
              tag: outfit.id,
              child: Image.network(
                outfit.imageUrl,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TAGS ROW
                  if (outfit.outfitType != null || outfit.topColor != null ||
                      outfit.bottomType != null || outfit.colorTheme != null) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (outfit.outfitType != null) _Tag(outfit.outfitType!),
                        if (outfit.topColor != null) _Tag(outfit.topColor!),
                        if (outfit.bottomType != null) _Tag(outfit.bottomType!),
                        if (outfit.colorTheme != null) _Tag(outfit.colorTheme!),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // LOCATION
                  if (outfit.location.isNotEmpty) ...[
                    const Text("Location", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.location, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                  ],

                  // PEOPLE
                  if (outfit.people.isNotEmpty) ...[
                    const Text("People Present", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.people, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 20),
                  ],

                  // DESCRIPTION
                  if (outfit.description.isNotEmpty) ...[
                    const Text("Notes", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.description, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 20),
                  ],

                  // DATE
                  const Text("Date", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(formattedDate, style: const TextStyle(color: Colors.white, fontSize: 16)),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    );
  }
}