import 'package:tcb_challenge/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('AppEvent', () {
    test('supports value comparison', () {
      expect(
        AppPageSelected(destinationPage: AppPages.photos),
        AppPageSelected(destinationPage: AppPages.photos),
      );

      expect(
        AppPageSelected(destinationPage: AppPages.photos),
        isNot(AppPageSelected(destinationPage: AppPages.comments)),
      );
    });
  });
}
