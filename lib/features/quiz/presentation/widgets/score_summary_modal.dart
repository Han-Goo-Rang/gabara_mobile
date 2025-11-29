// lib/features/quiz/presentation/widgets/score_summary_modal.dart
// Requirements: 7.1, 7.2, 7.3, 7.4, 7.5

import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/quiz_attempt_model.dart';

class ScoreSummaryModal extends StatelessWidget {
  final String quizTitle;
  final int score;
  final List<QuestionModel> questions;
  final List<StudentAnswerModel> answers;
  final VoidCallback onClose;

  const ScoreSummaryModal({
    super.key,
    required this.quizTitle,
    required this.score,
    required this.questions,
    required this.answers,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ringkasan Skor: $quizTitle',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Score display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text('Skor: ', style: TextStyle(fontSize: 16)),
                  Text(
                    '$score%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(score),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Questions list
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;

                    // Find answer safely without orElse
                    StudentAnswerModel? answer;
                    try {
                      answer = answers.firstWhere(
                        (a) => a.questionId == question.id,
                      );
                    } catch (e) {
                      // No answer found, create empty one
                      answer = StudentAnswerModel(
                        id: '',
                        attemptId: '',
                        questionId: question.id,
                      );
                    }

                    return _buildQuestionSummary(index + 1, question, answer);
                  }).toList(),
                ),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSummary(
    int number,
    QuestionModel question,
    StudentAnswerModel answer,
  ) {
    final selectedOptionId = answer.selectedOptionId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            '$number. ${question.question}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Options
          ...question.options.map((option) {
            final isSelected = option.id == selectedOptionId;
            final isCorrect = option.isCorrect;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getOptionBackground(isSelected, isCorrect),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _getOptionBorder(isSelected, isCorrect),
                  width: isCorrect ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: _getOptionTextColor(isSelected, isCorrect),
                      ),
                    ),
                  ),
                  if (isCorrect)
                    Text(
                      '(Kunci)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getOptionBackground(bool isSelected, bool isCorrect) {
    if (isCorrect) return Colors.green.shade50;
    if (isSelected) return Colors.red.shade50;
    return Colors.white;
  }

  Color _getOptionBorder(bool isSelected, bool isCorrect) {
    if (isCorrect) return Colors.green;
    if (isSelected) return Colors.red.shade300;
    return Colors.grey.shade300;
  }

  Color _getOptionTextColor(bool isSelected, bool isCorrect) {
    if (isCorrect) return Colors.green.shade700;
    if (isSelected) return Colors.red.shade700;
    return Colors.black87;
  }
}
