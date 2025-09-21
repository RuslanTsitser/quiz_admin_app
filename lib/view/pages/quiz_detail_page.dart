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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1), // Indigo-500
              Color(0xFF8B5CF6), // Violet-500
              Color(0xFFEC4899), // Pink-500
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              QuizDetailHeader(quiz: quiz, onShare: () => _showShareDialog(context)),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC), // Slate-50
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: quiz.questions.isEmpty
                      ? const EmptyQuestionsDetailState()
                      : QuestionsDetailList(questions: quiz.questions),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final quizUrl = 'https://quiz-app-hello-world.web.app/${quiz.id}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.share, color: Color(0xFF10B981), size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Поделиться квизом'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ссылка на квиз "${quiz.name}":', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: SelectableText(
                quizUrl,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: Color(0xFF475569)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: const Color(0xFF3B82F6), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Скопируйте ссылку и отправьте пользователям для прохождения квиза.',
                      style: TextStyle(fontSize: 12, color: const Color(0xFF3B82F6)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B)),
            child: const Text('Закрыть'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: quizUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ссылка скопирована в буфер обмена'),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Копировать'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

class QuizDetailHeader extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onShare;

  const QuizDetailHeader({super.key, required this.quiz, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.name,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${quiz.questions.length} вопросов',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onShare,
              icon: const Icon(Icons.share, color: Colors.white),
              tooltip: 'Поделиться квизом',
            ),
          ),
        ],
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.quiz_outlined, size: 64, color: Colors.white),
            ),
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
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFF8FAFC)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.1),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Color(0xFF6366F1), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      question.questionText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Варианты ответов',
                  style: TextStyle(color: const Color(0xFF6366F1), fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isCorrect = question.correctAnswerIndexes.contains(optionIndex);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                    border: Border.all(
                      color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                      width: isCorrect ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCorrect ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isCorrect ? const Color(0xFF10B981) : const Color(0xFF475569),
                            fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isCorrect)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Правильный',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
