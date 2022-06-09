import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

/// Thrown when the arguments passed to the function are invalid
class InvalidArgumentsException implements Exception {}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode);

  /// The status code of the response.
  final int statusCode;
}

/// {@template api_client}
/// Api client that allows fetching photos and comments
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({http.Client? client, required String baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  final http.Client _client;
  final String _baseUrl;

  /// Fetches list of photos starting from [startIndex].
  /// Limits list to [limit] photos.
  ///
  /// GET /photos REST call
  ///
  /// Throws a [InvalidArgumentsException] if arguments are invalid.
  /// Throws a [HttpRequestFailure] if response code is not 200.
  /// Throws a [CheckedFromJsonException] if decoding response fails.
  Future<List<PhotoResource>> fetchPhotos({
    int startIndex = 0,
    int limit = 1,
  }) async {
    if (startIndex < 0 || limit <= 0) throw InvalidArgumentsException();

    final uri = Uri.https(
      _baseUrl,
      '/photos',
      <String, String>{'_start': '$startIndex', '_limit': '$limit'},
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    final photosJson = jsonDecode(response.body) as List;

    return photosJson
        .map<PhotoResource>(
          (dynamic photoJson) =>
              PhotoResource.fromJson(photoJson as Map<String, dynamic>),
        )
        .toList();
  }

  /// Fetches list of comments starting from [startIndex].
  /// Limits list to [limit] comments.
  ///
  /// GET /comments REST call
  ///
  /// Throws a [InvalidArgumentsException] if arguments are invalid.
  /// Throws a [HttpRequestFailure] if response code is not 200.
  /// Throws a [CheckedFromJsonException] if decoding response fails.
  Future<List<CommentResource>> fetchComments({
    int startIndex = 0,
    int limit = 1,
  }) async {
    if (startIndex < 0 || limit <= 0) throw InvalidArgumentsException();

    final uri = Uri.https(
      _baseUrl,
      '/comments',
      <String, String>{'_start': '$startIndex', '_limit': '$limit'},
    );
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    final commentsJson = jsonDecode(response.body) as List;

    return commentsJson
        .map<CommentResource>(
          (dynamic commentJson) =>
              CommentResource.fromJson(commentJson as Map<String, dynamic>),
        )
        .toList();
  }
}
