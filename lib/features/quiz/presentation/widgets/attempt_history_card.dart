// lib/features/quiz/presentation/widgets/attempt_history_card.dart
// Requirements: 2.1, 2.2

import 'package:flutter/material.dart';
import '../../data/models/quiz_attempt_model.dart';
import '../../utils/date_formatter.dart';

class AttemptHistoryCard extends StatelessWidget {
  final int attemptNumber;
  final QuizAttemptModel attempt;
  final VoidCallback? onViewResult;

  const AttemptHistoryCard({
    super.key,
    required this.attemptNumber,
    required this.attempt,
    this.onViewResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attempt number and date
          Text(
            'Attempt #$attemptNumber',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            QuizDateFormatter.formatQuizDate(attempt.startedAt),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),

          // Status
          Row(
            children: [
              const Text('Status: ', style: TextStyle(fontSize: 14)),
              Text(
                attempt.isFinished ? 'Selesai' : 'Sedang mengerjakan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: attempt.isFinished ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Answered count
          Text(
            'Jawaban: ${attempt.answeredCount} / ${attempt.totalQuestions}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),

          // Score (if finished)
          if (attempt.isFinished && attempt.score != null)
            Text(
              'Skor: ${attempt.score}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          const SizedBox(height: 12),

          // View result link
          if (attempt.isFinished && onViewResult != null)
            GestureDetector(
              onTap: onViewResult,
              child: const Text(
                'Lihat Penilaian',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
