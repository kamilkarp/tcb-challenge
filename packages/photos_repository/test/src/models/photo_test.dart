// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Photo', () {
    test('supports value comparison', () {
      expect(
        Photo(
          id: 1,
          albumId: 1,
          title: 'title',
          url: 'url.com/1',
          thumbnailUrl: 'thumb.com/1',
        ),
        Photo(
          id: 1,
          albumId: 1,
          title: 'title',
          url: 'url.com/1',
          thumbnailUrl: 'thumb.com/1',
        ),
      );

      expect(
        Photo(
          id: 1,
          albumId: 1,
          title: 'title',
          url: 'url.com/1',
          thumbnailUrl: 'thumb.com/1',
        ),
        isNot(
          Photo(
            id: 2,
            albumId: 2,
            title: 'title',
            url: 'url.com/2',
            thumbnailUrl: 'thumb.com/2',
          ),
        ),
      );
    });

    test('creates correct Photo from PhotoResource', () {
      final resource = PhotoResource(
        id: 1,
        albumId: 1,
        title: 'title',
        thumbnailUrl: 'thumbnailUrl.com/1',
        url: 'url.com/1',
      );

      expect(
        Photo.fromResource(resource),
        Photo(
          id: 1,
          albumId: 1,
          title: 'title',
          thumbnailUrl: 'thumbnailUrl.com/1',
          url: 'url.com/1',
        ),
      );
    });
  });
}
