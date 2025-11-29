// lib/features/quiz/presentation/widgets/question_result_card.dart
// Requirements: 6.2, 6.3, 6.4

import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/quiz_attempt_model.dart';
import '../../domain/entities/quiz_entity.dart';

class QuestionResultCard extends StatelessWidget {
  final int questionNumber;
  final QuestionModel question;
  final StudentAnswerModel? studentAnswer;

  const QuestionResultCard({
    super.key,
    required this.questionNumber,
    required this.question,
    this.studentAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOptionId = studentAnswer?.selectedOptionId;
    final isCorrect = studentAnswer?.isCorrect ?? false;

    // Find selected option and correct option
    OptionEntity? selectedOption;
    if (selectedOptionId != null) {
      try {
        selectedOption = question.options.firstWhere(
          (o) => o.id == selectedOptionId,
        );
      } catch (e) {
        selectedOption = null;
      }
    }

    OptionEntity? correctOption;
    try {
      correctOption = question.options.firstWhere((o) => o.isCorrect);
    } catch (e) {
      // If no correct option found, use first option as fallback
      correctOption = question.options.isNotEmpty
          ? question.options.first
          : null;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal $questionNumber',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                question.questionType == 'multiple_choice'
                    ? 'pilihan_ganda'
                    : 'benar_salah',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Student's answer section
          const Text(
            'Jawaban',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Text(
              selectedOption?.text ?? 'Tidak dijawab',
              style: TextStyle(
                fontSize: 14,
                color: selectedOption != null ? Colors.black87 : Colors.grey,
                fontStyle: selectedOption != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Correct answer section
          if (correctOption != null) ...[
            const Text(
              'Kunci Jawaban',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Text(
                correctOption.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Options list with indicators
          const Text(
            'Opsi',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final letter = String.fromCharCode(65 + index);
            final isSelected = option.id == selectedOptionId;
            final isCorrectOption = option.isCorrect;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getOptionBackgroundColor(isSelected, isCorrectOption),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getOptionBorderColor(isSelected, isCorrectOption),
                    width: (isSelected || isCorrectOption) ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$letter. ${option.text}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getOptionTextColor(
                            isSelected,
                            isCorrectOption,
                          ),
                          fontWeight: (isSelected || isCorrectOption)
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrectOption
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Dipilih',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isCorrectOption
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    if (isCorrectOption && !isSelected)
                      Text(
                        '(Kunci)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (isCorrectOption && isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Benar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getOptionBackgroundColor(bool isSelected, bool isCorrect) {
    if (isCorrect) {
      return Colors.green.shade50;
    }
    if (isSelected && !isCorrect) {
      return Colors.red.shade50;
    }
    return Colors.white;
  }

  Color _getOptionBorderColor(bool isSelected, bool isCorrect) {
    if (isCorrect) {
      return Colors.green;
    }
    if (isSelected && !isCorrect) {
      return Colors.red;
    }
    return Colors.grey.shade300;
  }

  Color _getOptionTextColor(bool isSelected, bool isCorrect) {
    if (isCorrect) {
      return Colors.green.shade700;
    }
    if (isSelected && !isCorrect) {
      return Colors.red.shade700;
    }
    return Colors.black87;
  }
}
