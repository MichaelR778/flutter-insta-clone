abstract class StorageRepo {
  Future<String> uploadProfilePicture(String path, String fileName);
  Future<String> uploadPostImage(String path, String fileName);
}
