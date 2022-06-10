// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/photos/photos.dart';
import 'package:tcb_challenge/photos/widgets/photo_image.dart';

import '../../helpers/helpers.dart';

class MockPhotosBloc extends MockBloc<PhotosEvent, PhotosState>
    implements PhotosBloc {}

final photo1 = Photo(
  id: 1,
  albumId: 1,
  title: 'title1',
  thumbnailUrl: 'thumb.com/1thumb.jpg',
  url: 'url.com/1.jpg',
);

void main() {
  late PhotosBloc photosBloc;

  setUp(() {
    photosBloc = MockPhotosBloc();

    when(() => photosBloc.state).thenReturn(PhotosState(photos: [photo1]));
  });

  group('PhotoPage', () {
    testWidgets('renders PhotoView', (tester) async {
      await tester.pumpApp(
        PhotoPage(photoId: photo1.id),
        photosBloc: photosBloc,
      );

      expect(find.byType(PhotoView), findsOneWidget);
    });
  });

  group('PhotoView', () {
    group('renders', () {
      testWidgets('PhotoImage', (tester) async {
        await tester.pumpApp(
          PhotoView(photoId: photo1.id),
          photosBloc: photosBloc,
        );

        final photoImage = tester.widget<PhotoImage>(find.byType(PhotoImage));

        expect(find.byType(PhotoImage), findsOneWidget);
        expect(photoImage.url, photo1.url);
      });

      testWidgets('photo title', (tester) async {
        await tester.pumpApp(
          PhotoView(photoId: photo1.id),
          photosBloc: photosBloc,
        );

        expect(find.text(photo1.title), findsOneWidget);
      });
    });
  });
}
