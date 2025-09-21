import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  static const String _quizzesKey = 'quizzes';

  @override
  Future<List<Quiz>> getAllQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final quizzesJson = prefs.getStringList(_quizzesKey) ?? [];

    return quizzesJson.map((jsonString) {
      final json = jsonDecode(jsonString);
      return Quiz.fromJson(json);
    }).toList();
  }

  @override
  Future<Quiz?> getQuizById(String id) async {
    final quizzes = await getAllQuizzes();
    try {
      return quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> createQuiz(Quiz quiz) async {
    final prefs = await SharedPreferences.getInstance();
    final quizzes = await getAllQuizzes();

    final newQuiz = quiz.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    quizzes.add(newQuiz);

    final quizzesJson = quizzes.map((q) => jsonEncode(q.toJson())).toList();
    await prefs.setStringList(_quizzesKey, quizzesJson);

    return newQuiz.id;
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    final prefs = await SharedPreferences.getInstance();
    final quizzes = await getAllQuizzes();

    final index = quizzes.indexWhere((q) => q.id == quiz.id);
    if (index != -1) {
      final updatedQuiz = quiz.copyWith(updatedAt: DateTime.now());
      quizzes[index] = updatedQuiz;

      final quizzesJson = quizzes.map((q) => jsonEncode(q.toJson())).toList();
      await prefs.setStringList(_quizzesKey, quizzesJson);
    }
  }

  @override
  Future<void> deleteQuiz(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final quizzes = await getAllQuizzes();

    quizzes.removeWhere((quiz) => quiz.id == id);

    final quizzesJson = quizzes.map((q) => jsonEncode(q.toJson())).toList();
    await prefs.setStringList(_quizzesKey, quizzesJson);
  }
}
