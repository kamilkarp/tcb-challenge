part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {}

class PhotosFetch extends PhotosEvent {
  PhotosFetch();

  @override
  List<Object> get props => [];
}
