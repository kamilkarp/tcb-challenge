import 'package:api_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('CommentResource', () {
    final testCommentResource = CommentResource(
      id: 1,
      postId: 1,
      body: "4639dgje^@#&**(d\"hfhj sgsad !@''",
      email: 'testemail@gmail.com',
      name: "asdg sdlg@^#\"@^@ ' test",
    );

    final testCommentEncoded = {
      'id': testCommentResource.id,
      'postId': testCommentResource.postId,
      'body': testCommentResource.body,
      'email': testCommentResource.email,
      'name': testCommentResource.name,
    };

    test('from json returns correct CommentResource', () {
      expect(
        CommentResource.fromJson(testCommentEncoded),
        isA<CommentResource>()
            .having((p) => p.id, 'id', testCommentResource.id)
            .having((p) => p.postId, 'postId', testCommentResource.postId)
            .having((p) => p.body, 'body', testCommentResource.body)
            .having((p) => p.email, 'email', testCommentResource.email)
            .having(
              (p) => p.name,
              'name',
              testCommentResource.name,
            ),
      );
    });
  });
}
