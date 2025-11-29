// lib/features/quiz/presentation/providers/quiz_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';
import '../../data/services/quiz_service.dart';
import '../../domain/validators/quiz_validator.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService quizService;

  QuizProvider(this.quizService);

  // State variables
  List<QuizModel> _quizzes = [];
  QuizModel? _selectedQuiz;
  List<Map<String, dynamic>> _myClasses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Builder state for creating/editing quiz
  List<QuestionModel> _builderQuestions = [];

  // Getters
  List<QuizModel> get quizzes => _quizzes;
  QuizModel? get selectedQuiz => _selectedQuiz;
  List<Map<String, dynamic>> get myClasses => _myClasses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<QuestionModel> get builderQuestions => _builderQuestions;

  /// Fetch all quizzes created by current mentor
  Future<void> fetchMyQuizzes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _quizzes = await quizService.fetchQuizzesByMentor();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch quiz detail by ID
  Future<void> fetchQuizDetail(String quizId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedQuiz = await quizService.fetchQuizById(quizId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch classes owned by mentor (for dropdown)
  Future<void> fetchMyClasses() async {
    try {
      _myClasses = await quizService.getMyClasses();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching classes: $e');
    }
  }

  /// Create a new quiz with validation
  Future<bool> createQuiz(QuizModel quiz) async {
    // Validate quiz before saving
    final validation = QuizValidator.validateQuiz(quiz);
    if (!validation.isValid) {
      _errorMessage = validation.errorMessage;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await quizService.createQuiz(quiz);
      await fetchMyQuizzes();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update quiz metadata with validation
  Future<bool> updateQuiz(QuizModel quiz) async {
    // Validate quiz before saving
    final validation = QuizValidator.validateQuiz(quiz);
    if (!validation.isValid) {
      _errorMessage = validation.errorMessage;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await quizService.updateQuiz(quiz);
      await fetchMyQuizzes();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a quiz
  Future<bool> deleteQuiz(String quizId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await quizService.deleteQuiz(quizId);
      await fetchMyQuizzes();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================
  // Question Builder State Management
  // ============================================

  /// Initialize builder with empty question
  void initBuilder() {
    _builderQuestions = [_createEmptyQuestion(0)];
    notifyListeners();
  }

  /// Initialize builder with existing questions (for editing)
  void initBuilderWithQuestions(List<QuestionModel> questions) {
    _builderQuestions = List.from(questions);
    notifyListeners();
  }

  /// Clear builder state
  void clearBuilder() {
    _builderQuestions = [];
    notifyListeners();
  }

  /// Add a new question to builder
  /// **Validates: Requirements 2.6**
  void addQuestion() {
    final newQuestion = _createEmptyQuestion(_builderQuestions.length);
    _builderQuestions.add(newQuestion);
    notifyListeners();
  }

  /// Remove question at index
  /// **Validates: Requirements 2.7**
  void removeQuestion(int index) {
    if (index >= 0 && index < _builderQuestions.length) {
      _builderQuestions.removeAt(index);
      // Re-index remaining questions
      for (var i = 0; i < _builderQuestions.length; i++) {
        _builderQuestions[i] = _builderQuestions[i].copyWith(orderIndex: i);
      }
      notifyListeners();
    }
  }

  /// Update question at index
  void updateQuestion(int index, QuestionModel question) {
    if (index >= 0 && index < _builderQuestions.length) {
      _builderQuestions[index] = question;
      notifyListeners();
    }
  }

  // ============================================
  // Option Management
  // ============================================

  /// Add option to question at index
  /// **Validates: Requirements 5.2**
  void addOption(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      final question = _builderQuestions[questionIndex];
      final newOption = OptionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: '',
        isCorrect: false,
        orderIndex: question.optionModels.length,
      );

      final updatedOptions = [...question.optionModels, newOption];
      _builderQuestions[questionIndex] = question.copyWith(
        options: updatedOptions,
      );
      notifyListeners();
    }
  }

  /// Remove option from question
  /// **Validates: Requirements 5.3**
  void removeOption(int questionIndex, int optionIndex) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      final question = _builderQuestions[questionIndex];
      if (optionIndex >= 0 && optionIndex < question.optionModels.length) {
        final updatedOptions = List<OptionModel>.from(question.optionModels);
        updatedOptions.removeAt(optionIndex);

        // Re-index remaining options
        for (var i = 0; i < updatedOptions.length; i++) {
          updatedOptions[i] = updatedOptions[i].copyWith(orderIndex: i);
        }

        _builderQuestions[questionIndex] = question.copyWith(
          options: updatedOptions,
        );
        notifyListeners();
      }
    }
  }

  /// Set correct option for question (ensures only one is correct)
  /// **Validates: Requirements 5.4**
  void setCorrectOption(int questionIndex, int optionIndex) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      final question = _builderQuestions[questionIndex];
      if (optionIndex >= 0 && optionIndex < question.optionModels.length) {
        final updatedOptions = question.optionModels.map((option) {
          final index = question.optionModels.indexOf(option);
          return option.copyWith(isCorrect: index == optionIndex);
        }).toList();

        _builderQuestions[questionIndex] = question.copyWith(
          options: updatedOptions,
        );
        notifyListeners();
      }
    }
  }

  /// Update option text
  void updateOptionText(int questionIndex, int optionIndex, String text) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      final question = _builderQuestions[questionIndex];
      if (optionIndex >= 0 && optionIndex < question.optionModels.length) {
        final updatedOptions = List<OptionModel>.from(question.optionModels);
        updatedOptions[optionIndex] = updatedOptions[optionIndex].copyWith(
          text: text,
        );

        _builderQuestions[questionIndex] = question.copyWith(
          options: updatedOptions,
        );
        notifyListeners();
      }
    }
  }

  /// Change question type (multiple_choice or true_false)
  void changeQuestionType(int questionIndex, String newType) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      final question = _builderQuestions[questionIndex];

      List<OptionModel> newOptions;
      if (newType == 'true_false') {
        // Replace with Benar/Salah options
        newOptions = [
          OptionModel(
            id: '${questionIndex}_true',
            text: 'Benar',
            isCorrect: false,
            orderIndex: 0,
          ),
          OptionModel(
            id: '${questionIndex}_false',
            text: 'Salah',
            isCorrect: false,
            orderIndex: 1,
          ),
        ];
      } else {
        // Restore default multiple choice options
        newOptions = [
          OptionModel(
            id: '${questionIndex}_a',
            text: '',
            isCorrect: false,
            orderIndex: 0,
          ),
          OptionModel(
            id: '${questionIndex}_b',
            text: '',
            isCorrect: false,
            orderIndex: 1,
          ),
        ];
      }

      _builderQuestions[questionIndex] = question.copyWith(
        questionType: newType,
        options: newOptions,
      );
      notifyListeners();
    }
  }

  /// Update question text
  void updateQuestionText(int questionIndex, String text) {
    if (questionIndex >= 0 && questionIndex < _builderQuestions.length) {
      _builderQuestions[questionIndex] = _builderQuestions[questionIndex]
          .copyWith(question: text);
      notifyListeners();
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  QuestionModel _createEmptyQuestion(int index) {
    return QuestionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: '',
      questionType: 'multiple_choice',
      options: [
        OptionModel(
          id: '${index}_a',
          text: '',
          isCorrect: false,
          orderIndex: 0,
        ),
        OptionModel(
          id: '${index}_b',
          text: '',
          isCorrect: false,
          orderIndex: 1,
        ),
      ],
      orderIndex: index,
    );
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear selected quiz
  void clearSelectedQuiz() {
    _selectedQuiz = null;
    notifyListeners();
  }
}
