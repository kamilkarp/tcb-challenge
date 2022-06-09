// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:test/test.dart';

class MockCommentsRepository extends Mock implements CommentsRepository {}

class MockComment extends Mock implements Comment {
  @override
  String get body => 'body';

  @override
  String get email => 'email@mail.com';

  @override
  String get name => 'name';

  @override
  int get postId => 1;
}

void main() {
  late CommentsRepository commentsRepository;
  final comment1 = MockComment();
  final comment2 = MockComment();

  late SplayTreeSet<Comment> emptyComments;

  setUp(() {
    emptyComments = SplayTreeSet<Comment>(
      (a, b) => a.id.compareTo(b.id),
    );
    when(() => comment1.id).thenReturn(1);
    when(() => comment2.id).thenReturn(2);

    commentsRepository = MockCommentsRepository();
  });

  group('CommentsBloc', () {
    test('initial state is CommentsInitial', () {
      expect(
        CommentsBloc(commentsRepository: commentsRepository).state,
        isA<CommentsInitial>(),
      );
    });

    group('splay tree is using correct compare function', () {
      test(
          'inserts comment with lower id first '
          'when first added comment has lower id', () {
        when(() => comment1.id).thenReturn(1);
        when(() => comment2.id).thenReturn(2);

        final splayTree = CommentsBloc(commentsRepository: commentsRepository)
            .state
            .comments
          ..addAll([comment1, comment2]);

        expect(splayTree.length, 2);
        expect(splayTree.first, comment1);
        expect(splayTree.last, comment2);
      });

      test(
          'inserts comment with lower id first '
          'when second added comment has lower id', () {
        when(() => comment1.id).thenReturn(1);
        when(() => comment2.id).thenReturn(2);

        final splayTree = CommentsBloc(commentsRepository: commentsRepository)
            .state
            .comments
          ..addAll([comment2, comment1]);

        expect(splayTree.length, 2);
        expect(splayTree.first, comment1);
        expect(splayTree.last, comment2);
      });
    });

    blocTest<CommentsBloc, CommentsState>(
      'emits nothing when CommentsFetch is added '
      'and state is CommentsLoading',
      build: () => CommentsBloc(commentsRepository: commentsRepository),
      seed: () => CommentsLoading(comments: emptyComments),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => const <CommentsState>[],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits nothing when CommentsFetch is added '
      'and state is CommentsSuccessMaxReached',
      build: () => CommentsBloc(commentsRepository: commentsRepository),
      seed: () => CommentsSuccessMaxReached(comments: emptyComments),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => const <CommentsState>[],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits [CommentsLoading, CommentsFailure] '
      'when CommentsFetch is added '
      'and fetching comments fails',
      setUp: () {
        when(
          () => commentsRepository.fetchComments(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow('test-error');
      },
      build: () => CommentsBloc(commentsRepository: commentsRepository),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => [
        isA<CommentsLoading>(),
        isA<CommentsFailure>().having((s) => s.comments.length, 'comments', 0),
      ],
      errors: () => ['test-error'],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits [CommentsLoading, CommentsSuccessMaxReached] '
      'when CommentsFetch is added '
      'and fetched less comments than set limit',
      setUp: () {
        when(
          () => commentsRepository.fetchComments(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([comment1]));
      },
      build: () =>
          CommentsBloc(commentsRepository: commentsRepository, limit: 2),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => [
        isA<CommentsLoading>(),
        isA<CommentsSuccessMaxReached>()
            .having((s) => s.comments.length, 'comments', 1)
            .having((s) => s.comments.first, 'comments', comment1),
      ],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits [CommentsLoading, CommentsSuccess] '
      'when CommentsFetch is added '
      'and fetched same number of comments as set limit',
      setUp: () {
        when(
          () => commentsRepository.fetchComments(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([comment1, comment2]));
      },
      build: () =>
          CommentsBloc(commentsRepository: commentsRepository, limit: 2),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => [
        isA<CommentsLoading>(),
        isA<CommentsSuccess>()
            .having((s) => s.comments.first, 'comments', comment1)
            .having((s) => s.comments.last, 'comments', comment2),
      ],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits [CommentsLoading, CommentsSuccess] '
      'with updated comment entry '
      'when CommentsFetch is added '
      'and set already contains comment with the same id',
      setUp: () {
        when(() => comment1.id).thenReturn(1);
        when(() => comment2.id).thenReturn(1);

        when(
          () => commentsRepository.fetchComments(
            startIndex: any(named: 'startIndex'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => Future.value([comment2]));
      },
      seed: () => CommentsSuccess(comments: emptyComments),
      build: () =>
          CommentsBloc(commentsRepository: commentsRepository, limit: 1),
      act: (bloc) => bloc.add(CommentsFetch()),
      expect: () => [
        isA<CommentsLoading>(),
        isA<CommentsSuccess>()
            .having((s) => s.comments, 'comments', emptyComments)
            .having((s) => s.comments.length, 'length of comments', 1)
            .having((s) => s.comments.first, 'first comment', comment2),
      ],
      verify: (_) => {expect(comment1, isNot(comment2))},
    );
  });
}
