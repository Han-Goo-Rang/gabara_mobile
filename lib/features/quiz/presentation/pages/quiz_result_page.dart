// lib/features/quiz/presentation/pages/quiz_result_page.dart
import 'package:flutter/material.dart';
import '../../domain/entities/quiz_entity.dart';

class QuizResultPage extends StatelessWidget {
  final QuizEntity quiz;
  final Map<String, String> answers; // questionId -> selectedOptionId

  const QuizResultPage({super.key, required this.quiz, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Kuis')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Quiz: ${quiz.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: quiz.questions.map((q) {
                  final qid = q.id;
                  final qtext = q.question;
                  final selectedId = answers[qid];
                  final options = q.options;

                  String selectedText = selectedId == null
                      ? 'Belum memilih'
                      : '';
                  for (final o in options) {
                    if (o.id == selectedId) {
                      selectedText = o.text;
                      break;
                    }
                  }

                  return Card(
                    child: ListTile(
                      title: Text(qtext),
                      subtitle: Text('Jawaban: $selectedText'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
