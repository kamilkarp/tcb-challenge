// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:tcb_challenge/photos/photos.dart';

import '../../helpers/helpers.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockCommentsRepository extends Mock implements CommentsRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  late PhotosRepository photosRepository;
  late CommentsRepository commentsRepository;
  late AppBloc appBloc;

  setUpAll(() {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
  });

  setUp(() {
    photosRepository = MockPhotosRepository();
    commentsRepository = MockCommentsRepository();
    appBloc = MockAppBloc();
  });

  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        App(
          commentsRepository: commentsRepository,
          photosRepository: photosRepository,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });

    testWidgets('fetches photos on start', (tester) async {
      await tester.pumpWidget(
        App(
          commentsRepository: commentsRepository,
          photosRepository: photosRepository,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);

      verify(
        () => photosRepository.fetchPhotos(
          startIndex: any(named: 'startIndex'),
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  });

  group('AppView', () {
    group('navigates', () {
      testWidgets('to PhotosPage when photos page is selected', (tester) async {
        when(() => appBloc.state).thenReturn(const AppState());

        await tester.pumpApp(
          const AppView(),
          appBloc: appBloc,
        );

        await tester.pumpAndSettle();
        expect(find.byType(PhotosPage), findsOneWidget);
      });

      testWidgets('to PhotosPage when comments page is selected',
          (tester) async {
        when(() => appBloc.state)
            .thenReturn(const AppState(currentPage: AppPages.comments));

        await tester.pumpApp(
          const AppView(),
          appBloc: appBloc,
        );

        await tester.pumpAndSettle();
        expect(find.byType(CommentsPage), findsOneWidget);
      });
    });
  });
}
