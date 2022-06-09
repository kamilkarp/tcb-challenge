import 'package:api_client/api_client.dart';
import 'package:comments_repository/comments_repository.dart';

/// {@template comments_repository}
/// Repository providing comments
/// {@endtemplate}
class CommentsRepository {
  /// {@macro comments_repository}
  CommentsRepository({ApiClient? apiClient})
      : _apiClient =
            apiClient ?? ApiClient(baseUrl: 'jsonplaceholder.typicode.com');

  final ApiClient _apiClient;

  /// Using repository's client, fetch list of comments
  /// starting from [startIndex].
  ///
  /// [limit] limits list of comments.
  Future<List<Comment>> fetchComments({
    int startIndex = 0,
    int limit = 1,
  }) async {
    final comments =
        await _apiClient.fetchComments(startIndex: startIndex, limit: limit);

    return comments.map(Comment.fromResource).toList();
  }
}
