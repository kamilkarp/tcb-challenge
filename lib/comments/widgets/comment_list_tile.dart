import 'package:flutter/material.dart';

class CommentListTile extends StatelessWidget {
  const CommentListTile({
    Key? key,
    required this.name,
    required this.email,
    required this.body,
  }) : super(key: key);

  final String name;
  final String email;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('($email)'),
          Text(
            body,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
