// lib/features/quiz/domain/validators/quiz_validator.dart
import '../entities/quiz_entity.dart';

/// Validation result containing success status and error message
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult.valid() : isValid = true, errorMessage = null;
  const ValidationResult.invalid(this.errorMessage) : isValid = false;
}

/// Validator for Quiz entities
class QuizValidator {
  /// Validate quiz title - reject empty or whitespace-only
  /// **Validates: Requirements 2.10**
  static ValidationResult validateQuizTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return const ValidationResult.invalid('Judul quiz tidak boleh kosong');
    }
    return const ValidationResult.valid();
  }

  /// Validate quiz questions - reject empty list
  /// **Validates: Requirements 2.11**
  static ValidationResult validateQuizQuestions(
    List<QuestionEntity>? questions,
  ) {
    if (questions == null || questions.isEmpty) {
      return const ValidationResult.invalid(
        'Quiz harus memiliki minimal 1 pertanyaan',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate question text - reject empty
  static ValidationResult validateQuestionText(String? questionText) {
    if (questionText == null || questionText.trim().isEmpty) {
      return const ValidationResult.invalid(
        'Teks pertanyaan tidak boleh kosong',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate that at least one option is marked as correct
  static ValidationResult validateCorrectAnswer(List<OptionEntity>? options) {
    if (options == null || options.isEmpty) {
      return const ValidationResult.invalid(
        'Pertanyaan harus memiliki opsi jawaban',
      );
    }

    final hasCorrectAnswer = options.any((option) => option.isCorrect);
    if (!hasCorrectAnswer) {
      return const ValidationResult.invalid('Pilih jawaban yang benar');
    }
    return const ValidationResult.valid();
  }

  /// Validate date range - closeAt must be after openAt
  static ValidationResult validateDateRange(
    DateTime? openAt,
    DateTime? closeAt,
  ) {
    if (openAt != null && closeAt != null) {
      if (closeAt.isBefore(openAt) || closeAt.isAtSameMomentAs(openAt)) {
        return const ValidationResult.invalid(
          'Tanggal tutup harus setelah tanggal buka',
        );
      }
    }
    return const ValidationResult.valid();
  }

  /// Validate a single question with all its options
  static ValidationResult validateQuestion(QuestionEntity question) {
    // Validate question text
    final textResult = validateQuestionText(question.question);
    if (!textResult.isValid) return textResult;

    // For multiple choice, validate options and correct answer
    if (question.isMultipleChoice) {
      if (question.options.length < 2) {
        return const ValidationResult.invalid(
          'Pilihan ganda harus memiliki minimal 2 opsi',
        );
      }

      final correctResult = validateCorrectAnswer(question.options);
      if (!correctResult.isValid) return correctResult;

      // Validate each option has text
      for (var i = 0; i < question.options.length; i++) {
        if (question.options[i].text.trim().isEmpty) {
          return ValidationResult.invalid('Opsi ${i + 1} tidak boleh kosong');
        }
      }
    }

    // For true/false, validate correct answer is set
    if (question.isTrueFalse) {
      final correctResult = validateCorrectAnswer(question.options);
      if (!correctResult.isValid) return correctResult;
    }

    return const ValidationResult.valid();
  }

  /// Validate entire quiz
  static ValidationResult validateQuiz(QuizEntity quiz) {
    // Validate title
    final titleResult = validateQuizTitle(quiz.title);
    if (!titleResult.isValid) return titleResult;

    // Validate questions exist
    final questionsResult = validateQuizQuestions(quiz.questions);
    if (!questionsResult.isValid) return questionsResult;

    // Validate date range
    final dateResult = validateDateRange(quiz.openAt, quiz.closeAt);
    if (!dateResult.isValid) return dateResult;

    // Validate each question
    for (var i = 0; i < quiz.questions.length; i++) {
      final questionResult = validateQuestion(quiz.questions[i]);
      if (!questionResult.isValid) {
        return ValidationResult.invalid(
          'Pertanyaan ${i + 1}: ${questionResult.errorMessage}',
        );
      }
    }

    return const ValidationResult.valid();
  }
}
