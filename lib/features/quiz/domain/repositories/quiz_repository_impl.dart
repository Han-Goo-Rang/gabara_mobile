// lib/features/quiz/domain/repositories/quiz_repository_impl.dart
import 'package:gabara_mobile/features/quiz/domain/entities/quiz_entity.dart';
import 'package:gabara_mobile/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:gabara_mobile/features/quiz/data/models/quiz_model.dart';
import 'package:gabara_mobile/features/quiz/data/services/quiz_service.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizService service;
  QuizRepositoryImpl(this.service);

  @override
  Future<List<QuizEntity>> getQuizzes() async {
    try {
      final list = await service.fetchQuizzesByMentor();
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<QuizEntity> getQuizById(String id) async {
    final quiz = await service.fetchQuizById(id);
    if (quiz == null) {
      throw Exception('Quiz not found');
    }
    return quiz;
  }

  @override
  Future<bool> submitAnswers(String quizId, Map<String, String> answers) async {
    // TODO: Implement submit answers when student feature is added
    return false;
  }

  @override
  Future<QuizEntity> createQuiz(QuizEntity quiz) async {
    final quizModel = QuizModel(
      id: quiz.id,
      classId: quiz.classId,
      title: quiz.title,
      description: quiz.description,
      questions: quiz.questions
          .map(
            (q) => QuestionModel(
              id: q.id,
              quizId: q.quizId,
              question: q.question,
              questionType: q.questionType,
              options: q.options
                  .map(
                    (o) => OptionModel(
                      id: o.id,
                      questionId: o.questionId,
                      text: o.text,
                      isCorrect: o.isCorrect,
                      orderIndex: o.orderIndex,
                    ),
                  )
                  .toList(),
              orderIndex: q.orderIndex,
            ),
          )
          .toList(),
      openAt: quiz.openAt,
      closeAt: quiz.closeAt,
      attemptsAllowed: quiz.attemptsAllowed,
      durationMinutes: quiz.durationMinutes,
      status: quiz.status,
      createdBy: quiz.createdBy,
    );

    final created = await service.createQuiz(quizModel);
    if (created == null) {
      throw Exception('Failed to create quiz');
    }
    return created;
  }
}
