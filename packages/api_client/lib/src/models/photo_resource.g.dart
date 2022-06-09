// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, cast_nullable_to_non_nullable

part of 'photo_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoResource _$PhotoResourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PhotoResource',
      json,
      ($checkedConvert) {
        final val = PhotoResource(
          id: $checkedConvert('id', (v) => v as int),
          albumId: $checkedConvert('albumId', (v) => v as int),
          title: $checkedConvert('title', (v) => v as String),
          url: $checkedConvert('url', (v) => v as String),
          thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String),
        );
        return val;
      },
    );
