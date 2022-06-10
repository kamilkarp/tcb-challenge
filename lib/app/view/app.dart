// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_ui/app_ui.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:tcb_challenge/l10n/l10n.dart';
import 'package:tcb_challenge/photos/photos.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required PhotosRepository photosRepository,
    required CommentsRepository commentsRepository,
  })  : _photosRepository = photosRepository,
        _commentsRepository = commentsRepository,
        super(key: key);

  final PhotosRepository _photosRepository;
  final CommentsRepository _commentsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PhotosRepository>.value(value: _photosRepository),
        RepositoryProvider<CommentsRepository>.value(
          value: _commentsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppBloc()),
          BlocProvider(
            lazy: false,
            create: (_) => CommentsBloc(commentsRepository: _commentsRepository)
              ..add(CommentsFetch()),
          ),
          BlocProvider(
            create: (_) => PhotosBloc(photosRepository: _photosRepository)
              ..add(PhotosFetch()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: const AppTheme().themeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: FlowBuilder(
        state: context.select((AppBloc bloc) => bloc.state.currentPage),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
