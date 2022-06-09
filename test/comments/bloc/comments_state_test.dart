// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:comments_repository/comments_repository.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:test/test.dart';

void main() {
  late SplayTreeSet<Comment> comments;

  setUp(() {
    comments = SplayTreeSet<Comment>(
      (a, b) => a.id.compareTo(b.id),
    );
  });

  group('CommentsState', () {
    group('CommentsInitial', () {
      test('does not support value comparison', () {
        expect(
          CommentsInitial(comments: comments),
          isNot(CommentsInitial(comments: comments)),
        );
      });
    });

    group('CommentsLoading', () {
      test('does not support value comparison', () {
        expect(
          CommentsLoading(comments: comments),
          isNot(CommentsLoading(comments: comments)),
        );
      });
    });

    group('CommentsFailure', () {
      test('does not support value comparison', () {
        expect(
          CommentsFailure(comments: comments),
          isNot(CommentsFailure(comments: comments)),
        );
      });
    });

    group('CommentsSuccess', () {
      test('does not support value comparison', () {
        expect(
          CommentsSuccess(comments: comments),
          isNot(CommentsSuccess(comments: comments)),
        );
      });
    });

    group('CommentsSuccessMaxReached', () {
      test('does not support value comparison', () {
        expect(
          CommentsSuccessMaxReached(comments: comments),
          isNot(CommentsSuccessMaxReached(comments: comments)),
        );
      });
    });
  });

  group('CommentsStatusX', () {
    test('constains isInitial', () {
      const status = CommentsStatus.initial;
      expect(status.isInitial, true);
    });
    test('constains isLoading', () {
      const status = CommentsStatus.loading;
      expect(status.isLoading, true);
    });
    test('constains isSuccess', () {
      const status = CommentsStatus.success;
      expect(status.isSuccess, true);
    });
    test('constains isFailure', () {
      const status = CommentsStatus.failure;
      expect(status.isFailure, true);
    });
  });
}
