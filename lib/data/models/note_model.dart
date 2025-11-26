import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/note.dart';
import 'icon_model.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
class NoteModel with _$NoteModel {
  const NoteModel._();

  const factory NoteModel({
    required String id,
    required String userId,
    String? folderId,
    IconModel? icon,
    required String title,
    required String contentText,
    required Map<String, dynamic> contentJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  // Entity'ye dönüştürme
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      userId: userId,
      folderId: folderId,
      icon: icon?.toEntity(),
      title: title,
      contentText: contentText,
      contentJson: contentJson,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Entity'den oluşturma
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      userId: entity.userId,
      folderId: entity.folderId,
      icon: entity.icon != null ? IconModel.fromEntity(entity.icon!) : null,
      title: entity.title,
      contentText: entity.contentText,
      contentJson: entity.contentJson,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
