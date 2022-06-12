// ignore_for_file: prefer_const_constructors
import 'package:tcb_challenge/connectivity/connectivity.dart';
import 'package:test/test.dart';

void main() {
  group('ConnectivityEvent', () {
    group('ConnectivityFetch', () {
      test('Supports value comparison', () {
        expect(ConnectivityCheck(), ConnectivityCheck());
      });
    });
  });
}
