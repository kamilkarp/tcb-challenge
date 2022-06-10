import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// {@template infinite_scroll_view}
/// Creates scrollable vertical list and notifies
/// when users scrolls down to the edge
/// 
/// {@endtemplate}
class InfiniteScrollView extends StatefulWidget {
  /// {@macro infinite_scroll_view}
  const InfiniteScrollView({
    Key? key,
    required this.children,
    this.onScrollDownEdge,
  }) : super(key: key);

  /// Function triggered when users scrolls down to the edge
  final void Function()? onScrollDownEdge;

  /// List of widgets shown in view
  final List<Widget> children;

  @override
  State<InfiniteScrollView> createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  bool isScrollDirectionReverseOrIdle = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.reverse ||
              scrollNotification.direction == ScrollDirection.idle) {
            setState(() {
              isScrollDirectionReverseOrIdle = true;
            });
          } else {
            setState(() {
              isScrollDirectionReverseOrIdle = false;
            });
          }
        }
        if (scrollNotification is ScrollEndNotification) {
          if (scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent &&
              isScrollDirectionReverseOrIdle) {
            widget.onScrollDownEdge?.call();
          }
        }
        return true;
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: widget.children,
      ),
    );
  }
}
