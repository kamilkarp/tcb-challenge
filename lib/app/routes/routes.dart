import 'package:flutter/widgets.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/comments/view/comments_page.dart';
import 'package:tcb_challenge/photos/photos.dart';

List<Page> onGenerateAppViewPages(AppPages state, List<Page> pages) {
  switch (state) {
    case AppPages.photos:
      return [PhotosPage.page()];
    case AppPages.comments:
      return [CommentsPage.page()];
  }
}
