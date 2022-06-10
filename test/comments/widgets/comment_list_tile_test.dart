import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcb_challenge/comments/comments.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CommentListTile', () {
    testWidgets('renders comment correctly', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: CommentListTile(
            name: 'name',
            email: 'email@mail.com',
            body: 'body',
          ),
        ),
      );

      await tester.pump();

      expect(find.text('name'), findsOneWidget);
      expect(find.text('(email@mail.com)'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
    });
  });
}
