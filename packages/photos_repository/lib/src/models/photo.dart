import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';

/// {@template photo}
/// Photo
/// {@endtemplate}
class Photo extends Equatable {
  /// {@macro photo}
  const Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  /// Create [Photo] from [PhotoResource]
  factory Photo.fromResource(PhotoResource resource) => Photo(
        id: resource.id,
        albumId: resource.albumId,
        title: resource.title,
        url: resource.url,
        thumbnailUrl: resource.thumbnailUrl,
      );

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

  @override
  List<Object> get props => [id, albumId, title, url, thumbnailUrl];
}
