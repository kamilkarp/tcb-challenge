part of 'comments_bloc.dart';

enum CommentsStatus {
  initial,
  loading,
  success,
  failure,
}

extension CommentsStatusX on CommentsStatus {
  bool get isInitial => this == CommentsStatus.initial;
  bool get isLoading => this == CommentsStatus.loading;
  bool get isSuccess => this == CommentsStatus.success;
  bool get isFailure => this == CommentsStatus.failure;
}

abstract class CommentsState {
  CommentsState({required this.comments});

  final SplayTreeSet<Comment> comments;
}

class CommentsInitial extends CommentsState {
  CommentsInitial({required SplayTreeSet<Comment> comments})
      : super(comments: comments);
}

class CommentsLoading extends CommentsState {
  CommentsLoading({required SplayTreeSet<Comment> comments})
      : super(comments: comments);
}

class CommentsSuccess extends CommentsState {
  CommentsSuccess({required SplayTreeSet<Comment> comments})
      : super(comments: comments);
}

class CommentsSuccessMaxReached extends CommentsState {
  CommentsSuccessMaxReached({required SplayTreeSet<Comment> comments})
      : super(comments: comments);
}

class CommentsFailure extends CommentsState {
  CommentsFailure({required SplayTreeSet<Comment> comments})
      : super(comments: comments);
}
