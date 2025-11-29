// lib/features/quiz/data/models/quiz_attempt_model.dart
// Requirements: 8.1, 8.2

import 'package:flutter/foundation.dart';
import '../../domain/entities/quiz_attempt_entity.dart';

/// Helper function untuk parse DateTime dari Supabase dan konversi ke local time
DateTime? _parseDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;
  try {
    final parsed = DateTime.tryParse(dateString);
    if (parsed == null) return null;
    // Jika DateTime dalam UTC, konversi ke local time
    return parsed.isUtc ? parsed.toLocal() : parsed;
  } catch (e) {
    debugPrint('Error parsing DateTime: $dateString - $e');
    return null;
  }
}

/// Helper function untuk format DateTime ke UTC ISO8601 string untuk Supabase
String? _formatDateTimeForSupabase(DateTime? dateTime) {
  if (dateTime == null) return null;
  return dateTime.toUtc().toIso8601String();
}

/// Model untuk jawaban student dengan serialization
class StudentAnswerModel extends StudentAnswerEntity {
  StudentAnswerModel({
    required super.id,
    required super.attemptId,
    required super.questionId,
    super.selectedOptionId,
    super.isCorrect,
    super.createdAt,
  });

  factory StudentAnswerModel.fromJson(Map<String, dynamic> json) {
    return StudentAnswerModel(
      id: json['id']?.toString() ?? '',
      attemptId: json['attempt_id']?.toString() ?? '',
      questionId: json['question_id']?.toString() ?? '',
      // Support both 'option_id' (v2 schema) and 'selected_option_id' (migration)
      selectedOptionId:
          json['option_id']?.toString() ??
          json['selected_option_id']?.toString(),
      isCorrect: json['is_correct'] as bool?,
      createdAt: _parseDateTime(json['created_at']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'attempt_id': attemptId,
    'question_id': questionId,
    'option_id': selectedOptionId,
    'is_correct': isCorrect,
    'created_at': _formatDateTimeForSupabase(createdAt),
  };

  /// Convert to JSON for creating new answer (without id)
  Map<String, dynamic> toCreateJson() => {
    'attempt_id': attemptId,
    'question_id': questionId,
    'option_id': selectedOptionId,
    'is_correct': isCorrect,
  };

  /// Create from entity
  factory StudentAnswerModel.fromEntity(StudentAnswerEntity entity) {
    return StudentAnswerModel(
      id: entity.id,
      attemptId: entity.attemptId,
      questionId: entity.questionId,
      selectedOptionId: entity.selectedOptionId,
      isCorrect: entity.isCorrect,
      createdAt: entity.createdAt,
    );
  }

  @override
  StudentAnswerModel copyWith({
    String? id,
    String? attemptId,
    String? questionId,
    String? selectedOptionId,
    bool? isCorrect,
    DateTime? createdAt,
  }) {
    return StudentAnswerModel(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Model untuk quiz attempt dengan serialization
class QuizAttemptModel extends QuizAttemptEntity {
  QuizAttemptModel({
    required super.id,
    required super.quizId,
    required super.studentId,
    required super.startedAt,
    super.finishedAt,
    super.status = 'in_progress',
    super.score,
    List<StudentAnswerModel> answers = const [],
    super.createdAt,
    super.updatedAt,
  }) : super(answers: answers);

  /// Get answers as StudentAnswerModel list
  List<StudentAnswerModel> get answerModels => answers
      .map(
        (a) => a is StudentAnswerModel ? a : StudentAnswerModel.fromEntity(a),
      )
      .toList();

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    // Support both 'quiz_answers' (v2 schema) and 'student_answers' (migration)
    final answersData = json['quiz_answers'] ?? json['student_answers'];
    final answersList = (answersData as List<dynamic>? ?? [])
        .map((a) => StudentAnswerModel.fromJson(a as Map<String, dynamic>))
        .toList();

    // Parse score - handle both int and decimal
    int? scoreValue;
    if (json['percentage'] != null) {
      scoreValue = (json['percentage'] as num).round();
    } else if (json['score'] != null) {
      scoreValue = (json['score'] as num).round();
    }

    // Parse startedAt dengan konversi ke local time
    DateTime startedAtValue;
    if (json['started_at'] != null) {
      final parsed = _parseDateTime(json['started_at']?.toString());
      startedAtValue = parsed ?? DateTime.now();
    } else {
      startedAtValue = DateTime.now();
    }

    return QuizAttemptModel(
      id: json['id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? '',
      studentId:
          json['user_id']?.toString() ?? json['student_id']?.toString() ?? '',
      startedAt: startedAtValue,
      // Support both 'submitted_at' (v2) and 'finished_at' (migration)
      finishedAt:
          _parseDateTime(json['submitted_at']?.toString()) ??
          _parseDateTime(json['finished_at']?.toString()),
      // Map 'submitted' to 'finished' for consistency
      status: json['status'] == 'submitted'
          ? 'finished'
          : (json['status'] ?? 'in_progress'),
      score: scoreValue,
      answers: answersList,
      createdAt: _parseDateTime(json['created_at']?.toString()),
      updatedAt: _parseDateTime(json['updated_at']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'quiz_id': quizId,
    'user_id': studentId,
    'started_at': _formatDateTimeForSupabase(startedAt),
    'submitted_at': _formatDateTimeForSupabase(finishedAt),
    'status': status == 'finished' ? 'submitted' : status,
    'percentage': score,
    'quiz_answers': answerModels.map((a) => a.toJson()).toList(),
  };

  /// Convert to JSON for creating new attempt (without id and answers)
  Map<String, dynamic> toCreateJson() => {
    'quiz_id': quizId,
    'user_id': studentId,
    'started_at': _formatDateTimeForSupabase(startedAt),
    'status': status,
  };

  /// Convert to JSON for updating attempt
  Map<String, dynamic> toUpdateJson() => {
    'finished_at': _formatDateTimeForSupabase(finishedAt),
    'status': status,
    'score': score,
  };

  /// Create from entity
  factory QuizAttemptModel.fromEntity(QuizAttemptEntity entity) {
    return QuizAttemptModel(
      id: entity.id,
      quizId: entity.quizId,
      studentId: entity.studentId,
      startedAt: entity.startedAt,
      finishedAt: entity.finishedAt,
      status: entity.status,
      score: entity.score,
      answers: entity.answers
          .map((a) => StudentAnswerModel.fromEntity(a))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  QuizAttemptModel copyWith({
    String? id,
    String? quizId,
    String? studentId,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? status,
    int? score,
    List<StudentAnswerEntity>? answers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizAttemptModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      studentId: studentId ?? this.studentId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      score: score ?? this.score,
      answers:
          answers
              ?.map(
                (a) => a is StudentAnswerModel
                    ? a
                    : StudentAnswerModel.fromEntity(a),
              )
              .toList() ??
          answerModels,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
