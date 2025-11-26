import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/icon.dart';

part 'icon_model.freezed.dart';
part 'icon_model.g.dart';

@freezed
class IconModel with _$IconModel {
  const IconModel._();

  const factory IconModel({
    required String id,
    required String name,
    required String fileUrl,
  }) = _IconModel;

  factory IconModel.fromJson(Map<String, dynamic> json) =>
      _$IconModelFromJson(json);

  // Entity'ye dönüştürme
  IconEntity toEntity() {
    return IconEntity(id: id, name: name, fileUrl: fileUrl);
  }

  // Entity'den oluşturma
  factory IconModel.fromEntity(IconEntity entity) {
    return IconModel(id: entity.id, name: entity.name, fileUrl: entity.fileUrl);
  }
}
