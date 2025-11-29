// lib/features/quiz/domain/entities/quiz_attempt_entity.dart
// Requirements: 8.1, 8.2

/// Entity untuk jawaban student pada satu soal
class StudentAnswerEntity {
  final String id;
  final String attemptId;
  final String questionId;
  final String? selectedOptionId;
  final bool? isCorrect;
  final DateTime? createdAt;

  StudentAnswerEntity({
    required this.id,
    required this.attemptId,
    required this.questionId,
    this.selectedOptionId,
    this.isCorrect,
    this.createdAt,
  });

  /// Check if this answer is correct
  bool get isAnswerCorrect => isCorrect == true;

  /// Check if this question was answered
  bool get isAnswered => selectedOptionId != null;

  StudentAnswerEntity copyWith({
    String? id,
    String? attemptId,
    String? questionId,
    String? selectedOptionId,
    bool? isCorrect,
    DateTime? createdAt,
  }) {
    return StudentAnswerEntity(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
      questionId: questionId ?? this.questionId,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentAnswerEntity &&
        other.id == id &&
        other.attemptId == attemptId &&
        other.questionId == questionId &&
        other.selectedOptionId == selectedOptionId &&
        other.isCorrect == isCorrect;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        attemptId.hashCode ^
        questionId.hashCode ^
        selectedOptionId.hashCode ^
        isCorrect.hashCode;
  }
}

/// Entity untuk attempt quiz oleh student
class QuizAttemptEntity {
  final String id;
  final String quizId;
  final String studentId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final String status; // 'in_progress' | 'finished'
  final int? score;
  final List<StudentAnswerEntity> answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuizAttemptEntity({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.startedAt,
    this.finishedAt,
    this.status = 'in_progress',
    this.score,
    this.answers = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Check if attempt is in progress
  bool get isInProgress => status == 'in_progress';

  /// Check if attempt is finished (supports both 'finished', 'submitted', 'graded')
  bool get isFinished =>
      status == 'finished' || status == 'submitted' || status == 'graded';

  /// Get count of answered questions
  int get answeredCount => answers.where((a) => a.isAnswered).length;

  /// Get count of correct answers
  int get correctCount => answers.where((a) => a.isAnswerCorrect).length;

  /// Get total questions count
  int get totalQuestions => answers.length;

  /// Calculate duration in seconds (if finished)
  int? get durationSeconds {
    if (finishedAt == null) return null;
    return finishedAt!.difference(startedAt).inSeconds;
  }

  /// Format duration as "X mins Y secs"
  String get formattedDuration {
    final seconds = durationSeconds;
    if (seconds == null) return '-';
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins mins $secs secs';
  }

  QuizAttemptEntity copyWith({
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
    return QuizAttemptEntity(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      studentId: studentId ?? this.studentId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
      score: score ?? this.score,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizAttemptEntity &&
        other.id == id &&
        other.quizId == quizId &&
        other.studentId == studentId &&
        other.status == status &&
        other.score == score;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        quizId.hashCode ^
        studentId.hashCode ^
        status.hashCode ^
        score.hashCode;
  }
}
