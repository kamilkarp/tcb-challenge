import 'package:flutter/material.dart';
import 'package:tcb_challenge/photos/widgets/photo_image.dart';

class PhotoListTile extends StatelessWidget {
  const PhotoListTile({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String thumbnailUrl;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      leading: PhotoImage(
        url: thumbnailUrl,
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
      trailing: const Icon(Icons.arrow_right_rounded),
    );
  }
}
