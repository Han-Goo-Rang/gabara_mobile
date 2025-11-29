// lib/features/quiz/presentation/pages/student_quiz_taking_page.dart
// Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 5.1, 5.2, 5.3, 5.4, 5.5

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_quiz_provider.dart';
import '../widgets/submit_confirmation_dialog.dart';
import '../widgets/question_navigation_grid.dart';
import 'student_quiz_result_page.dart';

class StudentQuizTakingPage extends StatelessWidget {
  const StudentQuizTakingPage({super.key});

  void _showSubmitDialog(BuildContext context) {
    final provider = context.read<StudentQuizProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SubmitConfirmationDialog(
        answeredCount: provider.answeredCount,
        totalQuestions: provider.totalQuestions,
        onSubmit: () async {
          Navigator.pop(context);
          final success = await provider.submitQuizAttempt();
          if (success && context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: provider,
                  child: const StudentQuizResultPage(),
                ),
              ),
            );
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          automaticallyImplyLeading: false,
          title: Consumer<StudentQuizProvider>(
            builder: (context, provider, _) => Text(
              'Mengerjakan: ${provider.currentQuiz?.title ?? 'Quiz'}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Consumer<StudentQuizProvider>(
          builder: (context, provider, child) {
            if (provider.isSubmitting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Mengirim jawaban...'),
                  ],
                ),
              );
            }

            final question = provider.currentQuestion;
            if (question == null) {
              return const Center(child: Text('Soal tidak ditemukan'));
            }

            return Column(
              children: [
                // Timer header
                _buildTimerHeader(provider),

                // Question content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question card
                        _buildQuestionCard(provider, question),
                        const SizedBox(height: 16),

                        // Navigation buttons
                        _buildNavigationButtons(context, provider),
                        const SizedBox(height: 16),

                        // Question grid
                        _buildQuestionGrid(provider),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimerHeader(StudentQuizProvider provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text('Sisa waktu: ', style: TextStyle(fontSize: 14)),
          Text(
            provider.formattedTimer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: provider.remainingSeconds < 60 ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(StudentQuizProvider provider, dynamic question) {
    final selectedOptionId = provider.currentAnswers[question.id];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          Text(
            'Soal ${provider.currentQuestionIndex + 1} dari ${provider.totalQuestions}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),

          // Question text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedOptionId == option.id;
            final letter = String.fromCharCode(65 + index as int); // A, B, C, D

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => provider.selectAnswer(question.id, option.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radio indicator
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 12, top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      // Option text
                      Expanded(
                        child: Text(
                          '$letter. ${option.text}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.blue.shade700
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    StudentQuizProvider provider,
  ) {
    final isFirst = provider.currentQuestionIndex == 0;
    final isLast = provider.currentQuestionIndex == provider.totalQuestions - 1;

    return Row(
      children: [
        // Previous button
        Expanded(
          child: ElevatedButton(
            onPressed: isFirst ? null : provider.previousQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Sebelumnya',
              style: TextStyle(
                color: isFirst ? Colors.grey.shade600 : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Next/Submit button
        Expanded(
          child: ElevatedButton(
            onPressed: isLast
                ? () => _showSubmitDialog(context)
                : provider.nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isLast ? 'Selesai' : 'Berikutnya',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionGrid(StudentQuizProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Soal',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          QuestionNavigationGrid(
            totalQuestions: provider.totalQuestions,
            currentIndex: provider.currentQuestionIndex,
            isAnswered: provider.isQuestionAnswered,
            onTap: provider.goToQuestion,
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Keluar dari Quiz?'),
        content: const Text(
          'Jika keluar, jawaban yang sudah diisi akan hilang. Apakah Anda yakin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
