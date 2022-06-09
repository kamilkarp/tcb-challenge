import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcb_challenge/app/app.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends Mock implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  late AppBloc appBloc;

  setUpAll(() {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
  });

  setUp(() {
    appBloc = MockAppBloc();

    when(() => appBloc.state).thenReturn(const AppState());

    whenListen(appBloc, const Stream<AppState>.empty());
  });

  group('BottomNavBar', () {
    group('renders', () {
      testWidgets('BottomAppBar having items equal to AppPages count',
          (tester) async {
        await tester.pumpApp(
          const BottomNavBar(),
          appBloc: appBloc,
        );

        final bottomNavbar = tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar));

        expect(bottomNavbar.items.length, AppPages.values.length);
      });
    });

    group('adds', () {
      testWidgets('nothing when active icon is tapped', (tester) async {
        await tester.pumpApp(
          const BottomNavBar(),
          appBloc: appBloc,
        );

        final currentIndex = appBloc.state.currentPage.index;

        final bottombar = tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
        expect(bottombar.currentIndex, currentIndex);

        await tester.tap(
          find.byWidget(bottombar.items[currentIndex].activeIcon),
        );

        verifyNever(
          () => appBloc.add(
            AppPageSelected(
              destinationPage: AppPages.values[currentIndex],
            ),
          ),
        );
      });
      testWidgets('AppPageSelected when inactive icon is tapped',
          (tester) async {
        await tester.pumpApp(
          const BottomNavBar(),
          appBloc: appBloc,
        );

        final currentIndex = appBloc.state.currentPage.index;
        final nextIndex = AppPages.comments.index;

        expect(currentIndex != nextIndex, isTrue);

        final bottombar = tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
        expect(bottombar.currentIndex, currentIndex);

        await tester.tap(find.byWidget(bottombar.items[nextIndex].icon));

        verify(
          () => appBloc.add(
            AppPageSelected(destinationPage: AppPages.values[nextIndex]),
          ),
        ).called(1);
      });
    });
  });
}
