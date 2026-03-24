import 'package:dressedat/features/outfit/data/outfit_repository.dart';
import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final outfitRepositoryProvider = Provider((ref) => OutfitRepository());

final outfitsProvider = FutureProvider<List<Outfit>>((ref) async {
  final repo = ref.read(outfitRepositoryProvider);
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) throw Exception('User not logged in');

  return repo.getUserOutfits(user.id);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitsAsync = ref.watch(outfitsProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'DressedAT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),

      // Body
      body: outfitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (outfits) {
          if (outfits.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(outfitsProvider);
            },
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
                return _OutfitCard(outfit: outfit);
              },
            ),
          );
        },
      ),

      // Add Outfit
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-outfit');
          ref.refresh(outfitsProvider);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No outfits yet\nStart adding your style!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final Outfit outfit;

  const _OutfitCard({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: Image.network(outfit.imageUrl, fit: BoxFit.cover),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Info
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (outfit.location.isNotEmpty)
                  Text(
                    outfit.location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (outfit.description.isNotEmpty)
                  Text(
                    outfit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
