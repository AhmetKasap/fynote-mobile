// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FolderModelImpl _$$FolderModelImplFromJson(Map<String, dynamic> json) =>
    _$FolderModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      icon: json['icon'] == null
          ? null
          : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
      color: json['color'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FolderModelImplToJson(_$FolderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
