import 'package:json_annotation/json_annotation.dart';

part 'comment_resource.g.dart';

/// {@template comment_resource}
/// Comment resource
/// {@endtemplate}
@JsonSerializable()
class CommentResource {
  /// {@macro comment_resource}
  CommentResource({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  /// Create [CommentResource] from json map
  factory CommentResource.fromJson(Map<String, dynamic> json) =>
      _$CommentResourceFromJson(json);

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
}
