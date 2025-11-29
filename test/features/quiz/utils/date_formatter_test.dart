// test/features/quiz/utils/date_formatter_test.dart
import 'dart:math';
import 'package:test/test.dart';
import 'package:gabara_mobile/features/quiz/utils/date_formatter.dart';

void main() {
  group('QuizDateFormatter.formatQuizDate', () {
    /// **Feature: quiz-mentor-feature, Property 9: Date formatting consistency**
    /// *For any* DateTime value, the formatted string SHALL follow
    /// the pattern "DD/MM/YYYY, HH.MM.SS".
    /// **Validates: Requirements 3.3, 3.4**
    test(
      'Property 9: Format matches DD/MM/YYYY, HH.MM.SS pattern (100 iterations)',
      () {
        final random = Random(42);
        final pattern = RegExp(r'^\d{2}/\d{2}/\d{4}, \d{2}\.\d{2}\.\d{2}$');

        for (var i = 0; i < 100; i++) {
          // Generate random date
          final year = 2020 + random.nextInt(10);
          final month = 1 + random.nextInt(12);
          final day = 1 + random.nextInt(28);
          final hour = random.nextInt(24);
          final minute = random.nextInt(60);
          final second = random.nextInt(60);

          final date = DateTime(year, month, day, hour, minute, second);
          final formatted = QuizDateFormatter.formatQuizDate(date);

          expect(
            pattern.hasMatch(formatted),
            isTrue,
            reason:
                'Formatted date "$formatted" should match pattern at iteration $i',
          );

          // Verify values are correct
          final parts = formatted.split(', ');
          final dateParts = parts[0].split('/');
          final timeParts = parts[1].split('.');

          expect(
            int.parse(dateParts[0]),
            equals(day),
            reason: 'Day should be $day at iteration $i',
          );
          expect(
            int.parse(dateParts[1]),
            equals(month),
            reason: 'Month should be $month at iteration $i',
          );
          expect(
            int.parse(dateParts[2]),
            equals(year),
            reason: 'Year should be $year at iteration $i',
          );
          expect(
            int.parse(timeParts[0]),
            equals(hour),
            reason: 'Hour should be $hour at iteration $i',
          );
          expect(
            int.parse(timeParts[1]),
            equals(minute),
            reason: 'Minute should be $minute at iteration $i',
          );
          expect(
            int.parse(timeParts[2]),
            equals(second),
            reason: 'Second should be $second at iteration $i',
          );
        }
      },
    );

    test('Returns "-" for null date', () {
      expect(QuizDateFormatter.formatQuizDate(null), equals('-'));
    });

    test('Pads single digit values with zero', () {
      final date = DateTime(2025, 1, 5, 9, 3, 7);
      expect(
        QuizDateFormatter.formatQuizDate(date),
        equals('05/01/2025, 09.03.07'),
      );
    });
  });

  group('QuizDateFormatter.formatQuizTime', () {
    test('Formats time as HH:MM', () {
      final date = DateTime(2025, 11, 18, 10, 30);
      expect(QuizDateFormatter.formatQuizTime(date), equals('10:30'));
    });

    test('Pads single digit values', () {
      final date = DateTime(2025, 11, 18, 9, 5);
      expect(QuizDateFormatter.formatQuizTime(date), equals('09:05'));
    });

    test('Returns "00:00" for null', () {
      expect(QuizDateFormatter.formatQuizTime(null), equals('00:00'));
    });
  });

  group('QuizDateFormatter.formatQuizDateShort', () {
    test('Formats date as DD MMM YYYY, HH:MM', () {
      final date = DateTime(2025, 11, 18, 10, 0);
      expect(
        QuizDateFormatter.formatQuizDateShort(date),
        equals('18 Nov 2025, 10:00'),
      );
    });

    test('Uses Indonesian month names', () {
      expect(
        QuizDateFormatter.formatQuizDateShort(DateTime(2025, 5, 1, 0, 0)),
        contains('Mei'),
      );
      expect(
        QuizDateFormatter.formatQuizDateShort(DateTime(2025, 8, 1, 0, 0)),
        contains('Agu'),
      );
      expect(
        QuizDateFormatter.formatQuizDateShort(DateTime(2025, 10, 1, 0, 0)),
        contains('Okt'),
      );
      expect(
        QuizDateFormatter.formatQuizDateShort(DateTime(2025, 12, 1, 0, 0)),
        contains('Des'),
      );
    });

    test('Returns "-" for null', () {
      expect(QuizDateFormatter.formatQuizDateShort(null), equals('-'));
    });
  });

  group('QuizDateFormatter.formatDuration', () {
    test('Formats duration with "menit" suffix', () {
      expect(QuizDateFormatter.formatDuration(5), equals('5 menit'));
      expect(QuizDateFormatter.formatDuration(60), equals('60 menit'));
      expect(QuizDateFormatter.formatDuration(0), equals('0 menit'));
    });
  });

  group('QuizDateFormatter.formatAttempts', () {
    test('Formats attempts with "x" suffix', () {
      expect(QuizDateFormatter.formatAttempts(1), equals('1x'));
      expect(QuizDateFormatter.formatAttempts(5), equals('5x'));
      expect(QuizDateFormatter.formatAttempts(10), equals('10x'));
    });
  });

  group('QuizDateFormatter.formatQuestionCount', () {
    test('Formats question count with "soal" suffix', () {
      expect(QuizDateFormatter.formatQuestionCount(1), equals('1 soal'));
      expect(QuizDateFormatter.formatQuestionCount(6), equals('6 soal'));
      expect(QuizDateFormatter.formatQuestionCount(0), equals('0 soal'));
    });
  });
}
