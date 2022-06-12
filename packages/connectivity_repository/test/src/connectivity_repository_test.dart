// ignore_for_file: prefer_const_constructors
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late Connectivity connectivity;
  late ConnectivityRepository connectivityRepository;

  setUp(() {
    connectivity = MockConnectivity();
    connectivityRepository = ConnectivityRepository(connectivity: connectivity);

    when(
      () => connectivity.onConnectivityChanged,
    ).thenAnswer((_) => Stream.value(ConnectivityResult.wifi));

    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => ConnectivityResult.wifi);
  });

  group('ConnectivityRepository', () {
    test('can be instantiated', () {
      expect(ConnectivityRepository(connectivity: connectivity), isNotNull);
    });

    test('creates Connectivity instance internally when not injected', () {
      expect(ConnectivityRepository(), isNot(throwsException));
    });

    group('onConnectivityChanged', () {
      test('calls onConnectivityChanged', () async {
        connectivityRepository.onConnectivityChanged;
        verify(() => connectivity.onConnectivityChanged).called(1);
      });

      test('returns correct ConnectivityStatuses', () async {
        when(
          () => connectivity.onConnectivityChanged,
        ).thenAnswer(
          (_) => Stream.fromIterable([
            ConnectivityResult.wifi,
            ConnectivityResult.ethernet,
            ConnectivityResult.mobile,
            ConnectivityResult.bluetooth,
            ConnectivityResult.none
          ]),
        );

        final receivedStatuses = <ConnectivityStatus>[];
        final expectedStatuses = [
          ConnectivityStatus.connected,
          ConnectivityStatus.connected,
          ConnectivityStatus.connected,
          ConnectivityStatus.disconnected,
          ConnectivityStatus.disconnected,
        ];

        final connectivityStatusSubscription = connectivityRepository
            .onConnectivityChanged
            .listen(receivedStatuses.add);

        // ignore: empty_statements
        await for (final _ in connectivityRepository.onConnectivityChanged) {}

        expect(receivedStatuses, equals(expectedStatuses));

        await connectivityStatusSubscription.cancel();
      });
    });

    group('checkConnectivityStatus', () {
      test('calls checkConnectivity', () async {
        await connectivityRepository.checkConnectivityStatus();
        verify(() => connectivity.checkConnectivity()).called(1);
      });

      test('returns correct ConnectivityStatuses', () async {
        final expectedStatuses = [
          ConnectivityStatus.connected,
          ConnectivityStatus.connected,
          ConnectivityStatus.connected,
          ConnectivityStatus.disconnected,
          ConnectivityStatus.disconnected,
        ];

        final connectivityResults = [
          ConnectivityResult.wifi,
          ConnectivityResult.ethernet,
          ConnectivityResult.mobile,
          ConnectivityResult.bluetooth,
          ConnectivityResult.none,
        ];

        expect(expectedStatuses.length, connectivityResults.length);

        for (var resultIndex = 0;
            resultIndex < connectivityResults.length;
            resultIndex++) {
          when(
            () => connectivity.checkConnectivity(),
          ).thenAnswer(
            (_) => Future.value(connectivityResults[resultIndex]),
          );

          expect(
            await connectivityRepository.checkConnectivityStatus(),
            expectedStatuses[resultIndex],
          );
        }
      });
    });
  });
}
