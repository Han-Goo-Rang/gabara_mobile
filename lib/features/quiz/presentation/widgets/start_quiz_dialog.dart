// lib/features/quiz/presentation/widgets/start_quiz_dialog.dart
// Requirements: 3.1, 3.2, 3.3, 3.4

import 'package:flutter/material.dart';
import '../../utils/date_formatter.dart';

class StartQuizDialog extends StatelessWidget {
  final String quizTitle;
  final int duration;
  final DateTime? openAt;
  final DateTime? closeAt;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final bool isResume;

  const StartQuizDialog({
    super.key,
    required this.quizTitle,
    required this.duration,
    this.openAt,
    this.closeAt,
    required this.onStart,
    required this.onCancel,
    this.isResume = false,
  });

  @override
  Widget build(BuildContext context) {
    final headerText = isResume ? 'Lanjutkan Quiz' : 'Mulai Mengerjakan Quiz';
    final buttonText = isResume ? 'Lanjutkan Sekarang' : 'Mulai Sekarang';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headerText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onCancel,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: isResume
                        ? 'Kamu akan melanjutkan mengerjakan '
                        : 'Kamu akan mengerjakan ',
                  ),
                  TextSpan(
                    text: quizTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: isResume
                        ? '. Waktu akan dilanjutkan dari sisa waktu sebelumnya.'
                        : '. Waktu akan langsung berjalan setelah kamu menekan tombol ',
                  ),
                  if (!isResume)
                    TextSpan(
                      text: buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (!isResume) const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 16),

            // Quiz info
            _buildInfoRow(
              'Durasi:',
              QuizDateFormatter.formatDuration(duration),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Dibuka:', QuizDateFormatter.formatQuizDate(openAt)),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Ditutup:',
              QuizDateFormatter.formatQuizDate(closeAt),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isResume ? Colors.orange : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isResume ? 'Lanjutkan Sekarang' : 'Mulai Sekarang',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
