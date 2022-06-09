// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/photos/photos.dart';
import 'package:test/test.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class FakePhoto extends Fake implements Photo {}

void main() {
  late PhotosRepository photosRepository;
  final photo1 = FakePhoto();
  final photo2 = FakePhoto();

  setUp(() {
    photosRepository = MockPhotosRepository();
  });

  group('PhotosBloc', () {
    test('initial state is PhotosState', () {
      expect(
        PhotosBloc(photosRepository: photosRepository).state,
        PhotosState(),
      );
    });

    blocTest<PhotosBloc, PhotosState>(
      'emits nothing when PhotosFetch is added '
      'and status is loading',
      build: () => PhotosBloc(photosRepository: photosRepository),
      seed: () => PhotosState(status: PhotosStatus.loading),
      act: (bloc) => bloc.add(PhotosFetch()),
      expect: () => const <PhotosState>[],
    );

    blocTest<PhotosBloc, PhotosState>(
      'emits nothing when PhotosFetch is added '
      'and maxPhotosReached is true',
      build: () => PhotosBloc(photosRepository: photosRepository),
      seed: () => PhotosState(maxPhotosReached: true),
      act: (bloc) => bloc.add(PhotosFetch()),
      expect: () => const <PhotosState>[],
    );

    blocTest<PhotosBloc, PhotosState>(
      'emits [state with loading status, state with failure status] '
      'when PhotosFetch is added '
      'and fetching photos fails',
      setUp: () {
        when(
          () => photosRepository.fetchPhotos(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow('test-error');
      },
      build: () => PhotosBloc(photosRepository: photosRepository),
      act: (bloc) => bloc.add(PhotosFetch()),
      expect: () => const <PhotosState>[
        PhotosState(status: PhotosStatus.loading),
        PhotosState(status: PhotosStatus.failure)
      ],
      errors: () => ['test-error'],
    );

    blocTest<PhotosBloc, PhotosState>(
      'emits [state with loading status, '
      'state with success status and maxPhotosReached] '
      'when PhotosFetch is added '
      'and fetched less photos than set limit',
      setUp: () {
        when(
          () => photosRepository.fetchPhotos(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([photo1]));
      },
      build: () => PhotosBloc(photosRepository: photosRepository, limit: 2),
      act: (bloc) => bloc.add(PhotosFetch()),
      expect: () => <PhotosState>[
        PhotosState(status: PhotosStatus.loading),
        PhotosState(
          status: PhotosStatus.success,
          maxPhotosReached: true,
          photos: [photo1],
        )
      ],
    );

    blocTest<PhotosBloc, PhotosState>(
      'emits [state with loading status, state with success status] '
      'when PhotosFetch is added '
      'and fetched less photos than set limit',
      setUp: () {
        when(
          () => photosRepository.fetchPhotos(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([photo1, photo2]));
      },
      build: () => PhotosBloc(photosRepository: photosRepository, limit: 2),
      act: (bloc) => bloc.add(PhotosFetch()),
      expect: () => <PhotosState>[
        PhotosState(status: PhotosStatus.loading),
        PhotosState(status: PhotosStatus.success, photos: [photo1, photo2])
      ],
    );
  });
}
