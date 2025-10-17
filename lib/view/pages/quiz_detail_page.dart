import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/quiz.dart';

class QuizDetailPage extends StatelessWidget {
  final Quiz quiz;

  const QuizDetailPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.name),
        actions: [
          IconButton(
            onPressed: () => _showShareDialog(context),
            icon: const Icon(Icons.share),
            tooltip: 'Поделиться квизом',
          ),
        ],
      ),
      body: quiz.questions.isEmpty ? const EmptyQuestionsDetailState() : QuestionsDetailList(questions: quiz.questions),
    );
  }

  void _showShareDialog(BuildContext context) {
    final quizUrl = 'https://quiz-app-hello-world.web.app/${quiz.id}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поделиться квизом'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ссылка на квиз "${quiz.name}":'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: quizUrl),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: quizUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ссылка скопирована в буфер обмена'), backgroundColor: Colors.green),
                    );
                  },
                  child: const Text('Копировать'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Скопируйте ссылку и отправьте пользователям для прохождения квиза.',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть'))],
      ),
    );
  }
}

class EmptyQuestionsDetailState extends StatelessWidget {
  const EmptyQuestionsDetailState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text('Нет вопросов', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'В этом квизе пока нет вопросов',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionsDetailList extends StatelessWidget {
  final List<Question> questions;

  const QuestionsDetailList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return QuestionDetailCard(question: question, index: index);
      },
    );
  }
}

class QuestionDetailCard extends StatelessWidget {
  final Question question;
  final int index;

  const QuestionDetailCard({super.key, required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      question.questionText,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Варианты ответов',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isCorrect = question.correctAnswerIndexes.contains(optionIndex);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: isCorrect
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.outline,
                      width: isCorrect ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCorrect
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isCorrect
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isCorrect)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Правильный',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
