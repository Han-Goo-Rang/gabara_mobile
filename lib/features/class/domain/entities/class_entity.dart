import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String subjectName;
  final int? subjectId;
  final String tutorName;
  final String? classCode;
  final int maxStudents;
  final bool isActive;
  final DateTime? createdAt;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.subjectName,
    this.subjectId,
    required this.tutorName,
    this.classCode,
    required this.maxStudents,
    required this.isActive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    subjectName,
    subjectId,
    tutorName,
    classCode,
    maxStudents,
    isActive,
    createdAt,
  ];
}
