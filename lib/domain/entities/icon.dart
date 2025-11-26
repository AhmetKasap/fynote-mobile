import 'package:equatable/equatable.dart';

class IconEntity extends Equatable {
  final String id;
  final String name;
  final String fileUrl;

  const IconEntity({
    required this.id,
    required this.name,
    required this.fileUrl,
  });

  @override
  List<Object?> get props => [id, name, fileUrl];

  IconEntity copyWith({String? id, String? name, String? fileUrl}) {
    return IconEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
