import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/app/app.dart';
import 'package:tcb_challenge/l10n/l10n.dart';
import 'package:tcb_challenge/photos/photos.dart';

class PhotosPage extends StatelessWidget {
  const PhotosPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: PhotosPage());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const PhotosView(),
    );
  }
}

class PhotosView extends StatelessWidget {
  const PhotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.photosAppBarTitle),
      ),
      body: const PhotosList(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotosBloc>().state;

    return InfiniteScrollView(
      onScrollDownEdge: () {
        if (!state.status.isFailure) {
          context.read<PhotosBloc>().add(PhotosFetch());
        }
      },
      children: [
        if (state.photos.isEmpty && state.status.isSuccess) _NoPhotosText(),
        ...List.generate(
          state.photos.length,
          (index) => PhotoListTile(
            title: state.photos[index].title,
            thumbnailUrl: state.photos[index].thumbnailUrl,
            onTap: () => Navigator.of(context).push<void>(
              PhotoPage.route(state.photos[index].id),
            ),
          ),
        ),
        if (state.status.isSuccess && !state.maxPhotosReached) _ScrollToFetch(),
        if (state.status.isFailure) const _PhotosRetryButton(),
        if (!state.maxPhotosReached && state.status.isLoading) _BottomLoader()
      ],
    );
  }
}

class _NoPhotosText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        l10n.noPhotosInAlbumsText,
        key: const Key('photosPage_noPhotosText'),
        textAlign: TextAlign.center,
      ),
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
            key: Key('photosPage_bottomLoader_CircularIndicator'),
          ),
        ),
      ),
    );
  }
}

class _ScrollToFetch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      key: const Key('photosPage_scrollToFetch'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.scrollDownToFetchPhotosText),
        const Icon(Icons.arrow_downward),
      ],
    );
  }
}

class _PhotosRetryButton extends StatelessWidget {
  const _PhotosRetryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      key: const Key('photosPage_retry_elevatedButton'),
      onPressed: () => context.read<PhotosBloc>().add(PhotosFetch()),
      child: Text(l10n.tapToRetryText),
    );
  }
}
