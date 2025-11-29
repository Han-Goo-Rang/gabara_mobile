// lib/features/quiz/domain/entities/quiz_entity.dart
import 'package:flutter/foundation.dart';

/// Entity untuk opsi jawaban pada soal
class OptionEntity {
  final String id;
  final String? questionId;
  final String text;
  final bool isCorrect;
  final int orderIndex;

  OptionEntity({
    required this.id,
    this.questionId,
    required this.text,
    this.isCorrect = false,
    this.orderIndex = 0,
  });

  OptionEntity copyWith({
    String? id,
    String? questionId,
    String? text,
    bool? isCorrect,
    int? orderIndex,
  }) {
    return OptionEntity(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// Entity untuk pertanyaan/soal dalam quiz
class QuestionEntity {
  final String id;
  final String? quizId;
  final String question;
  final String questionType; // 'multiple_choice' | 'true_false'
  final List<OptionEntity> options;
  final int orderIndex;

  QuestionEntity({
    required this.id,
    this.quizId,
    required this.question,
    this.questionType = 'multiple_choice',
    required this.options,
    this.orderIndex = 0,
  });

  /// Check if question is multiple choice type
  bool get isMultipleChoice => questionType == 'multiple_choice';

  /// Check if question is true/false type
  bool get isTrueFalse => questionType == 'true_false';

  QuestionEntity copyWith({
    String? id,
    String? quizId,
    String? question,
    String? questionType,
    List<OptionEntity>? options,
    int? orderIndex,
  }) {
    return QuestionEntity(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      options: options ?? this.options,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

/// Entity untuk quiz/kuis
class QuizEntity {
  final String id;
  final String? classId;
  final String title;
  final String description;
  final List<QuestionEntity> questions;
  final DateTime? openAt;
  final DateTime? closeAt;
  final int attemptsAllowed;
  final int durationMinutes;
  final String status; // 'draft' | 'published'
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuizEntity({
    required this.id,
    this.classId,
    required this.title,
    required this.description,
    required this.questions,
    this.openAt,
    this.closeAt,
    this.attemptsAllowed = 1,
    this.durationMinutes = 0,
    this.status = 'draft',
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  /// Get total number of questions
  int get questionCount => questions.length;

  /// Check if quiz is published
  bool get isPublished => status == 'published';

  /// Check if quiz is draft
  bool get isDraft => status == 'draft';

  /// Check if quiz is currently open for attempts
  /// DateTime dari Supabase sudah dalam local time setelah parsing ISO8601
  bool get isOpen {
    final now = DateTime.now();

    // openAt dan closeAt sudah dalam local time, jangan panggil toLocal() lagi
    final isAfterOpen =
        openAt == null || now.isAfter(openAt!) || now.isAtSameMomentAs(openAt!);
    final isBeforeClose = closeAt == null || now.isBefore(closeAt!);

    // Debug logging
    if (!isPublished || !isAfterOpen || !isBeforeClose) {
      debugPrint(
        'Quiz "$title" - isOpen: published=$isPublished, afterOpen=$isAfterOpen (now=$now, openAt=$openAt), beforeClose=$isBeforeClose (closeAt=$closeAt)',
      );
    }

    return isPublished && isAfterOpen && isBeforeClose;
  }

  /// Check if quiz has not started yet
  bool get isNotStarted {
    if (openAt == null) return false;
    // openAt sudah dalam local time, jangan panggil toLocal() lagi
    return DateTime.now().isBefore(openAt!);
  }

  /// Check if quiz has ended
  bool get isEnded {
    if (closeAt == null) return false;
    // closeAt sudah dalam local time, jangan panggil toLocal() lagi
    return DateTime.now().isAfter(closeAt!);
  }

  QuizEntity copyWith({
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
    return QuizEntity(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
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
