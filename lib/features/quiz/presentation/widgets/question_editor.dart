// lib/features/quiz/presentation/widgets/question_editor.dart
import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';

/// Widget for editing a single question in QuizBuilder
/// **Validates: Requirements 2.4, 2.5, 2.7, 5.1, 5.2, 5.3, 5.4**
class QuestionEditor extends StatelessWidget {
  final int index;
  final QuestionModel question;
  final Function(String) onQuestionTextChanged;
  final Function(String) onTypeChanged;
  final VoidCallback onDelete;
  final VoidCallback onAddOption;
  final Function(int) onRemoveOption;
  final Function(int) onSetCorrectOption;
  final Function(int, String) onOptionTextChanged;

  const QuestionEditor({
    super.key,
    required this.index,
    required this.question,
    required this.onQuestionTextChanged,
    required this.onTypeChanged,
    required this.onDelete,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onSetCorrectOption,
    required this.onOptionTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with question number, type dropdown, and delete button
          Row(
            children: [
              Text(
                'Pertanyaan ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Question type dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: question.questionType,
                    items: const [
                      DropdownMenuItem(
                        value: 'multiple_choice',
                        child: Text(
                          'Pilihan Ganda',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'true_false',
                        child: Text(
                          'Benar / Salah',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) onTypeChanged(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              TextButton(
                onPressed: onDelete,
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question text field
          const Text(
            'Pertanyaan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: question.question),
            onChanged: onQuestionTextChanged,
            decoration: InputDecoration(
              hintText: 'Masukkan pertanyaan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Options section
          const Text(
            'Opsi / Jawaban',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          // Options list
          if (question.isTrueFalse)
            _buildTrueFalseOptions()
          else
            _buildMultipleChoiceOptions(),
        ],
      ),
    );
  }

  /// Build True/False options (Benar/Salah)
  Widget _buildTrueFalseOptions() {
    return Column(
      children: [
        for (var i = 0; i < question.optionModels.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: _getCorrectOptionIndex(),
                  onChanged: (value) {
                    if (value != null) onSetCorrectOption(value);
                  },
                  activeColor: Colors.blue,
                ),
                Text(
                  question.optionModels[i].text,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build Multiple Choice options with text inputs
  Widget _buildMultipleChoiceOptions() {
    return Column(
      children: [
        for (var i = 0; i < question.optionModels.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: _getCorrectOptionIndex(),
                  onChanged: (value) {
                    if (value != null) onSetCorrectOption(value);
                  },
                  activeColor: Colors.red,
                ),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: question.optionModels[i].text,
                    ),
                    onChanged: (value) => onOptionTextChanged(i, value),
                    decoration: InputDecoration(
                      hintText: 'Opsi ${String.fromCharCode(65 + i)}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onRemoveOption(i),
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                ),
              ],
            ),
          ),

        // Add option button
        TextButton.icon(
          onPressed: onAddOption,
          icon: const Icon(Icons.add, size: 18, color: Colors.blue),
          label: const Text(
            'Tambah opsi',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  int? _getCorrectOptionIndex() {
    for (var i = 0; i < question.optionModels.length; i++) {
      if (question.optionModels[i].isCorrect) return i;
    }
    return null;
  }
}
