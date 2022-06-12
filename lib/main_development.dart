// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:comments_repository/comments_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/bootstrap.dart';

void main() {
  bootstrap(() async {
    final photosRepository = PhotosRepository();
    final commentsRepository = CommentsRepository();
    final connectivityRepository = ConnectivityRepository();
    return App(
      photosRepository: photosRepository,
      commentsRepository: commentsRepository,
      connectivityRepository: connectivityRepository,
    );
  });
}
