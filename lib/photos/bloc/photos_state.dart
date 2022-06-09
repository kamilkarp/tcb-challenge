part of 'photos_bloc.dart';

enum PhotosStatus {
  initial,
  loading,
  success,
  failure,
}

extension PhotosStatusX on PhotosStatus {
  bool get isInitial => this == PhotosStatus.initial;
  bool get isLoading => this == PhotosStatus.loading;
  bool get isSuccess => this == PhotosStatus.success;
  bool get isFailure => this == PhotosStatus.failure;
}

class PhotosState extends Equatable {
  const PhotosState({
    this.photos = const [],
    this.status = PhotosStatus.initial,
    this.maxPhotosReached = false,
  });

  final List<Photo> photos;
  final PhotosStatus status;
  final bool maxPhotosReached;

  @override
  List<Object> get props => [photos, status, maxPhotosReached];

  PhotosState copyWith({
    List<Photo>? photos,
    final PhotosStatus? status,
    final bool? maxPhotosReached,
  }) {
    return PhotosState(
      photos: photos ?? this.photos,
      status: status ?? this.status,
      maxPhotosReached: maxPhotosReached ?? this.maxPhotosReached,
    );
  }
}
