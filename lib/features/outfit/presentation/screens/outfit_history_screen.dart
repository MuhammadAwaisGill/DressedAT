import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/presentation/providers/outfit_provider.dart';
import 'package:dressedat/features/outfit/presentation/screens/outfit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OutfitHistoryScreen extends ConsumerWidget {
  const OutfitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitsAsync = ref.watch(outfitsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Outfit History"),
        backgroundColor: Colors.black,
      ),
      body: outfitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(e.toString(), style: const TextStyle(color: Colors.white)),
        ),
        data: (outfits) {
          if (outfits.isEmpty) {
            return const Center(
              child: Text("No outfits yet", style: TextStyle(color: Colors.white70)),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(outfitsProvider.notifier).refresh(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: outfits.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final outfit = outfits[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OutfitDetailScreen(outfit: outfit),
                    ),
                  ),
                  child: Hero(
                    tag: outfit.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(outfit.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}