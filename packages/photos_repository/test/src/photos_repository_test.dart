// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockPhotoResource extends Mock implements PhotoResource {
  @override
  int get id => 1;
  @override
  int get albumId => 1;
  @override
  String get title => 'title';
  @override
  String get url => 'url.com/1';
  @override
  String get thumbnailUrl => 'thumb.com/1';
}

void main() {
  final photo = Photo(
    id: 1,
    albumId: 1,
    title: 'title',
    url: 'url.com/1',
    thumbnailUrl: 'thumb.com/1',
  );

  group('PhotosRepository', () {
    late ApiClient apiClient;
    late PhotosRepository photosRepository;

    setUp(() {
      apiClient = MockApiClient();
      photosRepository = PhotosRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(PhotosRepository(apiClient: apiClient), isNotNull);
    });

    test('uses ApiClient instance internally when not injected', () {
      expect(PhotosRepository(), isNot(throwsException));
    });

    group('fetchPhotos', () {
      test('calls api client', () async {
        when(() => apiClient.fetchPhotos())
            .thenAnswer((_) => Future.value([MockPhotoResource()]));

        await photosRepository.fetchPhotos();

        verify(() => apiClient.fetchPhotos()).called(1);
      });

      test('returns list with correct photos', () async {
        when(
          () => apiClient.fetchPhotos(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) => Future.value([MockPhotoResource(), MockPhotoResource()]),
        );

        final fetchedPhotos = await photosRepository.fetchPhotos();

        expect(fetchedPhotos, [photo, photo]);
      });

      test('throws when fetchPhotos fails', () async {
        final exception = Exception('exception');

        when(() => apiClient.fetchPhotos()).thenThrow(exception);

        await expectLater(
          photosRepository.fetchPhotos(),
          throwsA(exception),
        );
      });
    });
  });
}
