// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:tcb_challenge/l10n/l10n.dart';
import 'package:tcb_challenge/photos/photos.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState();
}

class MockPhotosRepository extends Mock implements PhotosRepository {}

class MockCommentsRepository extends Mock implements CommentsRepository {}

class MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

class MockCommentsBloc extends MockBloc<CommentsEvent, CommentsState>
    implements CommentsBloc {
  final comments = SplayTreeSet<Comment>();

  @override
  CommentsState get state => CommentsInitial(comments: comments);
}

class MockPhotosBloc extends MockBloc<PhotosEvent, PhotosState>
    implements PhotosBloc {
  @override
  PhotosState get state => const PhotosState();
}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void registerFallbackValues() {
  registerFallbackValue(FakeAppEvent());
  registerFallbackValue(FakeAppState());
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AppBloc? appBloc,
    PhotosBloc? photosBloc,
    CommentsBloc? commentsBloc,
    CommentsRepository? commentsRepository,
    PhotosRepository? photosRepository,
    ConnectivityRepository? connectivityRepository,
    NavigatorObserver? navigatorObserver,
  }) async {
    registerFallbackValues();

    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: photosRepository ?? MockPhotosRepository(),
          ),
          RepositoryProvider.value(
            value: commentsRepository ?? MockCommentsRepository(),
          ),
          RepositoryProvider.value(
            value: connectivityRepository ?? MockConnectivityRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
            BlocProvider.value(value: photosBloc ?? MockPhotosBloc()),
            BlocProvider.value(value: commentsBloc ?? MockCommentsBloc()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            navigatorObservers:
                navigatorObserver != null ? [navigatorObserver] : [],
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
