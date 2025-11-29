// test/features/quiz/data/models/quiz_model_test.dart
import 'dart:math';
import 'package:test/test.dart';
import 'package:gabara_mobile/features/quiz/data/models/quiz_model.dart';

/// Helper to generate random string
String randomString(Random random, int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}

/// Generate random OptionModel
OptionModel randomOptionModel(Random random) {
  return OptionModel(
    id: randomString(random, 8),
    text: randomString(random, 20),
    isCorrect: random.nextBool(),
    orderIndex: random.nextInt(10),
  );
}

/// Generate random QuestionModel
QuestionModel randomQuestionModel(Random random) {
  final types = ['multiple_choice', 'true_false'];
  final optionCount = random.nextInt(3) + 2; // 2-4 options

  return QuestionModel(
    id: randomString(random, 8),
    question: randomString(random, 50),
    questionType: types[random.nextInt(types.length)],
    options: List.generate(optionCount, (_) => randomOptionModel(random)),
    orderIndex: random.nextInt(10),
  );
}

/// Generate random QuizModel
QuizModel randomQuizModel(Random random) {
  final statuses = ['draft', 'published'];
  final questionCount = random.nextInt(4) + 1; // 1-4 questions

  return QuizModel(
    id: randomString(random, 8),
    classId: randomString(random, 8),
    title: randomString(random, 30),
    description: randomString(random, 100),
    status: statuses[random.nextInt(statuses.length)],
    questions: List.generate(questionCount, (_) => randomQuestionModel(random)),
    attemptsAllowed: random.nextInt(5) + 1,
    durationMinutes: random.nextInt(60) + 5,
    openAt: DateTime.now(),
    closeAt: DateTime.now().add(const Duration(days: 7)),
  );
}

void main() {
  group('QuizModel Serialization', () {
    /// **Feature: quiz-mentor-feature, Property 15: JSON serialization round-trip**
    /// *For any* valid QuizModel, serializing to JSON and then deserializing
    /// SHALL produce an equivalent QuizModel.
    /// **Validates: Requirements 6.5, 6.6**
    test(
      'Property 15: toJson then fromJson produces equivalent QuizModel (100 iterations)',
      () {
        final random = Random(42); // Fixed seed for reproducibility

        for (var i = 0; i < 100; i++) {
          final quiz = randomQuizModel(random);

          // Serialize to JSON
          final json = quiz.toJson();

          // Deserialize from JSON
          final restored = QuizModel.fromJson(json);

          // Verify equivalence
          expect(
            restored.id,
            equals(quiz.id),
            reason: 'ID mismatch at iteration $i',
          );
          expect(
            restored.title,
            equals(quiz.title),
            reason: 'Title mismatch at iteration $i',
          );
          expect(
            restored.description,
            equals(quiz.description),
            reason: 'Description mismatch at iteration $i',
          );
          expect(
            restored.questionCount,
            equals(quiz.questionCount),
            reason: 'Question count mismatch at iteration $i',
          );
          expect(
            restored.attemptsAllowed,
            equals(quiz.attemptsAllowed),
            reason: 'Attempts mismatch at iteration $i',
          );
          expect(
            restored.durationMinutes,
            equals(quiz.durationMinutes),
            reason: 'Duration mismatch at iteration $i',
          );

          // Verify questions
          for (var j = 0; j < quiz.questionCount; j++) {
            final original = quiz.questionModels[j];
            final restoredQ = restored.questionModels[j];
            expect(
              restoredQ.question,
              equals(original.question),
              reason: 'Question text mismatch at iteration $i, question $j',
            );
            expect(
              restoredQ.questionType,
              equals(original.questionType),
              reason: 'Question type mismatch at iteration $i, question $j',
            );
            expect(
              restoredQ.optionModels.length,
              equals(original.optionModels.length),
              reason: 'Option count mismatch at iteration $i, question $j',
            );
          }
        }
      },
    );
  });

  group('OptionModel Serialization', () {
    test(
      'toJson then fromJson produces equivalent OptionModel (100 iterations)',
      () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final option = randomOptionModel(random);
          final json = option.toJson();
          final restored = OptionModel.fromJson(json);

          expect(
            restored.id,
            equals(option.id),
            reason: 'ID mismatch at iteration $i',
          );
          expect(
            restored.text,
            equals(option.text),
            reason: 'Text mismatch at iteration $i',
          );
          expect(
            restored.isCorrect,
            equals(option.isCorrect),
            reason: 'isCorrect mismatch at iteration $i',
          );
        }
      },
    );
  });

  group('QuestionModel Serialization', () {
    test(
      'toJson then fromJson produces equivalent QuestionModel (100 iterations)',
      () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final question = randomQuestionModel(random);
          final json = question.toJson();
          final restored = QuestionModel.fromJson(json);

          expect(
            restored.id,
            equals(question.id),
            reason: 'ID mismatch at iteration $i',
          );
          expect(
            restored.question,
            equals(question.question),
            reason: 'Question mismatch at iteration $i',
          );
          expect(
            restored.questionType,
            equals(question.questionType),
            reason: 'Type mismatch at iteration $i',
          );
          expect(
            restored.optionModels.length,
            equals(question.optionModels.length),
            reason: 'Option count mismatch at iteration $i',
          );
        }
      },
    );
  });

  group('QuizEntity Computed Properties', () {
    test('questionCount returns correct count', () {
      final quiz = QuizModel(
        id: '1',
        title: 'Test',
        description: 'Desc',
        questions: [
          QuestionModel(id: '1', question: 'Q1', options: []),
          QuestionModel(id: '2', question: 'Q2', options: []),
          QuestionModel(id: '3', question: 'Q3', options: []),
        ],
      );
      expect(quiz.questionCount, equals(3));
    });

    test('isPublished returns true for published status', () {
      final quiz = QuizModel(
        id: '1',
        title: 'Test',
        description: 'Desc',
        status: 'published',
        questions: [],
      );
      expect(quiz.isPublished, isTrue);
      expect(quiz.isDraft, isFalse);
    });

    test('isDraft returns true for draft status', () {
      final quiz = QuizModel(
        id: '1',
        title: 'Test',
        description: 'Desc',
        status: 'draft',
        questions: [],
      );
      expect(quiz.isDraft, isTrue);
      expect(quiz.isPublished, isFalse);
    });
  });

  group('QuestionEntity Computed Properties', () {
    test('isMultipleChoice returns true for multiple_choice type', () {
      final question = QuestionModel(
        id: '1',
        question: 'Test',
        questionType: 'multiple_choice',
        options: [],
      );
      expect(question.isMultipleChoice, isTrue);
      expect(question.isTrueFalse, isFalse);
    });

    test('isTrueFalse returns true for true_false type', () {
      final question = QuestionModel(
        id: '1',
        question: 'Test',
        questionType: 'true_false',
        options: [],
      );
      expect(question.isTrueFalse, isTrue);
      expect(question.isMultipleChoice, isFalse);
    });
  });
}
