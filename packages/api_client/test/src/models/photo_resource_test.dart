import 'package:api_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PhotoResource', () {
    final testPhotoResource = PhotoResource(
      id: 1,
      albumId: 1,
      title: 'title?#@^&fo"46 os!@#%^*',
      url: 'testurl.com/1',
      thumbnailUrl: 'thumburl.com/1',
    );

    final testPhotoEncoded = {
      'id': testPhotoResource.id,
      'albumId': testPhotoResource.albumId,
      'title': testPhotoResource.title,
      'url': testPhotoResource.url,
      'thumbnailUrl': testPhotoResource.thumbnailUrl,
    };

    test('from json returns correct PhotoResource', () {
      expect(
        PhotoResource.fromJson(testPhotoEncoded),
        isA<PhotoResource>()
            .having((p) => p.id, 'id', testPhotoResource.id)
            .having((p) => p.albumId, 'albumId', testPhotoResource.albumId)
            .having((p) => p.title, 'title', testPhotoResource.title)
            .having((p) => p.url, 'url', testPhotoResource.url)
            .having(
              (p) => p.thumbnailUrl,
              'thumbnailUrl',
              testPhotoResource.thumbnailUrl,
            ),
      );
    });
  });
}
