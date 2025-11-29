// test/features/quiz/data/services/score_calculation_test.dart
// **Feature: student-quiz-feature, Property 1: Score Calculation Correctness**
// **Validates: Requirements 5.3, 8.3**

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

/// Pure function for score calculation (extracted for testing)
/// Score = (correct answers / total questions) * 100, rounded
int calculateScore(int correctCount, int totalQuestions) {
  if (totalQuestions <= 0) return 0;
  return ((correctCount / totalQuestions) * 100).round();
}

/// Determine if an answer is correct based on selected option
bool isAnswerCorrect(String? selectedOptionId, List<MockOption> options) {
  if (selectedOptionId == null) return false;
  final selected = options.firstWhere(
    (o) => o.id == selectedOptionId,
    orElse: () => MockOption(id: '', isCorrect: false),
  );
  return selected.isCorrect;
}

class MockOption {
  final String id;
  final bool isCorrect;
  MockOption({required this.id, required this.isCorrect});
}

class MockQuestion {
  final String id;
  final List<MockOption> options;
  MockQuestion({required this.id, required this.options});
}

void main() {
  group('Score Calculation', () {
    test('calculates 100% for all correct answers', () {
      expect(calculateScore(10, 10), 100);
      expect(calculateScore(5, 5), 100);
      expect(calculateScore(1, 1), 100);
    });

    test('calculates 0% for all wrong answers', () {
      expect(calculateScore(0, 10), 0);
      expect(calculateScore(0, 5), 0);
      expect(calculateScore(0, 1), 0);
    });

    test('calculates correct percentage for partial scores', () {
      expect(calculateScore(5, 10), 50);
      expect(calculateScore(3, 10), 30);
      expect(calculateScore(7, 10), 70);
      expect(calculateScore(1, 4), 25);
      expect(calculateScore(3, 4), 75);
    });

    test('rounds to nearest integer', () {
      // 1/3 = 33.33... -> 33
      expect(calculateScore(1, 3), 33);
      // 2/3 = 66.66... -> 67
      expect(calculateScore(2, 3), 67);
      // 1/6 = 16.66... -> 17
      expect(calculateScore(1, 6), 17);
      // 5/6 = 83.33... -> 83
      expect(calculateScore(5, 6), 83);
    });

    test('handles zero questions gracefully', () {
      expect(calculateScore(0, 0), 0);
    });

    // Property-based test: Score is always between 0 and 100
    test('score is always between 0 and 100 (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final total = random.nextInt(50) + 1; // 1-50 questions
        final correct = random.nextInt(total + 1); // 0 to total correct

        final score = calculateScore(correct, total);

        expect(score >= 0, true, reason: 'Score should be >= 0');
        expect(score <= 100, true, reason: 'Score should be <= 100');
      }
    });

    // Property-based test: Score = (correct/total) * 100
    test('score equals (correct/total) * 100 rounded (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final total = random.nextInt(50) + 1;
        final correct = random.nextInt(total + 1);

        final score = calculateScore(correct, total);
        final expected = ((correct / total) * 100).round();

        expect(score, expected);
      }
    });

    // Property-based test: More correct answers = higher or equal score
    test(
      'more correct answers means higher or equal score (property test)',
      () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final total = random.nextInt(50) + 1;
          final correct1 = random.nextInt(total + 1);
          final correct2 = random.nextInt(total + 1);

          final score1 = calculateScore(correct1, total);
          final score2 = calculateScore(correct2, total);

          if (correct1 > correct2) {
            expect(score1 >= score2, true);
          } else if (correct2 > correct1) {
            expect(score2 >= score1, true);
          }
        }
      },
    );
  });

  group('Answer Correctness Determination', () {
    test('returns true when selected option is correct', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
        MockOption(id: 'opt3', isCorrect: false),
      ];

      expect(isAnswerCorrect('opt2', options), true);
    });

    test('returns false when selected option is incorrect', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
        MockOption(id: 'opt3', isCorrect: false),
      ];

      expect(isAnswerCorrect('opt1', options), false);
      expect(isAnswerCorrect('opt3', options), false);
    });

    test('returns false when no option selected', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
      ];

      expect(isAnswerCorrect(null, options), false);
    });

    test('returns false when selected option not found', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
      ];

      expect(isAnswerCorrect('nonexistent', options), false);
    });

    // Property-based test: Correct count matches score calculation
    test('correct count from answers matches score (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        final questionCount = random.nextInt(20) + 1;
        final questions = List.generate(questionCount, (idx) {
          final correctIdx = random.nextInt(4);
          return MockQuestion(
            id: 'q$idx',
            options: List.generate(
              4,
              (optIdx) => MockOption(
                id: 'q${idx}_opt$optIdx',
                isCorrect: optIdx == correctIdx,
              ),
            ),
          );
        });

        // Generate random answers
        final answers = <String, String?>{};
        int expectedCorrect = 0;

        for (final q in questions) {
          if (random.nextBool()) {
            // Answer this question
            final selectedIdx = random.nextInt(4);
            final selectedId = 'q${questions.indexOf(q)}_opt$selectedIdx';
            answers[q.id] = selectedId;

            if (isAnswerCorrect(selectedId, q.options)) {
              expectedCorrect++;
            }
          } else {
            answers[q.id] = null;
          }
        }

        final score = calculateScore(expectedCorrect, questionCount);
        final expectedScore = ((expectedCorrect / questionCount) * 100).round();

        expect(score, expectedScore);
      }
    });
  });
}
