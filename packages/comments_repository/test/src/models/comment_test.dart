// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Comment', () {
    test('supports value comparison', () {
      expect(
        Comment(id: 1, postId: 1, name: 'name', email: 'email', body: 'body'),
        Comment(id: 1, postId: 1, name: 'name', email: 'email', body: 'body'),
      );

      expect(
        Comment(id: 1, postId: 1, name: 'name', email: 'email', body: 'body'),
        isNot(
          Comment(
            id: 2,
            postId: 2,
            name: 'name2',
            email: 'email2',
            body: 'body2',
          ),
        ),
      );
    });

    test('creates correct Comment from CommentResource', () {
      final resource = CommentResource(
        id: 1,
        postId: 1,
        name: 'name',
        email: 'email',
        body: 'body',
      );

      expect(
        Comment.fromResource(resource),
        Comment(id: 1, postId: 1, name: 'name', email: 'email', body: 'body'),
      );
    });
  });
}
