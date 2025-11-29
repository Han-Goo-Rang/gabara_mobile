// lib/features/quiz/data/models/quiz_model.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/quiz_entity.dart';

/// Model untuk opsi jawaban dengan serialization
class OptionModel extends OptionEntity {
  OptionModel({
    required super.id,
    super.questionId,
    required super.text,
    super.isCorrect = false,
    super.orderIndex = 0,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
    id: json['id']?.toString() ?? '',
    questionId: json['question_id']?.toString(),
    text: json['option_text'] ?? json['text'] ?? '',
    isCorrect: json['is_correct'] == true,
    orderIndex: json['order_index'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'question_id': questionId,
    'option_text': text,
    'is_correct': isCorrect,
    'order_index': orderIndex,
  };

  /// Convert to JSON for creating new option (without id)
  Map<String, dynamic> toCreateJson() => {
    'question_id': questionId,
    'option_text': text,
    'is_correct': isCorrect,
    'order_index': orderIndex,
  };

  @override
  OptionModel copyWith({
    String? id,
    String? questionId,
    String? text,
    bool? isCorrect,
    int? orderIndex,
  }) {
    return OptionModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// Model untuk pertanyaan/soal dengan serialization
class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    super.quizId,
    required super.question,
    super.questionType = 'multiple_choice',
    required List<OptionModel> options,
    super.orderIndex = 0,
  }) : super(options: options);

  /// Get options as OptionModel list
  List<OptionModel> get optionModels => options
      .map(
        (o) => o is OptionModel
            ? o
            : OptionModel(
                id: o.id,
                questionId: o.questionId,
                text: o.text,
                isCorrect: o.isCorrect,
                orderIndex: o.orderIndex,
              ),
      )
      .toList();

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List<dynamic>? ?? [])
        .map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
        .toList();

    return QuestionModel(
      id: json['id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString(),
      question: json['question_text'] ?? json['question'] ?? '',
      questionType: json['question_type'] ?? 'multiple_choice',
      options: optionsList,
      orderIndex: json['order_index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'quiz_id': quizId,
    'question_text': question,
    'question_type': questionType,
    'order_index': orderIndex,
    'options': optionModels.map((o) => o.toJson()).toList(),
  };

  /// Convert to JSON for creating new question (without id)
  Map<String, dynamic> toCreateJson() => {
    'quiz_id': quizId,
    'question_text': question,
    'question_type': questionType,
    'order_index': orderIndex,
  };

  @override
  QuestionModel copyWith({
    String? id,
    String? quizId,
    String? question,
    String? questionType,
    List<OptionEntity>? options,
    int? orderIndex,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      options:
          options
              ?.map(
                (o) => o is OptionModel
                    ? o
                    : OptionModel(
                        id: o.id,
                        questionId: o.questionId,
                        text: o.text,
                        isCorrect: o.isCorrect,
                        orderIndex: o.orderIndex,
                      ),
              )
              .toList() ??
          optionModels,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// Model untuk quiz/kuis dengan serialization
class QuizModel extends QuizEntity {
  QuizModel({
    required super.id,
    super.classId,
    required super.title,
    required super.description,
    required List<QuestionModel> questions,
    super.openAt,
    super.closeAt,
    super.attemptsAllowed = 1,
    super.durationMinutes = 0,
    super.status = 'draft',
    super.createdBy,
    super.createdAt,
    super.updatedAt,
  }) : super(questions: questions);

  /// Get questions as QuestionModel list
  List<QuestionModel> get questionModels => questions
      .map(
        (q) => q is QuestionModel
            ? q
            : QuestionModel(
                id: q.id,
                quizId: q.quizId,
                question: q.question,
                questionType: q.questionType,
                options: q.options
                    .map(
                      (o) => OptionModel(
                        id: o.id,
                        questionId: o.questionId,
                        text: o.text,
                        isCorrect: o.isCorrect,
                        orderIndex: o.orderIndex,
                      ),
                    )
                    .toList(),
                orderIndex: q.orderIndex,
              ),
      )
      .toList();

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final questionsList = (json['questions'] as List<dynamic>? ?? [])
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();

    return QuizModel(
      id: json['id']?.toString() ?? '',
      classId: json['class_id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions: questionsList,
      openAt: json['open_at'] != null ? _parseDateTime(json['open_at']) : null,
      closeAt: json['close_at'] != null
          ? _parseDateTime(json['close_at'])
          : null,
      attemptsAllowed: json['max_attempts'] ?? json['attempts_allowed'] ?? 1,
      durationMinutes: json['duration_minutes'] ?? 0,
      status: json['is_active'] == true
          ? 'published'
          : (json['status'] ?? 'draft'),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'class_id': classId,
    'title': title,
    'description': description,
    'open_at': _formatDateTimeForSupabase(openAt),
    'close_at': _formatDateTimeForSupabase(closeAt),
    'max_attempts': attemptsAllowed,
    'duration_minutes': durationMinutes,
    'is_active': isPublished,
    'created_by': createdBy,
    'questions': questionModels.map((q) => q.toJson()).toList(),
  };

  /// Convert to JSON for creating new quiz (without id and questions)
  Map<String, dynamic> toCreateJson() => {
    'class_id': classId,
    'title': title,
    'description': description,
    'open_at': _formatDateTimeForSupabase(openAt),
    'close_at': _formatDateTimeForSupabase(closeAt),
    'max_attempts': attemptsAllowed,
    'duration_minutes': durationMinutes,
    'is_active': isPublished,
    'created_by': createdBy,
  };

  /// Convert to JSON for updating quiz metadata
  Map<String, dynamic> toUpdateJson() => {
    'class_id': classId,
    'title': title,
    'description': description,
    'open_at': _formatDateTimeForSupabase(openAt),
    'close_at': _formatDateTimeForSupabase(closeAt),
    'max_attempts': attemptsAllowed,
    'duration_minutes': durationMinutes,
    'is_active': isPublished,
  };

  @override
  QuizModel copyWith({
    String? id,
    String? classId,
    String? title,
    String? description,
    List<QuestionEntity>? questions,
    DateTime? openAt,
    DateTime? closeAt,
    int? attemptsAllowed,
    int? durationMinutes,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      description: description ?? this.description,
      questions:
          questions
              ?.map(
                (q) => q is QuestionModel
                    ? q
                    : QuestionModel(
                        id: q.id,
                        quizId: q.quizId,
                        question: q.question,
                        questionType: q.questionType,
                        options: q.options
                            .map(
                              (o) => OptionModel(
                                id: o.id,
                                questionId: o.questionId,
                                text: o.text,
                                isCorrect: o.isCorrect,
                                orderIndex: o.orderIndex,
                              ),
                            )
                            .toList(),
                        orderIndex: q.orderIndex,
                      ),
              )
              .toList() ??
          questionModels,
      openAt: openAt ?? this.openAt,
      closeAt: closeAt ?? this.closeAt,
      attemptsAllowed: attemptsAllowed ?? this.attemptsAllowed,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Helper function untuk parse DateTime dari Supabase
/// Supabase mengirim datetime dalam format ISO8601 dengan timezone
/// Contoh: "2025-11-29T10:15:00+00:00" atau "2025-11-29T10:15:00Z"
DateTime? _parseDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;

  try {
    final parsed = DateTime.tryParse(dateString);
    if (parsed == null) return null;

    // Debug: print waktu yang di-parse
    debugPrint(
      'Parsed DateTime: $dateString -> $parsed (isUtc: ${parsed.isUtc})',
    );

    // Jika DateTime dalam UTC, konversi ke local time
    if (parsed.isUtc) {
      final localTime = parsed.toLocal();
      debugPrint('Converted to local: $localTime');
      return localTime;
    }

    return parsed;
  } catch (e) {
    debugPrint('Error parsing DateTime: $dateString - $e');
    return null;
  }
}

/// Helper function untuk format DateTime ke ISO8601 string untuk Supabase
/// Konversi waktu lokal ke UTC sebelum mengirim ke Supabase
/// Ini memastikan waktu yang disimpan konsisten dengan timezone
String? _formatDateTimeForSupabase(DateTime? dateTime) {
  if (dateTime == null) return null;

  // Konversi ke UTC sebelum mengirim ke Supabase
  final utcTime = dateTime.toUtc();
  debugPrint(
    'Formatting DateTime for Supabase: $dateTime (local) -> $utcTime (UTC)',
  );
  return utcTime.toIso8601String();
}
