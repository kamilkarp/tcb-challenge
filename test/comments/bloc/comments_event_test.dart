// ignore_for_file: prefer_const_constructors

import 'package:tcb_challenge/comments/comments.dart';
import 'package:test/test.dart';

void main() {
  group('CommentsEvent', () {
    group('CommentsFetch', () {
      test('supports value comparison', () {
        expect(CommentsFetch(), CommentsFetch());
      });
    });
  });
}
