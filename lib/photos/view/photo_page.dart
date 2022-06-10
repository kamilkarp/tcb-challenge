import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/photos/bloc/photos_bloc.dart';
import 'package:tcb_challenge/photos/widgets/photo_image.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key, required this.photoId}) : super(key: key);

  static Route route(int photoId) => MaterialPageRoute<PhotoPage>(
        builder: (_) => PhotoPage(
          photoId: photoId,
        ),
      );

  final int photoId;

  @override
  Widget build(BuildContext context) {
    return PhotoView(photoId: photoId);
  }
}

class PhotoView extends StatelessWidget {
  const PhotoView({Key? key, required this.photoId}) : super(key: key);

  final int photoId;

  @override
  Widget build(BuildContext context) {
    final photos = context.select((PhotosBloc bloc) => bloc.state.photos);
    final photo = photos.firstWhere((element) => element.id == photoId);

    return Scaffold(
      appBar: AppBar(title: const Text('Photo')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Text(photo.title, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          PhotoImage(
            url: photo.url,
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
