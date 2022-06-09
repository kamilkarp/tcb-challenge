part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {}

class CommentsFetch extends CommentsEvent {
  CommentsFetch();

  @override
  List<Object> get props => [];
}
