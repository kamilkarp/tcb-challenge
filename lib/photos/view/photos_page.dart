import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/photos/photos.dart';

class PhotosPage extends StatelessWidget {
  const PhotosPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: PhotosPage());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(),
    );
  }
}

