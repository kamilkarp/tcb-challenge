import 'package:api_client/api_client.dart';
import 'package:photos_repository/photos_repository.dart';

/// {@template photos_repository}
/// Repository providing photos
/// {@endtemplate}
class PhotosRepository {
  /// {@macro photos_repository}
  PhotosRepository({ApiClient? apiClient})
      : _apiClient =
            apiClient ?? ApiClient(baseUrl: 'jsonplaceholder.typicode.com');

  final ApiClient _apiClient;

  /// Using repository's client, fetch list of photos
  /// starting from [startIndex].
  ///
  /// [limit] limits list of photos.
  Future<List<Photo>> fetchPhotos({int startIndex = 0, int limit = 1}) async {
    final photos =
        await _apiClient.fetchPhotos(startIndex: startIndex, limit: limit);

    return photos.map(Photo.fromResource).toList();
  }
}
