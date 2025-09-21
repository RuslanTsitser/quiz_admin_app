import 'package:flutter/foundation.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider(this._repository);

  List<Quiz> _quizzes = [];
  bool _isLoading = false;
  String? _error;

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuizzes() async {
    _setLoading(true);
    try {
      _quizzes = await _repository.getAllQuizzes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createQuiz(Quiz quiz) async {
    _setLoading(true);
    try {
      await _repository.createQuiz(quiz);
      await loadQuizzes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateQuiz(Quiz quiz) async {
    _setLoading(true);
    try {
      await _repository.updateQuiz(quiz);
      await loadQuizzes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteQuiz(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteQuiz(id);
      await loadQuizzes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
