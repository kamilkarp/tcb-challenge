import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: CommentsPage());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          context
              .read<AppBloc>()
              .add(AppPageSelected(destinationPage: AppPages.photos));
          return false;
        },
        child: const Scaffold());
  }
}

