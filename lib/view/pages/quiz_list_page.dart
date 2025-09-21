import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              const QuizListHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC), // Slate-50
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: Consumer<QuizProvider>(
                    builder: (context, quizProvider, child) {
                      if (quizProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                          ),
                        );
                      }

                      if (quizProvider.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                                ),
                                const SizedBox(height: 16),
                                Text('Ошибка загрузки', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 8),
                                Text(
                                  '${quizProvider.error}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () => quizProvider.loadQuizzes(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Повторить'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (quizProvider.quizzes.isEmpty) {
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
                                Text('Нет созданных квизов', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 8),
                                Text(
                                  'Нажмите + чтобы создать первый квиз',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: quizProvider.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = quizProvider.quizzes[index];
                          return QuizCard(
                            quiz: quiz,
                            index: index,
                            onEdit: () => _navigateToCreateQuiz(context, quiz),
                            onDelete: () => _showDeleteDialog(context, quiz),
                            onShare: () => _showShareDialog(context, quiz),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => QuizDetailPage(quiz: quiz),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: animation.drive(
                                        Tween(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).chain(CurveTween(curve: Curves.easeInOut)),
                                      ),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _navigateToCreateQuiz(context, null),
          tooltip: 'Создать квиз',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Удалить квиз'),
          ],
        ),
        content: Text(
          'Вы уверены, что хотите удалить квиз "${quiz.name}"? Это действие нельзя отменить.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B)),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<QuizProvider>().deleteQuiz(quiz.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context, Quiz quiz) {
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

class QuizListHeader extends StatelessWidget {
  const QuizListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.quiz_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Мои квизы',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Управляйте своими квизами',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
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
                      child: const Icon(Icons.quiz_outlined, color: Color(0xFF6366F1), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${quiz.questions.length} вопросов',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        } else if (value == 'share') {
                          onShare();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF6366F1)),
                              SizedBox(width: 8),
                              Text('Редактировать'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, color: Color(0xFF10B981)),
                              SizedBox(width: 8),
                              Text('Поделиться'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Color(0xFFEF4444)),
                              SizedBox(width: 8),
                              Text('Удалить'),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Активен',
                        style: TextStyle(color: const Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 16, color: const Color(0xFF94A3B8)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
