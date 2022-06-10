// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:comments_repository/comments_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/comments.dart';

import '../../helpers/helpers.dart';

class MockCommentsBloc extends MockBloc<CommentsEvent, CommentsState>
    implements CommentsBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

final comment1 =
    Comment(id: 1, postId: 1, name: 'name1', email: 'email1', body: 'body1');
final comment2 =
    Comment(id: 2, postId: 2, name: 'name2', email: 'email2', body: 'body2');

void main() {
  late CommentsBloc commentsBloc;
  late AppBloc appBloc;
  late SplayTreeSet<Comment> comments;
  late SplayTreeSet<Comment> emptyComments;

  final bottomLoaderKey = Key('commentsPage_bottomLoader_CircularIndicator');
  final noCommentsTextKey = Key('commentsPage_noCommentsText');
  final scrollToFetchKey = Key('commentsPage_scrollToFetch');
  final retryButtonKey = Key('commentsPage_retry_elevatedButton');

  setUpAll(() {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
  });

  setUp(() {
    commentsBloc = MockCommentsBloc();
    appBloc = MockAppBloc();
    emptyComments = SplayTreeSet<Comment>(
      (a, b) => a.id.compareTo(b.id),
    );
    comments = SplayTreeSet<Comment>(
      (a, b) => a.id.compareTo(b.id),
    )..addAll([comment1, comment2]);

    when(() => appBloc.state)
        .thenReturn(AppState(currentPage: AppPages.comments));
  });

  group('CommentsPage', () {
    testWidgets('renders CommentsView', (tester) async {
      await tester.pumpApp(CommentsPage());

      await tester.pump();

      expect(find.byType(CommentsView), findsOneWidget);
    });

    testWidgets(
        'contains WillPopScope which prevents default pops '
        'and adds AppPageSelected with photos destination', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: appBloc,
          child: Navigator(
            pages: [CommentsPage.page()],
            onPopPage: (route, dynamic result) {
              return route.didPop(result);
            },
          ),
        ),
      );
      final willPopScope =
          tester.widget<WillPopScope>(find.byType(WillPopScope));
      expect(await willPopScope.onWillPop!(), isFalse);

      verify(
        () => appBloc.add(AppPageSelected(destinationPage: AppPages.photos)),
      ).called(1);
    });
  });

  group('CommentsView', () {
    group('renders', () {
      testWidgets('CommentsList', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsInitial(comments: emptyComments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byType(CommentsList), findsOneWidget);
      });

      testWidgets('BottomNavBar', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsInitial(comments: emptyComments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byType(BottomNavBar), findsOneWidget);
      });

      testWidgets('CommentListTile when comments splaytree contains comments',
          (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsInitial(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byType(CommentListTile), findsNWidgets(comments.length));
      });

      testWidgets(
          'NoCommentsText when comments splaytree is empty '
          'and state is CommentsSuccessMaxReached', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccessMaxReached(comments: emptyComments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(noCommentsTextKey), findsOneWidget);
      });

      testWidgets('ScrollToFetch when state is CommentsSuccess',
          (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccess(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(scrollToFetchKey), findsOneWidget);
      });

      testWidgets('RetryButton when state is CommentsFailure', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsFailure(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(retryButtonKey), findsOneWidget);
      });

      testWidgets('BottomLoader when state is CommentsLoading', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsLoading(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(bottomLoaderKey), findsOneWidget);
      });
    });

    group('does not render', () {
      testWidgets('CommentListTile when comments splaytree is empty',
          (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsInitial(comments: emptyComments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byType(CommentListTile), findsNothing);
      });

      testWidgets(
          'NoCommentsText when comments splaytree is not empty '
          'and state is CommentsSuccess', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccess(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(noCommentsTextKey), findsNothing);
      });

      testWidgets('ScrollToFetch when state is CommentsSuccessMaxReached ',
          (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccessMaxReached(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(scrollToFetchKey), findsNothing);
      });

      testWidgets('BottomLoader when state is CommentsSuccess', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccess(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        expect(find.byKey(bottomLoaderKey), findsNothing);
      });
    });

    group('adds', () {
      testWidgets('CommentsFetch when retry button is tapped', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsFailure(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        await tester.tap(find.byKey(retryButtonKey));

        verify(() => commentsBloc.add(CommentsFetch())).called(1);
      });

      testWidgets(
          'CommentsFetch when ListView is scrolled down '
          'and state is CommentsSuccess', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccess(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        await tester.drag(
          find.byType(CommentsList),
          const Offset(0, -300),
        );

        verify(() => commentsBloc.add(CommentsFetch())).called(1);
      });

      testWidgets(
          'nothing when ListView is scrolled up '
          'and state is CommentsSuccess', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsSuccess(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        await tester.drag(
          find.byType(CommentsList),
          const Offset(0, 300),
        );

        verifyNever(() => commentsBloc.add(CommentsFetch()));
      });

      testWidgets(
          'nothing when ListView is scrolled down '
          'and state is CommentsFailure', (tester) async {
        when(() => commentsBloc.state)
            .thenReturn(CommentsFailure(comments: comments));

        await tester.pumpApp(CommentsView(), commentsBloc: commentsBloc);

        await tester.drag(
          find.byType(CommentsList),
          const Offset(0, -300),
        );

        verifyNever(() => commentsBloc.add(CommentsFetch()));
      });
    });
  });
}
