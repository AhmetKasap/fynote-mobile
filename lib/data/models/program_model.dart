import '../../domain/entities/program.dart';

/// Program aktivitesi model
class ProgramActivityModel extends ProgramActivity {
  const ProgramActivityModel({
    required super.time,
    required super.activity,
    required super.duration,
    required super.priority,
    required super.category,
    super.notes,
  });

  factory ProgramActivityModel.fromJson(Map<String, dynamic> json) {
    return ProgramActivityModel(
      time: json['time'] ?? '',
      activity: json['activity'] ?? '',
      duration: json['duration'] ?? '',
      priority: json['priority'] ?? 'medium',
      category: json['category'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'activity': activity,
      'duration': duration,
      'priority': priority,
      'category': category,
      if (notes != null) 'notes': notes,
    };
  }
}

/// Program içerik JSON model
class ProgramContentJsonModel extends ProgramContentJson {
  const ProgramContentJsonModel({
    required super.dailyRoutine,
    super.summary,
    super.totalActivities,
    super.estimatedDuration,
    required super.tags,
  });

  factory ProgramContentJsonModel.fromJson(Map<String, dynamic> json) {
    return ProgramContentJsonModel(
      dailyRoutine:
          (json['daily_routine'] as List?)
              ?.map((e) => ProgramActivityModel.fromJson(e))
              .toList() ??
          [],
      summary: json['summary'],
      totalActivities: json['total_activities'],
      estimatedDuration: json['estimated_duration'],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_routine': dailyRoutine
          .map((e) => (e as ProgramActivityModel).toJson())
          .toList(),
      if (summary != null) 'summary': summary,
      if (totalActivities != null) 'total_activities': totalActivities,
      if (estimatedDuration != null) 'estimated_duration': estimatedDuration,
      'tags': tags,
    };
  }
}

/// Program model
class ProgramModel extends Program {
  const ProgramModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.status,
    super.contentJson,
    super.errorMessage,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'Program Hazırlanıyor...',
      content: json['content'] ?? '',
      status: json['status'] ?? 'processing',
      contentJson: json['content_json'] != null
          ? ProgramContentJsonModel.fromJson(json['content_json'])
          : null,
      errorMessage: json['error_message'] ?? json['errorMessage'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'status': status,
      if (contentJson != null)
        'content_json': (contentJson as ProgramContentJsonModel).toJson(),
      if (errorMessage != null) 'error_message': errorMessage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Program oluşturma response model
class CreateProgramResponseModel extends CreateProgramResponse {
  const CreateProgramResponseModel({
    required super.id,
    required super.message,
    required super.status,
  });

  factory CreateProgramResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateProgramResponseModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'processing',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'message': message, 'status': status};
  }
}
