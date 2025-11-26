import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/folder.dart';
import 'icon_model.dart';

part 'folder_model.freezed.dart';
part 'folder_model.g.dart';

@freezed
class FolderModel with _$FolderModel {
  const FolderModel._();

  const factory FolderModel({
    required String id,
    required String userId,
    required String name,
    IconModel? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FolderModel;

  factory FolderModel.fromJson(Map<String, dynamic> json) =>
      _$FolderModelFromJson(json);

  // Entity'ye dönüştürme
  FolderEntity toEntity() {
    return FolderEntity(
      id: id,
      userId: userId,
      name: name,
      icon: icon?.toEntity(),
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Entity'den oluşturma
  factory FolderModel.fromEntity(FolderEntity entity) {
    return FolderModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      icon: entity.icon != null ? IconModel.fromEntity(entity.icon!) : null,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
