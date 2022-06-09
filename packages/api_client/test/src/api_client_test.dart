import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  final testPhotoResource = PhotoResource(
    id: 1,
    albumId: 1,
    title: 'title1',
    url: 'url.com/1',
    thumbnailUrl: 'urlthumb.com/1',
  );

  final testPhotoResource2 = PhotoResource(
    id: 2,
    albumId: 2,
    title: 'title2',
    url: 'url.com/2',
    thumbnailUrl: 'urlthumb.com/2',
  );

  final testPhotoCorrectResponse = http.Response(
    '[{ "id": 1, "albumId":1, "title": "title1", "url": "url.com/1", "thumbnailUrl": "urlthumb.com/1" }]',
    200,
  );

  final testTwoPhotosCorrectResponse = http.Response(
    '''
      [
        { "id": 1, "albumId":1, "title": "title1", "url": "url.com/1", "thumbnailUrl": "urlthumb.com/1" },
        { "id": 2, "albumId":2, "title": "title2", "url": "url.com/2", "thumbnailUrl": "urlthumb.com/2" }
      ]
      ''',
    200,
  );

  final testCommentResource = CommentResource(
    id: 1,
    postId: 1,
    body: 'body1',
    name: 'name1',
    email: 'asdfgh1@gmail.com',
  );

  final testCommentResource2 = CommentResource(
    id: 2,
    postId: 2,
    body: 'body2',
    name: 'name2',
    email: 'asdfgh2@gmail.com',
  );

  final testCommentCorrectResponse = http.Response(
    '''
      [{ "id": 1, "postId": 1, "body": "body1", "email": "asdfgh1@gmail.com", "name": "name1" }]
    ''',
    200,
  );

  final testTwoCommentsCorrectResponse = http.Response(
    '''
      [
        { "id": 1, "postId":1, "body": "body1", "email": "asdfgh1@gmail.com", "name": "name1" },
        { "id": 2, "postId":2, "body": "body2", "email": "asdfgh2@gmail.com", "name": "name2" }
      ]
      ''',
    200,
  );

  group('ApiClient', () {
    late http.Client httpClient;
    late ApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = ApiClient(client: httpClient, baseUrl: 'testurl.com');
    });

    test('can be instantiated', () {
      expect(ApiClient(client: httpClient, baseUrl: 'testurl.com'), isNotNull);
    });

    test('creates http client instance internally when not injected', () {
      expect(() => ApiClient(baseUrl: 'testurl.com'), isNot(throwsException));
    });

    group('fetchPhotos', () {
      const startIndex = 5;
      const limit = 8;
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        await apiClient.fetchPhotos(startIndex: startIndex, limit: limit);

        verify(
          () => httpClient.get(
            Uri.https(
              'testurl.com',
              'photos',
              <String, String>{
                '_start': startIndex.toString(),
                '_limit': limit.toString()
              },
            ),
          ),
        ).called(1);
      });

      test('returns PhotosResource on correct response', () async {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => testPhotoCorrectResponse);

        final photos = await apiClient.fetchPhotos();

        expect(photos.length, 1);

        expect(
          photos.first,
          isA<PhotoResource>()
              .having((p) => p.id, 'id', testPhotoResource.id)
              .having(
                (p) => p.albumId,
                'albumId',
                testPhotoResource.albumId,
              )
              .having((p) => p.title, 'title', testPhotoResource.title)
              .having((p) => p.url, 'url', testPhotoResource.url)
              .having(
                (p) => p.thumbnailUrl,
                'thumbnailUrl',
                testPhotoResource.thumbnailUrl,
              ),
        );
      });

      test('returns two PhotoResources on correct response', () async {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => testTwoPhotosCorrectResponse);

        final photos = await apiClient.fetchPhotos();

        expect(photos.length, 2);

        expect(
          photos.first,
          isA<PhotoResource>()
              .having((p) => p.id, 'id', testPhotoResource.id)
              .having(
                (p) => p.albumId,
                'albumId',
                testPhotoResource.albumId,
              )
              .having((p) => p.title, 'title', testPhotoResource.title)
              .having((p) => p.url, 'url', testPhotoResource.url)
              .having(
                (p) => p.thumbnailUrl,
                'thumbnailUrl',
                testPhotoResource.thumbnailUrl,
              ),
        );

        expect(
          photos.last,
          isA<PhotoResource>()
              .having((p) => p.id, 'id', testPhotoResource2.id)
              .having(
                (p) => p.albumId,
                'albumId',
                testPhotoResource2.albumId,
              )
              .having((p) => p.title, 'title', testPhotoResource2.title)
              .having((p) => p.url, 'url', testPhotoResource2.url)
              .having(
                (p) => p.thumbnailUrl,
                'thumbnailUrl',
                testPhotoResource2.thumbnailUrl,
              ),
        );
      });

      group('throws', () {
        test('InvalidArgumentsException when arguments are invalid', () async {
          await expectLater(
            apiClient.fetchPhotos(startIndex: -1),
            throwsA(isA<InvalidArgumentsException>()),
          );
          await expectLater(
            apiClient.fetchPhotos(limit: 0),
            throwsA(isA<InvalidArgumentsException>()),
          );
        });

        test('HttpRequestFailure when response code is not 200', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(404);
          when(() => response.body).thenReturn('[]');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            apiClient.fetchPhotos(),
            throwsA(
              isA<HttpRequestFailure>()
                  .having((e) => e.statusCode, 'statusCode', 404),
            ),
          );
        });

        test('CheckedFromJsonException when response body is invalid',
            () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('[{ "id": 1 }]');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            apiClient.fetchPhotos(),
            throwsA(isA<CheckedFromJsonException>()),
          );
        });
      });
    });

    group('fetchComments', () {
      const startIndex = 2;
      const limit = 3;
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('[]');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        await apiClient.fetchComments(startIndex: startIndex, limit: limit);

        verify(
          () => httpClient.get(
            Uri.https(
              'testurl.com',
              'comments',
              <String, String>{
                '_start': startIndex.toString(),
                '_limit': limit.toString()
              },
            ),
          ),
        ).called(1);
      });

      test('returns CommentsResource on correct response', () async {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => testCommentCorrectResponse);

        final comments = await apiClient.fetchComments();

        expect(comments.length, 1);

        expect(
          comments.first,
          isA<CommentResource>()
              .having((p) => p.id, 'id', testCommentResource.id)
              .having((p) => p.postId, 'postId', testCommentResource.postId)
              .having((p) => p.email, 'email', testCommentResource.email)
              .having((p) => p.body, 'body', testCommentResource.body)
              .having((p) => p.name, 'name', testCommentResource.name),
        );
      });

      test('returns two CommentResources on correct response', () async {
        when(() => httpClient.get(any()))
            .thenAnswer((_) async => testTwoCommentsCorrectResponse);

        final comments = await apiClient.fetchComments();

        expect(comments.length, 2);

        expect(
          comments.first,
          isA<CommentResource>()
              .having((p) => p.id, 'id', testCommentResource.id)
              .having((p) => p.postId, 'postId', testCommentResource.postId)
              .having((p) => p.email, 'email', testCommentResource.email)
              .having((p) => p.body, 'body', testCommentResource.body)
              .having((p) => p.name, 'name', testCommentResource.name),
        );

        expect(
          comments.last,
          isA<CommentResource>()
              .having((p) => p.id, 'id', testCommentResource2.id)
              .having(
                (p) => p.postId,
                'postId',
                testCommentResource2.postId,
              )
              .having((p) => p.email, 'email', testCommentResource2.email)
              .having((p) => p.body, 'body', testCommentResource2.body)
              .having((p) => p.name, 'name', testCommentResource2.name),
        );
      });

      group('throws', () {
        test('InvalidArgumentsException when arguments are invalid', () async {
          await expectLater(
            apiClient.fetchComments(startIndex: -1),
            throwsA(isA<InvalidArgumentsException>()),
          );
          await expectLater(
            apiClient.fetchComments(limit: 0),
            throwsA(isA<InvalidArgumentsException>()),
          );
        });

        test('HttpRequestFailure when response code is not 200', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(404);
          when(() => response.body).thenReturn('[]');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            apiClient.fetchComments(),
            throwsA(
              isA<HttpRequestFailure>()
                  .having((e) => e.statusCode, 'statusCode', 404),
            ),
          );
        });

        test('CheckedFromJsonException when response body is invalid',
            () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('[{ "id": 1 }]');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            apiClient.fetchComments(),
            throwsA(isA<CheckedFromJsonException>()),
          );
        });
      });
    });
  });
}
