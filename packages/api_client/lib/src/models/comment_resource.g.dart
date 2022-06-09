// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, cast_nullable_to_non_nullable

part of 'comment_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResource _$CommentResourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CommentResource',
      json,
      ($checkedConvert) {
        final val = CommentResource(
          id: $checkedConvert('id', (v) => v as int),
          postId: $checkedConvert('postId', (v) => v as int),
          name: $checkedConvert('name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          body: $checkedConvert('body', (v) => v as String),
        );
        return val;
      },
    );
