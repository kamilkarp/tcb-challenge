import 'package:comments_repository/comments_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/view/app.dart';
import 'package:tcb_challenge/bootstrap.dart';

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockCommentsRepository extends Mock implements CommentsRepository {}

class MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

void main() {
  late PhotosRepository photosRepository;
  late CommentsRepository commentsRepository;
  late ConnectivityRepository connectivityRepository;

  setUp(() {
    photosRepository = MockPhotosRepository();
    commentsRepository = MockCommentsRepository();
    connectivityRepository = MockConnectivityRepository();

    when(() => connectivityRepository.onConnectivityChanged)
        .thenAnswer((_) => Stream.fromIterable([ConnectivityStatus.connected]));
  });

  group('Preffered orientation', () {
    late Widget appWidget;

    setUp(TestWidgetsFlutterBinding.ensureInitialized);

    testWidgets('is portraitUp or portraitDown', (tester) async {
      /// Based on: https://stackoverflow.com/a/71703425
      final logs = <dynamic>[];

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform, (methodCall) async {
        if (methodCall.method == 'SystemChrome.setPreferredOrientations') {
          logs.addAll(methodCall.arguments as List);
        }
        return null;
      });

      await bootstrap(() {
        return appWidget = App(
          photosRepository: photosRepository,
          commentsRepository: commentsRepository,
          connectivityRepository: connectivityRepository,
        );
      });

      await tester.pumpWidget(appWidget);

      expect(logs.length, 2);
      expect(logs.first, 'DeviceOrientation.portraitUp');
      expect(logs.last, 'DeviceOrientation.portraitDown');
    });
  });
}
