// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/photos/photos.dart';

import '../../helpers/helpers.dart';

class MockPhotosBloc extends MockBloc<PhotosEvent, PhotosState>
    implements PhotosBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

final photo1 = Photo(
  id: 1,
  albumId: 1,
  title: 'title1',
  thumbnailUrl: 'thumb.com/1thumb.jpg',
  url: 'url.com/1.jpg',
);
final photo2 = Photo(
  id: 2,
  albumId: 2,
  title: 'title2',
  thumbnailUrl: 'thumb.com/2thumb.jpg',
  url: 'url.com/2.jpg',
);

void main() {
  late PhotosBloc photosBloc;
  late AppBloc appBloc;
  late List<Photo> photos;
  late List<Photo> emptyPhotos;

  final bottomLoaderKey = Key('photosPage_bottomLoader_CircularIndicator');
  final noPhotosTextKey = Key('photosPage_noPhotosText');
  final scrollToFetchKey = Key('photosPage_scrollToFetch');
  final retryButtonKey = Key('photosPage_retry_elevatedButton');

  setUpAll(() {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
  });

  setUp(() {
    photosBloc = MockPhotosBloc();
    appBloc = MockAppBloc();
    emptyPhotos = <Photo>[];
    photos = [photo1, photo2];

    when(() => appBloc.state).thenReturn(AppState());
    when(() => photosBloc.state).thenReturn(PhotosState());
  });

  group('PhotosPage', () {
    testWidgets('renders PhotosView', (tester) async {
      await tester.pumpApp(PhotosPage());

      await tester.pump();

      expect(find.byType(PhotosView), findsOneWidget);
    });

    testWidgets('contains WillPopScope which prevents pops ', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: appBloc,
          child: Navigator(
            pages: [PhotosPage.page()],
            onPopPage: (route, dynamic result) {
              return route.didPop(result);
            },
          ),
        ),
      );
      final willPopScope =
          tester.widget<WillPopScope>(find.byType(WillPopScope));
      expect(await willPopScope.onWillPop!(), isFalse);
    });
  });

  group('PhotosView', () {
    group('navigates', () {
      testWidgets('to PhotoPage when PhotoListTile is tapped', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: [photo1], status: PhotosStatus.success),
        );

        await tester.pumpApp(
          PhotosView(),
          photosBloc: photosBloc,
          appBloc: appBloc,
        );

        await tester.pump();

        await tester.ensureVisible(find.byType(PhotoListTile));
        await tester.tap(find.byType(PhotoListTile));

        await tester.pump();
        await tester.pump();

        await tester.ensureVisible(find.byType(PhotoPage));
        expect(find.byType(PhotoPage), findsOneWidget);
      });
    });
    group('renders', () {
      testWidgets('PhotosList', (tester) async {
        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byType(PhotosList), findsOneWidget);
      });

      testWidgets('BottomNavBar', (tester) async {
        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byType(BottomNavBar), findsOneWidget);
      });

      testWidgets('PhotoListTile when state contains photos', (tester) async {
        when(() => photosBloc.state).thenReturn(PhotosState(photos: photos));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byType(PhotoListTile), findsNWidgets(photos.length));
      });

      testWidgets(
          'NoPhotosText when photos list is empty and status is success',
          (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: emptyPhotos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(noPhotosTextKey), findsOneWidget);
      });

      testWidgets('ScrollToFetch when status is success', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: photos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(scrollToFetchKey), findsOneWidget);
      });

      testWidgets('RetryButton when status is failure', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(status: PhotosStatus.failure),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(retryButtonKey), findsOneWidget);
      });

      testWidgets('BottomLoader when status is loading', (tester) async {
        when(() => photosBloc.state)
            .thenReturn(PhotosState(status: PhotosStatus.loading));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(bottomLoaderKey), findsOneWidget);
      });
    });

    group('does not render', () {
      testWidgets('PhotoListTile when photos list is empty', (tester) async {
        when(() => photosBloc.state)
            .thenReturn(PhotosState(photos: emptyPhotos));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byType(PhotoListTile), findsNothing);
      });

      testWidgets(
          'NoPhotosText when photos list is not empty and status is success',
          (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: photos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(noPhotosTextKey), findsNothing);
      });

      testWidgets('ScrollToFetch when max number of photos is reached ',
          (tester) async {
        when(() => photosBloc.state)
            .thenReturn(PhotosState(photos: photos, maxPhotosReached: true));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(scrollToFetchKey), findsNothing);
      });

      testWidgets('BottomLoader when status is success', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: photos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        expect(find.byKey(bottomLoaderKey), findsNothing);
      });
    });

    group('adds', () {
      testWidgets('PhotosFetch when retry button is tapped', (tester) async {
        when(() => photosBloc.state)
            .thenReturn(PhotosState(status: PhotosStatus.failure));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        await tester.tap(find.byKey(retryButtonKey));

        verify(() => photosBloc.add(PhotosFetch())).called(1);
      });

      testWidgets(
          'PhotosFetch when ListView is scrolled down '
          'and state is status is success', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: photos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        await tester.drag(
          find.byType(PhotosList),
          const Offset(0, -300),
        );

        verify(() => photosBloc.add(PhotosFetch())).called(1);
      });

      testWidgets(
          'nothing when ListView is scrolled up '
          'and state is success', (tester) async {
        when(() => photosBloc.state).thenReturn(
          PhotosState(photos: photos, status: PhotosStatus.success),
        );

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        await tester.drag(
          find.byType(PhotosList),
          const Offset(0, 300),
        );

        verifyNever(() => photosBloc.add(PhotosFetch()));
      });

      testWidgets(
          'nothing when ListView is scrolled down '
          'and status is Failure', (tester) async {
        when(() => photosBloc.state)
            .thenReturn(PhotosState(status: PhotosStatus.failure));

        await tester.pumpApp(PhotosView(), photosBloc: photosBloc);

        await tester.drag(
          find.byType(PhotosList),
          const Offset(0, -300),
        );

        verifyNever(() => photosBloc.add(PhotosFetch()));
      });
    });
  });
}
