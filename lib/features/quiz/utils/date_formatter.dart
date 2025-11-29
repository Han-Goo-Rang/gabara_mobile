// lib/features/quiz/utils/date_formatter.dart

/// Utility class for formatting dates in quiz feature
class QuizDateFormatter {
  /// Format DateTime to "DD/MM/YYYY, HH.MM.SS"
  /// DateTime dari Supabase sudah dalam local time setelah parsing ISO8601
  /// **Validates: Requirements 3.3, 3.4**
  static String formatQuizDate(DateTime? date) {
    if (date == null) return '-';

    // DateTime sudah dalam local time, jangan panggil toLocal() lagi
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');

    return '$day/$month/$year, $hour.$minute.$second';
  }

  /// Format DateTime to "HH:MM" for time picker display
  /// DateTime dari Supabase sudah dalam local time setelah parsing ISO8601
  static String formatQuizTime(DateTime? date) {
    if (date == null) return '00:00';

    // DateTime sudah dalam local time, jangan panggil toLocal() lagi
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  /// Format DateTime to "DD MMM YYYY, HH:MM" for card display
  /// DateTime dari Supabase sudah dalam local time setelah parsing ISO8601
  /// Example: "18 Nov 2025, 10:00"
  static String formatQuizDateShort(DateTime? date) {
    if (date == null) return '-';

    // DateTime sudah dalam local time, jangan panggil toLocal() lagi
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = date.day.toString();
    final month = months[date.month - 1];
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  /// Format duration in minutes to display string
  /// Example: "5 menit"
  static String formatDuration(int minutes) {
    return '$minutes menit';
  }

  /// Format attempts count
  /// Example: "5x"
  static String formatAttempts(int attempts) {
    return '${attempts}x';
  }

  /// Format question count
  /// Example: "6 soal"
  static String formatQuestionCount(int count) {
    return '$count soal';
  }
}
