import 'package:equatable/equatable.dart';

/// Program aktivitesi entity
class ProgramActivity extends Equatable {
  final String time;
  final String activity;
  final String duration;
  final String priority;
  final String category;
  final String? notes;

  const ProgramActivity({
    required this.time,
    required this.activity,
    required this.duration,
    required this.priority,
    required this.category,
    this.notes,
  });

  @override
  List<Object?> get props => [
    time,
    activity,
    duration,
    priority,
    category,
    notes,
  ];
}

/// Program içerik JSON entity
class ProgramContentJson extends Equatable {
  final List<ProgramActivity> dailyRoutine;
  final String? summary;
  final int? totalActivities;
  final String? estimatedDuration;
  final List<String> tags;

  const ProgramContentJson({
    required this.dailyRoutine,
    this.summary,
    this.totalActivities,
    this.estimatedDuration,
    required this.tags,
  });

  @override
  List<Object?> get props => [
    dailyRoutine,
    summary,
    totalActivities,
    estimatedDuration,
    tags,
  ];
}

/// Program entity
class Program extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String status; // processing, completed, failed
  final ProgramContentJson? contentJson;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Program({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.status,
    this.contentJson,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isProcessing => status == 'processing';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    content,
    status,
    contentJson,
    errorMessage,
    createdAt,
    updatedAt,
  ];
}

/// Program oluşturma response entity
class CreateProgramResponse extends Equatable {
  final String id;
  final String message;
  final String status;

  const CreateProgramResponse({
    required this.id,
    required this.message,
    required this.status,
  });

  @override
  List<Object?> get props => [id, message, status];
}
