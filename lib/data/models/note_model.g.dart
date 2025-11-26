// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      folderId: json['folderId'] as String?,
      icon: json['icon'] == null
          ? null
          : IconModel.fromJson(json['icon'] as Map<String, dynamic>),
      title: json['title'] as String,
      contentText: json['contentText'] as String,
      contentJson: json['contentJson'] as Map<String, dynamic>,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NoteModelImplToJson(_$NoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'folderId': instance.folderId,
      'icon': instance.icon,
      'title': instance.title,
      'contentText': instance.contentText,
      'contentJson': instance.contentJson,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
