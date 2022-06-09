// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockCommentResource extends Mock implements CommentResource {
  @override
  int get id => 1;
  @override
  int get postId => 1;
  @override
  String get name => 'name';
  @override
  String get email => 'email';
  @override
  String get body => 'body';
}

void main() {
  final comment =
      Comment(id: 1, postId: 1, name: 'name', email: 'email', body: 'body');

  group('CommentsRepository', () {
    late ApiClient apiClient;
    late CommentsRepository commentsRepository;

    setUp(() {
      apiClient = MockApiClient();
      commentsRepository = CommentsRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(CommentsRepository(apiClient: apiClient), isNotNull);
    });

    test('uses ApiClient instance internally when not injected', () {
      expect(CommentsRepository(), isNot(throwsException));
    });

    group('fetchComments', () {
      test('calls api client', () async {
        when(() => apiClient.fetchComments())
            .thenAnswer((_) => Future.value([MockCommentResource()]));

        await commentsRepository.fetchComments();

        verify(() => apiClient.fetchComments()).called(1);
      });

      test('returns list with correct comments', () async {
        when(
          () => apiClient.fetchComments(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) => Future.value([MockCommentResource(), MockCommentResource()]),
        );

        final fetchedComments = await commentsRepository.fetchComments();

        expect(fetchedComments, [comment, comment]);
      });

      test('throws when fetchComments fails', () async {
        final exception = Exception('exception');

        when(() => apiClient.fetchComments()).thenThrow(exception);

        await expectLater(
          commentsRepository.fetchComments(),
          throwsA(exception),
        );
      });
    });
  });
}
