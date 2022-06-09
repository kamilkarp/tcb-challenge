import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

/// {@template comment}
/// Comment
/// {@endtemplate}
class Comment extends Equatable {
  /// {@macro comment}
  const Comment({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  /// Create [Comment] from [CommentResource]
  factory Comment.fromResource(CommentResource commentResource) => Comment(
        id: commentResource.id,
        postId: commentResource.postId,
        name: commentResource.name,
        email: commentResource.email,
        body: commentResource.body,
      );

  /// Comment's id
  final int id;

  /// Comment's post id
  final int postId;

  /// Comment's name
  final String name;

  /// Comment's email
  final String email;

  /// Comment's body
  final String body;

  @override
  List<Object> get props => [id, postId, name, email, body];
}
