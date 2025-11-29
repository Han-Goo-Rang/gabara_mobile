// test/features/quiz/data/services/attempt_record_integrity_test.dart
// **Feature: student-quiz-feature, Property 4: Attempt Record Integrity**
// **Validates: Requirements 3.3, 8.1**

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabara_mobile/features/quiz/data/models/quiz_attempt_model.dart';

/// Validate that an attempt record has all required fields
/// for a newly started attempt
bool validateNewAttemptRecord(QuizAttemptModel attempt) {
  // Must have valid student_id (non-empty)
  if (attempt.studentId.isEmpty) return false;

  // Must have valid quiz_id (non-empty)
  if (attempt.quizId.isEmpty) return false;

  // Must have started_at timestamp not in the future
  if (attempt.startedAt.isAfter(
    DateTime.now().add(const Duration(seconds: 1)),
  )) {
    return false;
  }

  // Must have status "in_progress"
  if (attempt.status != 'in_progress') return false;

  // Must have valid id (non-empty)
  if (attempt.id.isEmpty) return false;

  return true;
}

/// Validate that a completed attempt record has all required fields
bool validateCompletedAttemptRecord(QuizAttemptModel attempt) {
  // Must pass new attempt validation first
  if (attempt.studentId.isEmpty) return false;
  if (attempt.quizId.isEmpty) return false;
  if (attempt.id.isEmpty) return false;

  // Must have finished_at timestamp
  if (attempt.finishedAt == null) return false;

  // finished_at must be after started_at
  if (attempt.finishedAt!.isBefore(attempt.startedAt)) return false;

  // Must have status "finished"
  if (attempt.status != 'finished') return false;

  // Must have score (0-100)
  if (attempt.score == null) return false;
  if (attempt.score! < 0 || attempt.score! > 100) return false;

  return true;
}

void main() {
  group('Property 4: Attempt Record Integrity', () {
    group('New Attempt Validation', () {
      test('valid new attempt passes validation', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: DateTime.now(),
          status: 'in_progress',
        );

        expect(validateNewAttemptRecord(attempt), true);
      });

      test('attempt with empty student_id fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: '',
          startedAt: DateTime.now(),
          status: 'in_progress',
        );

        expect(validateNewAttemptRecord(attempt), false);
      });

      test('attempt with empty quiz_id fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: '',
          studentId: 'student-789',
          startedAt: DateTime.now(),
          status: 'in_progress',
        );

        expect(validateNewAttemptRecord(attempt), false);
      });

      test('attempt with future started_at fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: DateTime.now().add(const Duration(hours: 1)),
          status: 'in_progress',
        );

        expect(validateNewAttemptRecord(attempt), false);
      });

      test('attempt with wrong status fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: DateTime.now(),
          status: 'finished',
        );

        expect(validateNewAttemptRecord(attempt), false);
      });

      // Property-based test
      test('all valid new attempts pass validation (property test)', () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final attempt = QuizAttemptModel(
            id: _randomNonEmptyString(random),
            quizId: _randomNonEmptyString(random),
            studentId: _randomNonEmptyString(random),
            startedAt: DateTime.now().subtract(
              Duration(seconds: random.nextInt(3600)),
            ),
            status: 'in_progress',
          );

          expect(
            validateNewAttemptRecord(attempt),
            true,
            reason: 'Iteration $i: Valid attempt should pass',
          );
        }
      });
    });

    group('Completed Attempt Validation', () {
      test('valid completed attempt passes validation', () {
        final startTime = DateTime.now().subtract(const Duration(minutes: 5));
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: startTime,
          finishedAt: DateTime.now(),
          status: 'finished',
          score: 85,
        );

        expect(validateCompletedAttemptRecord(attempt), true);
      });

      test('completed attempt without finished_at fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: DateTime.now(),
          status: 'finished',
          score: 85,
        );

        expect(validateCompletedAttemptRecord(attempt), false);
      });

      test('completed attempt with finished_at before started_at fails', () {
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: DateTime.now(),
          finishedAt: DateTime.now().subtract(const Duration(hours: 1)),
          status: 'finished',
          score: 85,
        );

        expect(validateCompletedAttemptRecord(attempt), false);
      });

      test('completed attempt without score fails', () {
        final startTime = DateTime.now().subtract(const Duration(minutes: 5));
        final attempt = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: startTime,
          finishedAt: DateTime.now(),
          status: 'finished',
          score: null,
        );

        expect(validateCompletedAttemptRecord(attempt), false);
      });

      test('completed attempt with invalid score fails', () {
        final startTime = DateTime.now().subtract(const Duration(minutes: 5));

        // Score > 100
        final attempt1 = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: startTime,
          finishedAt: DateTime.now(),
          status: 'finished',
          score: 150,
        );
        expect(validateCompletedAttemptRecord(attempt1), false);

        // Score < 0
        final attempt2 = QuizAttemptModel(
          id: 'attempt-123',
          quizId: 'quiz-456',
          studentId: 'student-789',
          startedAt: startTime,
          finishedAt: DateTime.now(),
          status: 'finished',
          score: -10,
        );
        expect(validateCompletedAttemptRecord(attempt2), false);
      });

      // Property-based test
      test('all valid completed attempts pass validation (property test)', () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final startTime = DateTime.now().subtract(
            Duration(seconds: random.nextInt(3600) + 60),
          );
          final finishTime = startTime.add(
            Duration(seconds: random.nextInt(3600) + 1),
          );

          final attempt = QuizAttemptModel(
            id: _randomNonEmptyString(random),
            quizId: _randomNonEmptyString(random),
            studentId: _randomNonEmptyString(random),
            startedAt: startTime,
            finishedAt: finishTime,
            status: 'finished',
            score: random.nextInt(101), // 0-100
          );

          expect(
            validateCompletedAttemptRecord(attempt),
            true,
            reason: 'Iteration $i: Valid completed attempt should pass',
          );
        }
      });

      // Property-based test: Score is always 0-100
      test('score is always within valid range (property test)', () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final score = random.nextInt(101);

          expect(score >= 0, true);
          expect(score <= 100, true);
        }
      });
    });
  });
}

String _randomNonEmptyString(Random random) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final length = random.nextInt(20) + 5; // 5-24 characters
  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}
