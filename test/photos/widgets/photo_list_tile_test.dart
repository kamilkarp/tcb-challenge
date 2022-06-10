import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcb_challenge/photos/photos.dart';
import 'package:tcb_challenge/photos/widgets/photo_image.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PhotoListTile', () {
    testWidgets('renders photo tile correctly', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: PhotoListTile(
            title: 'title',
            thumbnailUrl: 'thumb.com/1',
          ),
        ),
      );

      await tester.pump();

      expect(find.text('title'), findsOneWidget);
      expect(find.byType(PhotoImage), findsOneWidget);
    });

    testWidgets('triggers tap funcion on tap', (tester) async {
      var tileTapped = false;

      await tester.pumpApp(
        Scaffold(
          body: PhotoListTile(
            title: 'title',
            thumbnailUrl: 'thumb.com/1',
            onTap: () => tileTapped = true,
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.byType(PhotoListTile));

      expect(tileTapped, isTrue);
    });
  });
}
