// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcb_challenge/connectivity/connectivity.dart';

import '../../helpers/helpers.dart';

class MockConnectivityBloc
    extends MockBloc<ConnectivityEvent, ConnectivityState>
    implements ConnectivityBloc {}

void main() {
  late ConnectivityBloc connectivityBloc;

  setUp(() {
    connectivityBloc = MockConnectivityBloc();
  });

  group('ConnectivityOverlay', () {
    testWidgets('renders child widget when state is connected', (tester) async {
      when(() => connectivityBloc.state)
          .thenReturn(ConnectivityState.connected);

      final testScaffoldKey = Key('test-scaffold');

      await tester.pumpApp(
        ConnectivityOverlay(
          child: Scaffold(key: testScaffoldKey, body: Container()),
        ),
        connectivityBloc: connectivityBloc,
      );

      expect(find.byKey(testScaffoldKey), findsOneWidget);
      expect(find.byType(ConnectivityNoConnectionOverlay), findsNothing);
    });

    testWidgets('renders child widget when state is unknown', (tester) async {
      when(() => connectivityBloc.state).thenReturn(ConnectivityState.unknown);

      final testScaffoldKey = Key('test-scaffold');

      await tester.pumpApp(
        ConnectivityOverlay(
          child: Scaffold(key: testScaffoldKey, body: Container()),
        ),
        connectivityBloc: connectivityBloc,
      );

      expect(find.byKey(testScaffoldKey), findsOneWidget);
      expect(find.byType(ConnectivityNoConnectionOverlay), findsNothing);
    });

    testWidgets(
        'renders ConnectivityNoConnectionOverlay widget '
        'when state is disconnected and noConnectionWidget is default',
        (tester) async {
      when(() => connectivityBloc.state)
          .thenReturn(ConnectivityState.disconnected);

      final testScaffoldKey = Key('test-scaffold');

      await tester.pumpApp(
        ConnectivityOverlay(
          child: Scaffold(key: testScaffoldKey, body: Container()),
        ),
        connectivityBloc: connectivityBloc,
      );

      expect(find.byType(ConnectivityNoConnectionOverlay), findsOneWidget);
      expect(find.byKey(testScaffoldKey), findsNothing);
    });

    testWidgets(
        'renders noConnectionWidget widget '
        'when state is disconnected', (tester) async {
      when(() => connectivityBloc.state)
          .thenReturn(ConnectivityState.disconnected);

      final testScaffoldKey = Key('test-scaffold');
      final testNoConnectionKey = Key('test-no-connection');

      await tester.pumpApp(
        ConnectivityOverlay(
          noConnectionWidget: Container(key: testNoConnectionKey),
          child: Scaffold(key: testScaffoldKey, body: Container()),
        ),
        connectivityBloc: connectivityBloc,
      );

      expect(find.byKey(testNoConnectionKey), findsOneWidget);
      expect(find.byType(ConnectivityNoConnectionOverlay), findsNothing);
      expect(find.byKey(testScaffoldKey), findsNothing);
    });

    group('adds', () {
      testWidgets(
          'ConnectivityCheck '
          'when resuming the app from background', (tester) async {
        whenListen(
          connectivityBloc,
          Stream<ConnectivityState>.empty(),
          initialState: ConnectivityState.unknown,
        );

        await tester.pumpApp(
          ConnectivityOverlay(
            child: Scaffold(body: Container()),
          ),
          connectivityBloc: connectivityBloc,
        );

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        verifyNever(
          () => connectivityBloc.add(ConnectivityCheck()),
        );
        await tester.pumpAndSettle();

        tester.binding
            .handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        await tester.pumpAndSettle();

        verify(() => connectivityBloc.add(ConnectivityCheck())).called(1);
      });
    });
  });
}
