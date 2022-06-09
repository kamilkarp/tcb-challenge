import 'package:json_annotation/json_annotation.dart';

part 'photo_resource.g.dart';

/// {@template photo_resource}
/// Photo resource
/// {@endtemplate}
@JsonSerializable()
class PhotoResource {
  /// {@macro photo_resource}
  PhotoResource({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  /// Create [PhotoResource] from json map
  factory PhotoResource.fromJson(Map<String, dynamic> json) =>
      _$PhotoResourceFromJson(json);

  /// Photo's id
  final int id;

  /// Photo's album id
  final int albumId;

  /// Photo's title
  final String title;

  /// Photo's url
  final String url;

  /// Photo's thumbnail url
  final String thumbnailUrl;
}
