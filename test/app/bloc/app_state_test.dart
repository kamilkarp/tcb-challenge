import 'package:tcb_challenge/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('AppState', () {
    test('supports value comparison', () {
      expect(const AppState(), const AppState());
      expect(
        const AppState(),
        isNot(const AppState(currentPage: AppPages.comments)),
      );
    });
    test('initial page is photos page', () {
      expect(const AppState().currentPage, AppPages.photos);
    });
  });
}
