import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _quizzesCollection = 'quizzes';

  @override
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      final querySnapshot = await _firestore.collection(_quizzesCollection).get();

      return querySnapshot.docs.map((doc) {
        return Quiz.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Ошибка при получении квизов: $e');
    }
  }

  @override
  Future<Quiz?> getQuizById(String id) async {
    try {
      final doc = await _firestore.collection(_quizzesCollection).doc(id).get();

      if (doc.exists) {
        return Quiz.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Ошибка при получении квиза: $e');
    }
  }

  @override
  Future<String> createQuiz(Quiz quiz) async {
    try {
      final docRef = await _firestore.collection(_quizzesCollection).add(quiz.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Ошибка при создании квиза: $e');
    }
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _firestore.collection(_quizzesCollection).doc(quiz.id).update(quiz.toJson());
    } catch (e) {
      throw Exception('Ошибка при обновлении квиза: $e');
    }
  }

  @override
  Future<void> deleteQuiz(String id) async {
    try {
      await _firestore.collection(_quizzesCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Ошибка при удалении квиза: $e');
    }
  }
}
