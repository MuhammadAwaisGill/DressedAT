import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/data/outfit_repository.dart';
import 'package:dressedat/features/outfit/presentation/screens/outfit_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OutfitHistoryScreen extends StatefulWidget {
  const OutfitHistoryScreen({super.key});

  @override
  State<OutfitHistoryScreen> createState() => _OutfitHistoryScreenState();
}

class _OutfitHistoryScreenState extends State<OutfitHistoryScreen> {
  final repo = OutfitRepository();

  List<Outfit> outfits = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadOutfits();
  }

  Future<void> _loadOutfits() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    final data = await repo.getUserOutfits(user.id);

    setState(() {
      outfits = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Outfit History"),
        backgroundColor: Colors.black,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : outfits.isEmpty
          ? const Center(
        child: Text(
          "No outfits yet",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : GridView.builder(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OutfitDetailScreen(outfit: outfit),
                ),
              );
            },
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
  }
}
