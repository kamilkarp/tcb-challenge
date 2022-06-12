// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcb_challenge/connectivity/bloc/connectivity_bloc.dart';
import 'package:test/test.dart';

class MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

void main() {
  late ConnectivityRepository connectivityRepository;

  setUp(() {
    connectivityRepository = MockConnectivityRepository();

    when(() => connectivityRepository.onConnectivityChanged)
        .thenAnswer((_) => Stream.empty());
  });

  group('ConnectivityBloc', () {
    test('initial state is ConnectivityState.unknown', () {
      expect(
        ConnectivityBloc(connectivityRepository: connectivityRepository).state,
        ConnectivityState.unknown,
      );
    });

    group('ConnectivityCheck', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'emits ConnectivityState.connected '
        'when ConnectivityStatus is connected',
        setUp: () {
          when(() => connectivityRepository.checkConnectivityStatus())
              .thenAnswer((_) => Future.value(ConnectivityStatus.connected));
        },
        build: () =>
            ConnectivityBloc(connectivityRepository: connectivityRepository),
        act: (bloc) => bloc.add(ConnectivityCheck()),
        expect: () => [ConnectivityState.connected],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'emits ConnectivityState.disconnected '
        'when ConnectivityStatus is disconnected',
        setUp: () {
          when(() => connectivityRepository.checkConnectivityStatus())
              .thenAnswer((_) => Future.value(ConnectivityStatus.disconnected));
        },
        build: () =>
            ConnectivityBloc(connectivityRepository: connectivityRepository),
        act: (bloc) => bloc.add(ConnectivityCheck()),
        expect: () => [ConnectivityState.disconnected],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'emits ConnectivityState.unknown '
        'when checkConnectivityStatus throws',
        setUp: () {
          when(() => connectivityRepository.checkConnectivityStatus())
              .thenThrow('test-error');
        },
        build: () =>
            ConnectivityBloc(connectivityRepository: connectivityRepository),
        act: (bloc) => bloc.add(ConnectivityCheck()),
        expect: () => [ConnectivityState.unknown],
        errors: () => ['test-error'],
      );
    });

    group('ConnectivityChanged', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'emits '
        '[ConnectivityState.connected, ConnectivityState.disconnected] '
        'when ConnectivityStatus is connected then disconnected',
        setUp: () {
          when(() => connectivityRepository.onConnectivityChanged).thenAnswer(
            (_) => Stream.fromIterable([
              ConnectivityStatus.connected,
              ConnectivityStatus.disconnected,
            ]),
          );
        },
        build: () =>
            ConnectivityBloc(connectivityRepository: connectivityRepository),
        expect: () => [
          ConnectivityState.connected,
          ConnectivityState.disconnected,
        ],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'emits ConnectivityState.unknown '
        'when onConnectivityChanged returns an error ',
        setUp: () {
          when(() => connectivityRepository.onConnectivityChanged)
              .thenAnswer((_) => Stream.error('test-error'));
        },
        build: () =>
            ConnectivityBloc(connectivityRepository: connectivityRepository),
        expect: () => [ConnectivityState.unknown],
        errors: () => ['test-error'],
      );
    });
  });
}
