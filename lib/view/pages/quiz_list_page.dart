import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/quiz.dart';
import '../providers/quiz_provider.dart';
import 'create_quiz_page.dart';
import 'quiz_detail_page.dart';

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Квизы'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quizProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ошибка: ${quizProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => quizProvider.loadQuizzes(), child: const Text('Повторить')),
                ],
              ),
            );
          }

          if (quizProvider.quizzes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Нет созданных квизов', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Нажмите + чтобы создать первый квиз', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizProvider.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizProvider.quizzes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.quiz),
                  title: Text(quiz.name),
                  subtitle: Text('Вопросов: ${quiz.questions.length}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _navigateToCreateQuiz(context, quiz);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, quiz);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                      const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuizDetailPage(quiz: quiz)));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateQuiz(context, null),
        tooltip: 'Создать квиз',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateQuiz(BuildContext context, Quiz? quiz) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuizPage(quiz: quiz)));
  }

  void _showDeleteDialog(BuildContext context, Quiz quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить квиз'),
        content: Text('Вы уверены, что хотите удалить квиз "${quiz.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<QuizProvider>().deleteQuiz(quiz.id);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
