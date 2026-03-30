import 'package:dressedat/features/outfit/data/outfit_model.dart';
import 'package:dressedat/features/outfit/data/outfit_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final outfitRepositoryProvider = Provider((ref) => OutfitRepository());

class OutfitNotifier extends AsyncNotifier<List<Outfit>> {
  @override
  Future<List<Outfit>> build() async {
    return _fetchOutfits();
  }

  Future<List<Outfit>> _fetchOutfits() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return ref.read(outfitRepositoryProvider).getUserOutfits(user.id);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchOutfits());
  }

  Future<void> deleteOutfit(String id) async {
    await ref.read(outfitRepositoryProvider).deleteOutfit(id);
    await refresh();
  }
}

final outfitsProvider = AsyncNotifierProvider<OutfitNotifier, List<Outfit>>(
  OutfitNotifier.new,
);