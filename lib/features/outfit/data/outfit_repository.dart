import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'outfit_model.dart';

class OutfitRepository {
  final _client = Supabase.instance.client;
  final _uuid = const Uuid();

  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      final fileName = '$userId/${_uuid.v4()}.jpg';
      await _client.storage.from('outfit-images').upload(fileName, imageFile);
      return _client.storage.from('outfit-images').getPublicUrl(fileName);
    } on StorageException catch (e) {
      throw Exception('Image upload failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during image upload');
    }
  }

  Future<void> addOutfit(Outfit outfit) async {
    try {
      await _client.from('outfits').insert(outfit.toJson());
    } on PostgrestException catch (e) {
      throw Exception('Failed to save outfit: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while saving outfit');
    }
  }

  Future<List<Outfit>> getUserOutfits(String userId) async {
    try {
      final data = await _client
          .from('outfits')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false);
      return (data as List).map((e) => Outfit.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch outfits: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching outfits');
    }
  }

  Future<void> deleteOutfit(String id) async {
    try {
      await _client.from('outfits').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete outfit: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while deleting outfit');
    }
  }
}