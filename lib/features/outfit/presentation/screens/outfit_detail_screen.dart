import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/presentation/providers/outfit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OutfitDetailScreen extends ConsumerWidget {
  final Outfit outfit;

  const OutfitDetailScreen({super.key, required this.outfit});

  Future<void> _deleteOutfit(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete Outfit', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this outfit?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(outfitsProvider.notifier).deleteOutfit(outfit.id);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting outfit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat('MMM d, yyyy').format(outfit.date);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Outfit Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _deleteOutfit(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  if (outfit.location.isNotEmpty) ...[
                    const Text("Location", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.location, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                  ],
                  if (outfit.people.isNotEmpty) ...[
                    const Text("People Present", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.people, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
                  if (outfit.description.isNotEmpty) ...[
                    const Text("Notes", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(outfit.description, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
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