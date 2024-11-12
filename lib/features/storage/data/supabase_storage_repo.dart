import 'dart:io';

import 'package:social/features/storage/domain/storage_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageRepo implements StorageRepo {
  final supabase = Supabase.instance.client;

  @override
  Future<String> uploadProfilePicture(String path, String fileName) async {
    try {
      final file = File(path);
      await supabase.storage.from('profilepictures').upload(
            '$fileName.png',
            file,
            fileOptions: const FileOptions(upsert: true),
          );
      String imageUrl = supabase.storage
          .from('profilepictures')
          .getPublicUrl('$fileName.png');
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();
      return imageUrl;
    } catch (e) {
      throw Exception('Failed uploading profile picture: $e');
    }
  }

  @override
  Future<String> uploadPostImage(String path, String fileName) async {
    try {
      final file = File(path);
      await supabase.storage.from('posts').upload(
            '$fileName.png',
            file,
            fileOptions: const FileOptions(),
          );
      final imageUrl =
          supabase.storage.from('posts').getPublicUrl('$fileName.png');
      return imageUrl;
    } catch (e) {
      throw Exception('Failed uploading profile picture: $e');
    }
  }
}
