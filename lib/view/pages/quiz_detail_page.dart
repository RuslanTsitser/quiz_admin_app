import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/quiz.dart';

class QuizDetailPage extends StatelessWidget {
  final Quiz quiz;

  const QuizDetailPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => _showShareDialog(context),
            icon: const Icon(Icons.share),
            tooltip: 'Поделиться квизом',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quiz.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Вопросов: ${quiz.questions.length}', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          Expanded(
            child: quiz.questions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Нет вопросов', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = quiz.questions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(radius: 16, child: Text('${index + 1}')),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(question.questionText, style: Theme.of(context).textTheme.titleMedium),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text('Варианты ответов:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ...question.options.asMap().entries.map((entry) {
                                final optionIndex = entry.key;
                                final option = entry.value;
                                final isCorrect = question.correctAnswerIndexes.contains(optionIndex);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    border: Border.all(color: isCorrect ? Colors.green : Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: isCorrect ? Colors.green : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(option)),
                                      if (isCorrect)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Правильный',
                                            style: TextStyle(
                                              color: Colors.white,
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
                      );
                    },
                  ),
          ),
        ],
      ),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(quizUrl, style: const TextStyle(fontFamily: 'monospace')),
            ),
            const SizedBox(height: 12),
            const Text(
              'Скопируйте ссылку и отправьте пользователям для прохождения квиза.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: quizUrl));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Ссылка скопирована в буфер обмена')));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Копировать'),
          ),
        ],
      ),
    );
  }
}
