// lib/features/quiz/data/services/quiz_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';

class QuizService {
  final SupabaseClient supabaseClient;

  QuizService(this.supabaseClient);

  /// Fetch all quizzes created by the current mentor
  Future<List<QuizModel>> fetchQuizzesByMentor() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return [];

      final response = await supabaseClient
          .from('quizzes')
          .select('''
            id, class_id, title, description, duration_minutes, 
            max_attempts, is_active, open_at, close_at, 
            created_by, created_at, updated_at,
            questions(
              id, quiz_id, question_text, question_type, order_index,
              options(id, question_id, option_text, is_correct, order_index)
            )
          ''')
          .eq('created_by', user.id)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => QuizModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetchQuizzesByMentor: $e');
      return [];
    }
  }

  /// Fetch quizzes for a specific class
  Future<List<QuizModel>> fetchQuizzesByClass(String classId) async {
    try {
      final response = await supabaseClient
          .from('quizzes')
          .select('''
            id, class_id, title, description, duration_minutes, 
            max_attempts, is_active, open_at, close_at, 
            created_by, created_at, updated_at,
            questions(
              id, quiz_id, question_text, question_type, order_index,
              options(id, question_id, option_text, is_correct, order_index)
            )
          ''')
          .eq('class_id', classId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => QuizModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetchQuizzesByClass: $e');
      return [];
    }
  }

  /// Fetch a single quiz by ID with all questions and options
  Future<QuizModel?> fetchQuizById(String quizId) async {
    try {
      final response = await supabaseClient
          .from('quizzes')
          .select('''
            id, class_id, title, description, duration_minutes, 
            max_attempts, is_active, open_at, close_at, 
            created_by, created_at, updated_at,
            questions(
              id, quiz_id, question_text, question_type, order_index,
              options(id, question_id, option_text, is_correct, order_index)
            )
          ''')
          .eq('id', quizId)
          .maybeSingle();

      if (response == null) return null;
      return QuizModel.fromJson(response);
    } catch (e) {
      debugPrint('Error fetchQuizById: $e');
      return null;
    }
  }

  /// Create a new quiz with questions and options
  Future<QuizModel?> createQuiz(QuizModel quiz) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw Exception('User tidak login');

      // Insert quiz first
      // Konversi waktu lokal ke UTC sebelum menyimpan ke Supabase
      final quizResponse = await supabaseClient
          .from('quizzes')
          .insert({
            'class_id': quiz.classId,
            'title': quiz.title,
            'description': quiz.description,
            'duration_minutes': quiz.durationMinutes,
            'max_attempts': quiz.attemptsAllowed,
            'is_active': quiz.isPublished,
            'open_at': quiz.openAt?.toUtc().toIso8601String(),
            'close_at': quiz.closeAt?.toUtc().toIso8601String(),
            'created_by': user.id,
          })
          .select()
          .single();

      final quizId = quizResponse['id'] as String;

      // Insert questions
      for (var i = 0; i < quiz.questionModels.length; i++) {
        final question = quiz.questionModels[i];

        final questionResponse = await supabaseClient
            .from('questions')
            .insert({
              'quiz_id': quizId,
              'question_text': question.question,
              'question_type': question.questionType,
              'order_index': i,
            })
            .select()
            .single();

        final questionId = questionResponse['id'] as String;

        // Insert options for this question
        for (var j = 0; j < question.optionModels.length; j++) {
          final option = question.optionModels[j];

          await supabaseClient.from('options').insert({
            'question_id': questionId,
            'option_text': option.text,
            'is_correct': option.isCorrect,
            'order_index': j,
          });
        }
      }

      // Fetch and return the complete quiz
      return await fetchQuizById(quizId);
    } catch (e) {
      debugPrint('Error createQuiz: $e');
      rethrow;
    }
  }

  /// Update quiz metadata and questions
  Future<QuizModel?> updateQuiz(QuizModel quiz) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw Exception('User tidak login');

      // Update quiz metadata
      // Konversi waktu lokal ke UTC sebelum menyimpan ke Supabase
      await supabaseClient
          .from('quizzes')
          .update({
            'class_id': quiz.classId,
            'title': quiz.title,
            'description': quiz.description,
            'duration_minutes': quiz.durationMinutes,
            'max_attempts': quiz.attemptsAllowed,
            'is_active': quiz.isPublished,
            'open_at': quiz.openAt?.toUtc().toIso8601String(),
            'close_at': quiz.closeAt?.toUtc().toIso8601String(),
          })
          .eq('id', quiz.id)
          .eq('created_by', user.id);

      // Update questions and options
      for (var i = 0; i < quiz.questionModels.length; i++) {
        final question = quiz.questionModels[i];

        // Update question
        await supabaseClient
            .from('questions')
            .update({
              'question_text': question.question,
              'question_type': question.questionType,
              'order_index': i,
            })
            .eq('id', question.id);

        // Delete existing options for this question
        await supabaseClient
            .from('options')
            .delete()
            .eq('question_id', question.id);

        // Insert updated options
        for (var j = 0; j < question.optionModels.length; j++) {
          final option = question.optionModels[j];

          await supabaseClient.from('options').insert({
            'question_id': question.id,
            'option_text': option.text,
            'is_correct': option.isCorrect,
            'order_index': j,
          });
        }
      }

      return await fetchQuizById(quiz.id);
    } catch (e) {
      debugPrint('Error updateQuiz: $e');
      rethrow;
    }
  }

  /// Delete a quiz (cascade deletes questions and options)
  Future<void> deleteQuiz(String quizId) async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) throw Exception('User tidak login');

      // Verify ownership
      final existingQuiz = await supabaseClient
          .from('quizzes')
          .select('id, created_by, title')
          .eq('id', quizId)
          .maybeSingle();

      if (existingQuiz == null) {
        throw Exception('Quiz tidak ditemukan');
      }

      if (existingQuiz['created_by'] != user.id) {
        throw Exception('Anda bukan pemilik quiz ini');
      }

      // Delete quiz (cascade will delete questions and options)
      await supabaseClient.from('quizzes').delete().eq('id', quizId);

      debugPrint('Quiz "${existingQuiz['title']}" deleted successfully');
    } catch (e) {
      debugPrint('Error deleteQuiz: $e');
      rethrow;
    }
  }

  /// Get classes owned by current mentor (for dropdown)
  Future<List<Map<String, dynamic>>> getMyClasses() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return [];

      final response = await supabaseClient
          .from('classes')
          .select('id, name')
          .eq('tutor_id', user.id)
          .eq('is_active', true)
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getMyClasses: $e');
      return [];
    }
  }
}
