import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';
import 'package:tcb_challenge/l10n/l10n.dart';

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
      child: const CommentsView(),
    );
  }
}

class CommentsView extends StatelessWidget {
  const CommentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.commentsAppBarTitle),
      ),
      body: const CommentsList(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      builder: (context, state) {
        return InfiniteScrollView(
          onScrollDownEdge: () {
            if (state is! CommentsFailure) {
              context.read<CommentsBloc>().add(CommentsFetch());
            }
          },
          children: [
            if (state.comments.isEmpty && state is CommentsSuccessMaxReached)
              _NoCommentsText(),
            ...List.generate(
              state.comments.length,
              (index) => CommentListTile(
                name: state.comments.elementAt(index).name,
                body: state.comments.elementAt(index).body,
                email: state.comments.elementAt(index).email,
              ),
            ),
            if (state is CommentsSuccess) _ScrollToFetch(),
            if (state is CommentsFailure) const _CommentsRetryButton(),
            if (state is CommentsLoading) _BottomLoader()
          ],
        );
      },
    );
  }
}

class _BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            key: Key('commentsPage_bottomLoader_CircularIndicator'),
          ),
        ),
      ),
    );
  }
}

class _NoCommentsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        l10n.noCommentsInAlbumsText,
        key: const Key('commentsPage_noCommentsText'),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ScrollToFetch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
      child: Column(
        key: const Key('commentsPage_scrollToFetch'),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(l10n.scrollDownToFetchCommentsText),
          const Icon(Icons.arrow_downward),
        ],
      ),
    );
  }
}

class _CommentsRetryButton extends StatelessWidget {
  const _CommentsRetryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      key: const Key('commentsPage_retry_elevatedButton'),
      onPressed: () => context.read<CommentsBloc>().add(CommentsFetch()),
      child: Text(l10n.tapToRetryText),
    );
  }
}
