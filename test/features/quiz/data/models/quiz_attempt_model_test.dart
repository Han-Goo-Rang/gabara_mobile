// test/features/quiz/data/models/quiz_attempt_model_test.dart
// **Feature: student-quiz-feature, Property 5: Submission Data Completeness**
// **Validates: Requirements 5.5, 8.2**

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabara_mobile/features/quiz/data/models/quiz_attempt_model.dart';

void main() {
  group('StudentAnswerModel Serialization', () {
    test('fromJson creates valid model', () {
      final json = {
        'id': 'answer-123',
        'attempt_id': 'attempt-456',
        'question_id': 'question-789',
        'selected_option_id': 'option-abc',
        'is_correct': true,
        'created_at': '2024-11-29T10:00:00Z',
      };

      final model = StudentAnswerModel.fromJson(json);

      expect(model.id, 'answer-123');
      expect(model.attemptId, 'attempt-456');
      expect(model.questionId, 'question-789');
      expect(model.selectedOptionId, 'option-abc');
      expect(model.isCorrect, true);
    });

    test('toJson produces valid JSON', () {
      final model = StudentAnswerModel(
        id: 'answer-123',
        attemptId: 'attempt-456',
        questionId: 'question-789',
        selectedOptionId: 'option-abc',
        isCorrect: true,
        createdAt: DateTime.parse('2024-11-29T10:00:00Z'),
      );

      final json = model.toJson();

      expect(json['id'], 'answer-123');
      expect(json['attempt_id'], 'attempt-456');
      expect(json['question_id'], 'question-789');
      // Database schema uses 'option_id' instead of 'selected_option_id'
      expect(json['option_id'], 'option-abc');
      expect(json['is_correct'], true);
    });

    // Property-based test: Round-trip serialization (100 iterations)
    test('toJson then fromJson produces equivalent model', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final model = StudentAnswerModel(
          id: _randomString(random, 36),
          attemptId: _randomString(random, 36),
          questionId: _randomString(random, 36),
          selectedOptionId: random.nextBool()
              ? _randomString(random, 36)
              : null,
          isCorrect: random.nextBool() ? random.nextBool() : null,
          createdAt: DateTime.now(),
        );

        final json = model.toJson();
        final restored = StudentAnswerModel.fromJson(json);

        expect(restored.id, model.id);
        expect(restored.attemptId, model.attemptId);
        expect(restored.questionId, model.questionId);
        expect(restored.selectedOptionId, model.selectedOptionId);
        expect(restored.isCorrect, model.isCorrect);
      }
    });
  });

  group('QuizAttemptModel Serialization', () {
    test('fromJson creates valid model', () {
      final json = {
        'id': 'attempt-123',
        'quiz_id': 'quiz-456',
        'user_id': 'student-789',
        'started_at': '2024-11-29T10:00:00Z',
        'finished_at': '2024-11-29T10:30:00Z',
        'status': 'finished',
        'score': 85,
        'quiz_answers': [
          {
            'id': 'answer-1',
            'attempt_id': 'attempt-123',
            'question_id': 'q1',
            'selected_option_id': 'opt1',
            'is_correct': true,
          },
        ],
      };

      final model = QuizAttemptModel.fromJson(json);

      expect(model.id, 'attempt-123');
      expect(model.quizId, 'quiz-456');
      expect(model.studentId, 'student-789');
      expect(model.status, 'finished');
      expect(model.score, 85);
      expect(model.answers.length, 1);
    });

    // Property-based test: Round-trip serialization (100 iterations)
    test('toJson then fromJson produces equivalent model', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final isFinished = random.nextBool();
        final model = QuizAttemptModel(
          id: _randomString(random, 36),
          quizId: _randomString(random, 36),
          studentId: _randomString(random, 36),
          startedAt: DateTime.fromMillisecondsSinceEpoch(
            random.nextInt(1000000000) * 1000,
          ),
          finishedAt: isFinished
              ? DateTime.fromMillisecondsSinceEpoch(
                  random.nextInt(1000000000) * 1000,
                )
              : null,
          status: isFinished ? 'finished' : 'in_progress',
          score: isFinished ? random.nextInt(101) : null,
          answers: [],
        );

        final json = model.toJson();
        final restored = QuizAttemptModel.fromJson(json);

        expect(restored.id, model.id);
        expect(restored.quizId, model.quizId);
        expect(restored.studentId, model.studentId);
        expect(restored.status, model.status);
        expect(restored.score, model.score);
      }
    });
  });

  group('QuizAttemptEntity Computed Properties', () {
    test('answeredCount counts non-null selectedOptionId', () {
      final model = QuizAttemptModel(
        id: '1',
        quizId: '2',
        studentId: '3',
        startedAt: DateTime.now(),
        answers: [
          StudentAnswerModel(
            id: 'a1',
            attemptId: '1',
            questionId: 'q1',
            selectedOptionId: 'opt1',
            isCorrect: true,
          ),
          StudentAnswerModel(
            id: 'a2',
            attemptId: '1',
            questionId: 'q2',
            selectedOptionId: null,
            isCorrect: null,
          ),
          StudentAnswerModel(
            id: 'a3',
            attemptId: '1',
            questionId: 'q3',
            selectedOptionId: 'opt3',
            isCorrect: false,
          ),
        ],
      );

      expect(model.answeredCount, 2);
      expect(model.correctCount, 1);
      expect(model.totalQuestions, 3);
    });
  });
}

String _randomString(Random random, int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}
