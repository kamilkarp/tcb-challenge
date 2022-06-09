// ignore_for_file: prefer_const_constructors

import 'package:tcb_challenge/photos/photos.dart';
import 'package:test/test.dart';

void main() {
  group('PhotosEvent', () {
    group('PhotosFetch', () {
      test('supports value comparison', () {
        expect(PhotosFetch(), PhotosFetch());
      });
    });
  });
}
