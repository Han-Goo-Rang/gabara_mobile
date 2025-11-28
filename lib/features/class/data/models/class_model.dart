import '../../domain/entities/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    required super.description,
    required super.subjectName,
    required super.tutorName,
    super.classCode,
    required super.maxStudents,
    required super.isActive,
    super.subjectId,
    super.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Tanpa Nama',
      description: json['description'] ?? '',
      subjectName: (json['subjects'] != null)
          ? json['subjects']['name'] ?? 'Umum'
          : 'Umum',
      subjectId: json['subject_id'],
      tutorName: (json['tutor'] != null)
          ? json['tutor']['full_name'] ?? 'Mentor'
          : 'Mentor',
      classCode: json['class_code'],
      maxStudents: json['max_students'] ?? 30,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'class_code': classCode,
      'max_students': maxStudents,
      'is_active': isActive,
      'subject_id': subjectId,
    };
  }
}
