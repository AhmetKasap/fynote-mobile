import 'package:equatable/equatable.dart';
import 'icon.dart';

class FolderEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final IconEntity? icon;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FolderEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.icon,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    icon,
    color,
    createdAt,
    updatedAt,
  ];

  FolderEntity copyWith({
    String? id,
    String? userId,
    String? name,
    IconEntity? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
