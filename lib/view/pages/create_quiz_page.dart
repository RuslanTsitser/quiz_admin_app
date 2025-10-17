import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/question.dart';
import '../../domain/entities/quiz.dart';
import '../providers/quiz_provider.dart';

class CreateQuizPage extends StatefulWidget {
  final Quiz? quiz;

  const CreateQuizPage({super.key, this.quiz});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.quiz != null) {
      _nameController.text = widget.quiz!.name;
      _questions.addAll(widget.quiz!.questions);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz == null ? 'Создать квиз' : 'Редактировать квиз'),
        actions: [
          if (_questions.isNotEmpty)
            IconButton(onPressed: _saveQuiz, icon: const Icon(Icons.save), tooltip: 'Сохранить квиз'),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            QuizNameField(controller: _nameController),
            Expanded(
              child: _questions.isEmpty
                  ? const EmptyQuestionsState()
                  : QuestionsList(
                      questions: _questions,
                      onEditQuestion: _editQuestion,
                      onDeleteQuestion: _deleteQuestion,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestion,
        tooltip: 'Добавить вопрос',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addQuestion() {
    _navigateToQuestionEditor();
  }

  void _editQuestion(int index) {
    _navigateToQuestionEditor(question: _questions[index], index: index);
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _navigateToQuestionEditor({Question? question, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          question: question,
          onSave: (editedQuestion) {
            setState(() {
              if (index != null) {
                _questions[index] = editedQuestion;
              } else {
                _questions.add(editedQuestion);
              }
            });
          },
        ),
      ),
    );
  }

  void _saveQuiz() {
    if (!_formKey.currentState!.validate()) return;

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Добавьте хотя бы один вопрос')));
      return;
    }

    final quiz = Quiz(
      id: widget.quiz?.id ?? '',
      name: _nameController.text,
      questions: _questions,
      createdAt: widget.quiz?.createdAt ?? DateTime.now(),
    );

    if (widget.quiz == null) {
      context.read<QuizProvider>().createQuiz(quiz);
    } else {
      context.read<QuizProvider>().updateQuiz(quiz);
    }

    Navigator.pop(context);
  }
}

class QuestionEditorPage extends StatefulWidget {
  final Question? question;
  final Function(Question) onSave;

  const QuestionEditorPage({super.key, this.question, required this.onSave});

  @override
  State<QuestionEditorPage> createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<QuestionEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final List<bool> _correctAnswers = [];

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!.questionText;
      for (int i = 0; i < widget.question!.options.length; i++) {
        _optionControllers.add(TextEditingController(text: widget.question!.options[i]));
        _correctAnswers.add(widget.question!.correctAnswerIndexes.contains(i));
      }
    } else {
      _addOption();
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Новый вопрос' : 'Редактировать вопрос'),
        actions: [IconButton(onPressed: _saveQuestion, icon: const Icon(Icons.save), tooltip: 'Сохранить вопрос')],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            QuestionTextField(controller: _questionController),
            const OptionsHeader(),
            Expanded(
              child: OptionsList(
                optionControllers: _optionControllers,
                correctAnswers: _correctAnswers,
                onRemoveOption: _removeOption,
                onCorrectAnswerChanged: (index, value) {
                  setState(() {
                    _correctAnswers[index] = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOption,
        tooltip: 'Добавить вариант',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _correctAnswers.add(false);
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 1) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
        _correctAnswers.removeAt(index);
      });
    }
  }

  void _saveQuestion() {
    if (!_formKey.currentState!.validate()) return;

    final options = _optionControllers.map((controller) => controller.text).toList();
    final correctAnswerIndexes = <int>[];

    for (int i = 0; i < _correctAnswers.length; i++) {
      if (_correctAnswers[i]) {
        correctAnswerIndexes.add(i);
      }
    }

    if (correctAnswerIndexes.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите хотя бы один правильный ответ')));
      return;
    }

    final question = Question(
      questionText: _questionController.text,
      options: options,
      correctAnswerIndexes: correctAnswerIndexes,
    );

    widget.onSave(question);
    Navigator.pop(context);
  }
}

class QuestionTextField extends StatelessWidget {
  final TextEditingController controller;

  const QuestionTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Текст вопроса',
          hintText: 'Введите текст вашего вопроса',
          prefixIcon: Icon(Icons.help_outline),
        ),
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите текст вопроса';
          }
          return null;
        },
      ),
    );
  }
}

class OptionsHeader extends StatelessWidget {
  const OptionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.list_alt, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Варианты ответов',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Выберите правильные',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  final List<TextEditingController> optionControllers;
  final List<bool> correctAnswers;
  final Function(int) onRemoveOption;
  final Function(int, bool) onCorrectAnswerChanged;

  const OptionsList({
    super.key,
    required this.optionControllers,
    required this.correctAnswers,
    required this.onRemoveOption,
    required this.onCorrectAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: optionControllers.length,
      itemBuilder: (context, index) {
        return OptionCard(
          controller: optionControllers[index],
          index: index,
          isCorrect: correctAnswers[index],
          canRemove: optionControllers.length > 1,
          onCorrectChanged: (value) => onCorrectAnswerChanged(index, value),
          onRemove: () => onRemoveOption(index),
        );
      },
    );
  }
}

class OptionCard extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final bool isCorrect;
  final bool canRemove;
  final Function(bool) onCorrectChanged;
  final VoidCallback onRemove;

  const OptionCard({
    super.key,
    required this.controller,
    required this.index,
    required this.isCorrect,
    required this.canRemove,
    required this.onCorrectChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: isCorrect ? Border.all(color: Theme.of(context).colorScheme.secondary, width: 2) : null,
          ),
          child: Row(
            children: [
              Checkbox(
                value: isCorrect,
                onChanged: (value) => onCorrectChanged(value ?? false),
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Вариант ${index + 1}', hintText: 'Введите вариант ответа'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите вариант ответа';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                  tooltip: 'Удалить вариант',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizNameField extends StatelessWidget {
  final TextEditingController controller;

  const QuizNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Название квиза',
          hintText: 'Введите название вашего квиза',
          prefixIcon: Icon(Icons.quiz_outlined),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите название квиза';
          }
          return null;
        },
      ),
    );
  }
}

class EmptyQuestionsState extends StatelessWidget {
  const EmptyQuestionsState({super.key});

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
              'Нажмите + чтобы добавить первый вопрос',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionsList extends StatelessWidget {
  final List<Question> questions;
  final Function(int) onEditQuestion;
  final Function(int) onDeleteQuestion;

  const QuestionsList({
    super.key,
    required this.questions,
    required this.onEditQuestion,
    required this.onDeleteQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return QuestionCard(
          question: questions[index],
          index: index,
          onEdit: () => onEditQuestion(index),
          onDelete: () => onDeleteQuestion(index),
        );
      },
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: InkWell(
          onTap: onEdit,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.questionText,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${question.options.length} вариантов ответа',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
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
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Color(0xFF1890FF)),
                              SizedBox(width: 8),
                              Text('Редактировать'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Color(0xFFF5222D)),
                              SizedBox(width: 8),
                              Text('Удалить'),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Готов',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
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
