import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<List<Quiz>> getAllQuizzes();
  Future<Quiz?> getQuizById(String id);
  Future<String> createQuiz(Quiz quiz);
  Future<void> updateQuiz(Quiz quiz);
  Future<void> deleteQuiz(String id);
}
