import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/app/bloc/app_bloc.dart';
import 'package:tcb_challenge/l10n/l10n.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPage =
        context.select((AppBloc bloc) => bloc.state.currentPage);

    return BottomNavigationBar(
      items: _navbarItems(context.l10n),
      currentIndex: currentPage.index,
      iconSize: 30,
      onTap: (selectedIndex) {
        if (selectedIndex == currentPage.index) return;

        context.read<AppBloc>().add(
              AppPageSelected(
                destinationPage: AppPages.values[selectedIndex],
              ),
            );
      },
    );
  }

  List<BottomNavigationBarItem> _navbarItems(AppLocalizations l10n) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.photo_library_outlined),
        label: l10n.photosBottomNavbarTitle,
        activeIcon: const Icon(Icons.photo_library_rounded),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.comment_outlined),
        label: l10n.commentsBottomNavbarTitle,
        activeIcon: const Icon(Icons.comment_rounded),
      ),
    ];
  }
}
