import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tcb_challenge/l10n/l10n.dart';

class PhotoImage extends StatefulWidget {
  const PhotoImage({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.fit,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Alignment alignment;

  @override
  State<PhotoImage> createState() => _PhotoImageState();
}

class _PhotoImageState extends State<PhotoImage> {
  bool isPhotoLoaded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CachedNetworkImage(
      /// Workaround to provide reloading functionality
      /// https://github.com/Baseflow/flutter_cached_network_image/issues/468#issuecomment-789757758
      key: ValueKey<String>(
        isPhotoLoaded
            ? '${widget.url}/loaded'
            : '${widget.url}/${DateTime.now().toString()}/failed',
      ),
      imageUrl: widget.url,
      alignment: widget.alignment,
      fit: widget.fit,
      height: widget.height,
      width: widget.width,
      errorWidget: (_, __, dynamic ___) {
        return Container(
          height: widget.height,
          width: widget.width,
          alignment: widget.alignment,
          color: Colors.grey[300],
          child: IconButton(
            onPressed: () => setState(() {
              isPhotoLoaded = false;
            }),
            icon: const Icon(Icons.download, size: 20),
            tooltip: l10n.downloadAgainPhotoImageTooltip,
          ),
        );
      },
      progressIndicatorBuilder: (_, __, progress) {
        isPhotoLoaded = progress.downloaded == progress.totalSize;

        return const Center(
          child: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
