// ignore_for_file: prefer_const_constructors

import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/photos/photos.dart';
import 'package:test/test.dart';

void main() {
  group('PhotosState', () {
    test('supports value comparison', () {
      expect(PhotosState(), PhotosState());
      expect(PhotosState(), isNot(PhotosState(maxPhotosReached: true)));
    });

    test('returns same state when no properties are passed', () {
      expect(const PhotosState().copyWith(), const PhotosState());
    });

    test('returns updated maxPhotosReached when new one is passed', () {
      expect(
        const PhotosState().copyWith(maxPhotosReached: true),
        const PhotosState(maxPhotosReached: true),
      );
    });
    test('returns updated status when new one is passed', () {
      expect(
        const PhotosState().copyWith(status: PhotosStatus.success),
        const PhotosState(status: PhotosStatus.success),
      );
    });
    test('returns updated photos when new ones are passed', () {
      const testPhoto = Photo(
        id: 1,
        albumId: 2,
        title: 'title',
        thumbnailUrl: 'thumbnailUrl.com/1',
        url: 'url.com/1',
      );
      expect(
        const PhotosState().copyWith(photos: [testPhoto]),
        const PhotosState(photos: [testPhoto]),
      );
    });
  });

  group('PhotosStatusX', () {
    test('constains isInitial', () {
      const status = PhotosStatus.initial;
      expect(status.isInitial, true);
    });
    test('constains isLoading', () {
      const status = PhotosStatus.loading;
      expect(status.isLoading, true);
    });
    test('constains isSuccess', () {
      const status = PhotosStatus.success;
      expect(status.isSuccess, true);
    });
    test('constains isFailure', () {
      const status = PhotosStatus.failure;
      expect(status.isFailure, true);
    });
  });
}
