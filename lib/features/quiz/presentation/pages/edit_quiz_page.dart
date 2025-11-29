// lib/features/quiz/presentation/pages/edit_quiz_page.dart
// This page is for students to take a quiz (answer questions)
import 'package:flutter/material.dart';
import '../../domain/entities/quiz_entity.dart';
import '../widgets/quiz_option_widget.dart';
import 'quiz_result_page.dart';

class EditQuizPage extends StatefulWidget {
  final QuizEntity quiz;
  const EditQuizPage({super.key, required this.quiz});

  @override
  State<EditQuizPage> createState() => _EditQuizPageState();
}

class _EditQuizPageState extends State<EditQuizPage> {
  final Map<String, String> selectedAnswers = {}; // questionId -> optionId

  void _onSelect(String questionId, String optionId) {
    setState(() {
      selectedAnswers[questionId] = optionId;
    });
  }

  Future<void> _submit() async {
    // TODO: Implement submit to backend when student feature is ready
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QuizResultPage(quiz: widget.quiz, answers: selectedAnswers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(widget.quiz.description),
            const SizedBox(height: 12),
            ...questions.map((q) {
              final questionId = q.id;
              final questionText = q.question;
              final options = q.options;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...options.map((opt) {
                        final optId = opt.id;
                        final optText = opt.text;
                        return QuizOptionWidget(
                          optionId: optId,
                          text: optText,
                          isSelected: selectedAnswers[questionId] == optId,
                          onTap: () => _onSelect(questionId, optId),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedAnswers.isEmpty ? null : _submit,
              child: const Text('Submit Jawaban'),
            ),
          ],
        ),
      ),
    );
  }
}
