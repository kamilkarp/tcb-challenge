import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photos_repository/photos_repository.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc({
    required PhotosRepository photosRepository,
    int limit = 15,
  })  : _photosRepository = photosRepository,
        _limit = limit,
        assert(
          limit > 0,
          'Number of photos per fetch should be higher than zero',
        ),
        super(const PhotosState()) {
    on<PhotosFetch>(_onPhotosFetch);
  }

  final PhotosRepository _photosRepository;
  final int _limit;

  Future<void> _onPhotosFetch(
    PhotosFetch event,
    Emitter<PhotosState> emit,
  ) async {
    if (state.maxPhotosReached || state.status.isLoading) return;

    emit(state.copyWith(status: PhotosStatus.loading));

    try {
      final photos = await _photosRepository.fetchPhotos(
        startIndex: state.photos.length,
        limit: _limit,
      );

      photos.length < _limit
          ? emit(
              state.copyWith(
                status: PhotosStatus.success,
                photos: List.of(state.photos)..addAll(photos),
                maxPhotosReached: true,
              ),
            )
          : emit(
              state.copyWith(
                status: PhotosStatus.success,
                photos: List.of(state.photos)..addAll(photos),
              ),
            );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PhotosStatus.failure));
      addError(error, stackTrace);
    }
  }
}
