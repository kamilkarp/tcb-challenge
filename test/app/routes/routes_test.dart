import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:tcb_challenge/photos/photos.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns PhotosPage when photos page selected', () {
      expect(
        onGenerateAppViewPages(AppPages.photos, []),
        [
          isA<MaterialPage>().having(
            (p) => p.child,
            'child',
            isA<PhotosPage>(),
          )
        ],
      );
    });

    test('returns CommentsPage when comments page selected', () {
      expect(
        onGenerateAppViewPages(AppPages.comments, []),
        [
          isA<MaterialPage>().having(
            (p) => p.child,
            'child',
            isA<CommentsPage>(),
          )
        ],
      );
    });
  });
}
