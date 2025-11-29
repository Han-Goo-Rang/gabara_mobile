// test/features/quiz/presentation/widgets/answer_correctness_test.dart
// **Feature: student-quiz-feature, Property 6: Answer Correctness Determination**
// **Validates: Requirements 6.3, 6.4, 8.3**

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

/// Determine if an answer is correct
/// is_correct is true if and only if selected_option_id matches
/// an option where is_correct is true for that question
bool determineAnswerCorrectness(
  String? selectedOptionId,
  List<MockOption> options,
) {
  if (selectedOptionId == null) return false;

  final selectedOption = options.firstWhere(
    (o) => o.id == selectedOptionId,
    orElse: () => MockOption(id: '', isCorrect: false),
  );

  return selectedOption.isCorrect;
}

class MockOption {
  final String id;
  final bool isCorrect;

  MockOption({required this.id, required this.isCorrect});
}

void main() {
  group('Property 6: Answer Correctness Determination', () {
    test('returns true when selected option is the correct one', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
        MockOption(id: 'opt3', isCorrect: false),
        MockOption(id: 'opt4', isCorrect: false),
      ];

      expect(determineAnswerCorrectness('opt2', options), true);
    });

    test('returns false when selected option is incorrect', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
        MockOption(id: 'opt3', isCorrect: false),
        MockOption(id: 'opt4', isCorrect: false),
      ];

      expect(determineAnswerCorrectness('opt1', options), false);
      expect(determineAnswerCorrectness('opt3', options), false);
      expect(determineAnswerCorrectness('opt4', options), false);
    });

    test('returns false when no option is selected (null)', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
      ];

      expect(determineAnswerCorrectness(null, options), false);
    });

    test('returns false when selected option does not exist', () {
      final options = [
        MockOption(id: 'opt1', isCorrect: false),
        MockOption(id: 'opt2', isCorrect: true),
      ];

      expect(determineAnswerCorrectness('nonexistent', options), false);
    });

    test('handles true/false questions correctly', () {
      final trueFalseOptions = [
        MockOption(id: 'true', isCorrect: true),
        MockOption(id: 'false', isCorrect: false),
      ];

      expect(determineAnswerCorrectness('true', trueFalseOptions), true);
      expect(determineAnswerCorrectness('false', trueFalseOptions), false);
    });

    // Property-based test: is_correct matches option.isCorrect
    test('is_correct equals selected option isCorrect (property test)', () {
      final random = Random(42);

      for (var i = 0; i < 100; i++) {
        // Generate random options (2-6 options)
        final optionCount = random.nextInt(5) + 2;
        final correctIndex = random.nextInt(optionCount);

        final options = List.generate(optionCount, (idx) {
          return MockOption(id: 'opt_$idx', isCorrect: idx == correctIndex);
        });

        // Test selecting each option
        for (var j = 0; j < optionCount; j++) {
          final selectedId = 'opt_$j';
          final result = determineAnswerCorrectness(selectedId, options);
          final expectedCorrect = j == correctIndex;

          expect(
            result,
            expectedCorrect,
            reason:
                'Iteration $i, option $j: expected $expectedCorrect but got $result',
          );
        }

        // Test null selection
        expect(
          determineAnswerCorrectness(null, options),
          false,
          reason: 'Null selection should always be false',
        );
      }
    });

    // Property-based test: Only one correct answer per question
    test(
      'exactly one option returns true for correct selection (property test)',
      () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final optionCount = random.nextInt(5) + 2;
          final correctIndex = random.nextInt(optionCount);

          final options = List.generate(optionCount, (idx) {
            return MockOption(id: 'opt_$idx', isCorrect: idx == correctIndex);
          });

          // Count how many options return true
          int trueCount = 0;
          for (var j = 0; j < optionCount; j++) {
            if (determineAnswerCorrectness('opt_$j', options)) {
              trueCount++;
            }
          }

          expect(trueCount, 1, reason: 'Exactly one option should be correct');
        }
      },
    );

    // Property-based test: Consistency with option.isCorrect
    test(
      'result is consistent with option isCorrect field (property test)',
      () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final optionCount = random.nextInt(5) + 2;
          final correctIndex = random.nextInt(optionCount);

          final options = List.generate(optionCount, (idx) {
            return MockOption(id: 'opt_$idx', isCorrect: idx == correctIndex);
          });

          // For each option, verify consistency
          for (final option in options) {
            final result = determineAnswerCorrectness(option.id, options);
            expect(
              result,
              option.isCorrect,
              reason: 'Result should match option.isCorrect for ${option.id}',
            );
          }
        }
      },
    );
  });
}
