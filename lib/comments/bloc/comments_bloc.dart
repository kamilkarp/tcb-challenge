import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:equatable/equatable.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({
    required CommentsRepository commentsRepository,
    int limit = 10,
  })  : _commentsRepository = commentsRepository,
        _limit = limit,
        assert(
          limit > 0,
          'Number of comments per fetch should be higher than zero',
        ),
        super(
          CommentsInitial(
            comments: SplayTreeSet<Comment>(
              (a, b) => a.id.compareTo(b.id),
            ),
          ),
        ) {
    on<CommentsFetch>(_onCommentsFetch);
  }

  final CommentsRepository _commentsRepository;
  final int _limit;

  Future<void> _onCommentsFetch(
    CommentsFetch event,
    Emitter<CommentsState> emit,
  ) async {
    if (state is CommentsSuccessMaxReached || state is CommentsLoading) return;

    emit(CommentsLoading(comments: state.comments));

    try {
      final comments = await _commentsRepository.fetchComments(
        startIndex: state.comments.length,
        limit: _limit,
      );

      // remove comments with the same id from the tree
      for (final comment in comments) {
        if (state.comments.contains(comment)) state.comments.remove(comment);
      }

      state.comments.addAll(comments);

      comments.length < _limit
          ? emit(CommentsSuccessMaxReached(comments: state.comments))
          : emit(CommentsSuccess(comments: state.comments));
    } catch (error, stackTrace) {
      emit(CommentsFailure(comments: state.comments));
      addError(error, stackTrace);
    }
  }
}
