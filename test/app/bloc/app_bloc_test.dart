import 'package:bloc_test/bloc_test.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:test/test.dart';

void main() {
  const testDestinationPage = AppPages.comments;
  group('AppBloc', () {
    test('initial state is AppState', () {
      expect(AppBloc().state, const AppState());
    });

    blocTest<AppBloc, AppState>(
      'emits nothing when current page is the same as requested destination',
      build: AppBloc.new,
      seed: () => const AppState(currentPage: testDestinationPage),
      act: (bloc) =>
          bloc.add(AppPageSelected(destinationPage: testDestinationPage)),
      expect: () => <AppState>[],
    );

    blocTest<AppBloc, AppState>(
      'emits state with correct current page '
      'when AppPageSelected is added.',
      build: AppBloc.new,
      act: (bloc) =>
          bloc.add(AppPageSelected(destinationPage: testDestinationPage)),
      expect: () => [const AppState(currentPage: testDestinationPage)],
    );
  });
}
