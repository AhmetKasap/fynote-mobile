import 'package:equatable/equatable.dart';
import 'icon.dart';

class NoteEntity extends Equatable {
  final String id;
  final String userId;
  final String? folderId;
  final IconEntity? icon;
  final String title;
  final String contentText;
  final Map<String, dynamic> contentJson;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NoteEntity({
    required this.id,
    required this.userId,
    this.folderId,
    this.icon,
    required this.title,
    required this.contentText,
    required this.contentJson,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    folderId,
    icon,
    title,
    contentText,
    contentJson,
    createdAt,
    updatedAt,
  ];

  NoteEntity copyWith({
    String? id,
    String? userId,
    String? folderId,
    IconEntity? icon,
    String? title,
    String? contentText,
    Map<String, dynamic>? contentJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      folderId: folderId ?? this.folderId,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      contentText: contentText ?? this.contentText,
      contentJson: contentJson ?? this.contentJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
