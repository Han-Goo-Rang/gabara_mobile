// test/features/quiz/domain/validators/quiz_validator_test.dart
import 'dart:math';
import 'package:test/test.dart';
import 'package:gabara_mobile/features/quiz/domain/entities/quiz_entity.dart';
import 'package:gabara_mobile/features/quiz/domain/validators/quiz_validator.dart';

/// Helper to generate random whitespace string
String randomWhitespace(Random random) {
  const whitespaces = [' ', '\t', '\n', '\r', '  ', '\t\t'];
  final count = random.nextInt(5) + 1;
  return List.generate(
    count,
    (_) => whitespaces[random.nextInt(whitespaces.length)],
  ).join();
}

void main() {
  group('QuizValidator.validateQuizTitle', () {
    /// **Feature: quiz-mentor-feature, Property 5: Empty title validation rejection**
    /// *For any* quiz data where title is empty or whitespace-only,
    /// the validation function SHALL return false and prevent submission.
    /// **Validates: Requirements 2.10**
    test(
      'Property 5: Empty or whitespace-only titles are rejected (100 iterations)',
      () {
        final random = Random(42);

        // Test null
        expect(QuizValidator.validateQuizTitle(null).isValid, isFalse);

        // Test empty string
        expect(QuizValidator.validateQuizTitle('').isValid, isFalse);

        // Test whitespace-only strings (100 iterations)
        for (var i = 0; i < 100; i++) {
          final whitespaceTitle = randomWhitespace(random);
          final result = QuizValidator.validateQuizTitle(whitespaceTitle);
          expect(
            result.isValid,
            isFalse,
            reason:
                'Whitespace-only title "$whitespaceTitle" should be rejected at iteration $i',
          );
          expect(result.errorMessage, isNotNull);
        }
      },
    );

    test('Valid titles are accepted', () {
      expect(QuizValidator.validateQuizTitle('Quiz 1').isValid, isTrue);
      expect(
        QuizValidator.validateQuizTitle('  Quiz with spaces  ').isValid,
        isTrue,
      );
      expect(QuizValidator.validateQuizTitle('A').isValid, isTrue);
    });
  });

  group('QuizValidator.validateQuizQuestions', () {
    /// **Feature: quiz-mentor-feature, Property 6: Empty questions validation rejection**
    /// *For any* quiz data where questions list is empty,
    /// the validation function SHALL return false and prevent submission.
    /// **Validates: Requirements 2.11**
    test('Property 6: Empty questions list is rejected', () {
      // Test null
      expect(QuizValidator.validateQuizQuestions(null).isValid, isFalse);

      // Test empty list
      expect(QuizValidator.validateQuizQuestions([]).isValid, isFalse);

      // Verify error message
      final result = QuizValidator.validateQuizQuestions([]);
      expect(result.errorMessage, contains('minimal 1 pertanyaan'));
    });

    test('Non-empty questions list is accepted', () {
      final questions = [
        QuestionEntity(
          id: '1',
          question: 'Test question',
          options: [OptionEntity(id: '1', text: 'Option A', isCorrect: true)],
        ),
      ];
      expect(QuizValidator.validateQuizQuestions(questions).isValid, isTrue);
    });
  });

  group('QuizValidator.validateCorrectAnswer', () {
    test('Options without correct answer are rejected', () {
      final options = [
        OptionEntity(id: '1', text: 'Option A', isCorrect: false),
        OptionEntity(id: '2', text: 'Option B', isCorrect: false),
      ];
      final result = QuizValidator.validateCorrectAnswer(options);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('jawaban yang benar'));
    });

    test('Options with correct answer are accepted', () {
      final options = [
        OptionEntity(id: '1', text: 'Option A', isCorrect: true),
        OptionEntity(id: '2', text: 'Option B', isCorrect: false),
      ];
      expect(QuizValidator.validateCorrectAnswer(options).isValid, isTrue);
    });

    test('Empty options list is rejected', () {
      expect(QuizValidator.validateCorrectAnswer([]).isValid, isFalse);
      expect(QuizValidator.validateCorrectAnswer(null).isValid, isFalse);
    });
  });

  group('QuizValidator.validateDateRange', () {
    test('closeAt before openAt is rejected', () {
      final openAt = DateTime(2025, 11, 20);
      final closeAt = DateTime(2025, 11, 18);
      final result = QuizValidator.validateDateRange(openAt, closeAt);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('setelah tanggal buka'));
    });

    test('closeAt equal to openAt is rejected', () {
      final date = DateTime(2025, 11, 20, 10, 0);
      final result = QuizValidator.validateDateRange(date, date);
      expect(result.isValid, isFalse);
    });

    test('closeAt after openAt is accepted', () {
      final openAt = DateTime(2025, 11, 18);
      final closeAt = DateTime(2025, 11, 30);
      expect(QuizValidator.validateDateRange(openAt, closeAt).isValid, isTrue);
    });

    test('Null dates are accepted', () {
      expect(QuizValidator.validateDateRange(null, null).isValid, isTrue);
      expect(
        QuizValidator.validateDateRange(DateTime.now(), null).isValid,
        isTrue,
      );
      expect(
        QuizValidator.validateDateRange(null, DateTime.now()).isValid,
        isTrue,
      );
    });
  });

  group('QuizValidator.validateQuestion', () {
    test('Question with empty text is rejected', () {
      final question = QuestionEntity(
        id: '1',
        question: '',
        options: [OptionEntity(id: '1', text: 'A', isCorrect: true)],
      );
      expect(QuizValidator.validateQuestion(question).isValid, isFalse);
    });

    test('Multiple choice with less than 2 options is rejected', () {
      final question = QuestionEntity(
        id: '1',
        question: 'Test?',
        questionType: 'multiple_choice',
        options: [OptionEntity(id: '1', text: 'A', isCorrect: true)],
      );
      final result = QuizValidator.validateQuestion(question);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('minimal 2 opsi'));
    });

    test('Multiple choice with empty option text is rejected', () {
      final question = QuestionEntity(
        id: '1',
        question: 'Test?',
        questionType: 'multiple_choice',
        options: [
          OptionEntity(id: '1', text: 'A', isCorrect: true),
          OptionEntity(id: '2', text: '', isCorrect: false),
        ],
      );
      final result = QuizValidator.validateQuestion(question);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('tidak boleh kosong'));
    });

    test('Valid multiple choice question is accepted', () {
      final question = QuestionEntity(
        id: '1',
        question: 'What is 2+2?',
        questionType: 'multiple_choice',
        options: [
          OptionEntity(id: '1', text: '3', isCorrect: false),
          OptionEntity(id: '2', text: '4', isCorrect: true),
          OptionEntity(id: '3', text: '5', isCorrect: false),
        ],
      );
      expect(QuizValidator.validateQuestion(question).isValid, isTrue);
    });

    test('Valid true/false question is accepted', () {
      final question = QuestionEntity(
        id: '1',
        question: 'The sky is blue?',
        questionType: 'true_false',
        options: [
          OptionEntity(id: '1', text: 'Benar', isCorrect: true),
          OptionEntity(id: '2', text: 'Salah', isCorrect: false),
        ],
      );
      expect(QuizValidator.validateQuestion(question).isValid, isTrue);
    });
  });

  group('QuizValidator.validateQuiz', () {
    test('Valid quiz passes all validations', () {
      final quiz = QuizEntity(
        id: '1',
        title: 'Test Quiz',
        description: 'A test quiz',
        questions: [
          QuestionEntity(
            id: '1',
            question: 'What is 2+2?',
            questionType: 'multiple_choice',
            options: [
              OptionEntity(id: '1', text: '3', isCorrect: false),
              OptionEntity(id: '2', text: '4', isCorrect: true),
            ],
          ),
        ],
        openAt: DateTime(2025, 11, 18),
        closeAt: DateTime(2025, 11, 30),
      );
      expect(QuizValidator.validateQuiz(quiz).isValid, isTrue);
    });

    test('Quiz with invalid title fails', () {
      final quiz = QuizEntity(
        id: '1',
        title: '',
        description: 'A test quiz',
        questions: [
          QuestionEntity(
            id: '1',
            question: 'Q?',
            options: [OptionEntity(id: '1', text: 'A', isCorrect: true)],
          ),
        ],
      );
      expect(QuizValidator.validateQuiz(quiz).isValid, isFalse);
    });

    test('Quiz with no questions fails', () {
      final quiz = QuizEntity(
        id: '1',
        title: 'Test Quiz',
        description: 'A test quiz',
        questions: [],
      );
      expect(QuizValidator.validateQuiz(quiz).isValid, isFalse);
    });

    test('Quiz with invalid date range fails', () {
      final quiz = QuizEntity(
        id: '1',
        title: 'Test Quiz',
        description: 'A test quiz',
        questions: [
          QuestionEntity(
            id: '1',
            question: 'Q?',
            options: [OptionEntity(id: '1', text: 'A', isCorrect: true)],
          ),
        ],
        openAt: DateTime(2025, 11, 30),
        closeAt: DateTime(2025, 11, 18),
      );
      expect(QuizValidator.validateQuiz(quiz).isValid, isFalse);
    });
  });
}
