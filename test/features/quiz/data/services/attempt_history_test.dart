// test/features/quiz/data/services/attempt_history_test.dart
// **Feature: student-quiz-feature, Property 7: Attempt History Ordering**
// **Validates: Requirements 8.5**

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabara_mobile/features/quiz/data/models/quiz_attempt_model.dart';

/// Sort attempts by started_at descending (newest first)
List<QuizAttemptModel> sortAttemptsByStartedAtDesc(
  List<QuizAttemptModel> attempts,
) {
  final sorted = List<QuizAttemptModel>.from(attempts);
  sorted.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return sorted;
}

/// Check if list is sorted by started_at descending
bool isSortedByStartedAtDesc(List<QuizAttemptModel> attempts) {
  for (var i = 0; i < attempts.length - 1; i++) {
    if (attempts[i].startedAt.isBefore(attempts[i + 1].startedAt)) {
      return false;
    }
  }
  return true;
}

void main() {
  group('Attempt History Ordering', () {
    test('sorts attempts by started_at descending', () {
      final attempts = [
        QuizAttemptModel(
          id: '1',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 10, 0),
          status: 'finished',
        ),
        QuizAttemptModel(
          id: '2',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 12, 0),
          status: 'finished',
        ),
        QuizAttemptModel(
          id: '3',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 8, 0),
          status: 'finished',
        ),
      ];

      final sorted = sortAttemptsByStartedAtDesc(attempts);

      expect(sorted[0].id, '2'); // 12:00 - newest
      expect(sorted[1].id, '1'); // 10:00
      expect(sorted[2].id, '3'); // 08:00 - oldest
    });

    test('empty list remains empty', () {
      final sorted = sortAttemptsByStartedAtDesc([]);
      expect(sorted, isEmpty);
    });

    test('single item list remains unchanged', () {
      final attempts = [
        QuizAttemptModel(
          id: '1',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime.now(),
          status: 'finished',
        ),
      ];

      final sorted = sortAttemptsByStartedAtDesc(attempts);
      expect(sorted.length, 1);
      expect(sorted[0].id, '1');
    });

    test('already sorted list remains sorted', () {
      final attempts = [
        QuizAttemptModel(
          id: '1',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 12, 0),
          status: 'finished',
        ),
        QuizAttemptModel(
          id: '2',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 10, 0),
          status: 'finished',
        ),
        QuizAttemptModel(
          id: '3',
          quizId: 'q1',
          studentId: 's1',
          startedAt: DateTime(2024, 11, 29, 8, 0),
          status: 'finished',
        ),
      ];

      final sorted = sortAttemptsByStartedAtDesc(attempts);
      expect(isSortedByStartedAtDesc(sorted), true);
    });

    // Property-based test: Sorted list is always in descending order
    test('sorted list is always in descending order (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final count = random.nextInt(20) + 1;
        final attempts = List.generate(count, (idx) {
          return QuizAttemptModel(
            id: 'attempt_$idx',
            quizId: 'quiz_1',
            studentId: 'student_1',
            startedAt: DateTime.fromMillisecondsSinceEpoch(
              random.nextInt(1000000000) * 1000,
            ),
            status: 'finished',
          );
        });

        final sorted = sortAttemptsByStartedAtDesc(attempts);

        expect(
          isSortedByStartedAtDesc(sorted),
          true,
          reason: 'Iteration $i: List should be sorted descending',
        );
      }
    });

    // Property-based test: Sorting preserves all elements
    test('sorting preserves all elements (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final count = random.nextInt(20) + 1;
        final attempts = List.generate(count, (idx) {
          return QuizAttemptModel(
            id: 'attempt_$idx',
            quizId: 'quiz_1',
            studentId: 'student_1',
            startedAt: DateTime.fromMillisecondsSinceEpoch(
              random.nextInt(1000000000) * 1000,
            ),
            status: 'finished',
          );
        });

        final sorted = sortAttemptsByStartedAtDesc(attempts);

        expect(sorted.length, attempts.length);

        // All original IDs should be present
        final originalIds = attempts.map((a) => a.id).toSet();
        final sortedIds = sorted.map((a) => a.id).toSet();
        expect(sortedIds, originalIds);
      }
    });

    // Property-based test: First element is the newest
    test('first element has the latest started_at (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final count = random.nextInt(20) + 1;
        final attempts = List.generate(count, (idx) {
          return QuizAttemptModel(
            id: 'attempt_$idx',
            quizId: 'quiz_1',
            studentId: 'student_1',
            startedAt: DateTime.fromMillisecondsSinceEpoch(
              random.nextInt(1000000000) * 1000,
            ),
            status: 'finished',
          );
        });

        final sorted = sortAttemptsByStartedAtDesc(attempts);
        final maxStartedAt = attempts
            .map((a) => a.startedAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        expect(sorted.first.startedAt, maxStartedAt);
      }
    });
  });
}
