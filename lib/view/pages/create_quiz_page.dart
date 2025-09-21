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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [if (_questions.isNotEmpty) IconButton(onPressed: _saveQuiz, icon: const Icon(Icons.save))],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название квиза', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название квиза';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: _questions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Нет вопросов', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Нажмите + чтобы добавить вопрос', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_questions[index].questionText, maxLines: 2, overflow: TextOverflow.ellipsis),
                            subtitle: Text('Вариантов: ${_questions[index].options.length}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editQuestion(index);
                                } else if (value == 'delete') {
                                  _deleteQuestion(index);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                                const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                              ],
                            ),
                            onTap: () => _editQuestion(index),
                          ),
                        );
                      },
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

    final quiz = Quiz(id: widget.quiz?.id ?? '', name: _nameController.text, questions: _questions);

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(onPressed: _saveQuestion, icon: const Icon(Icons.save))],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Текст вопроса', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите текст вопроса';
                  }
                  return null;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [Text('Варианты ответов', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _optionControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _correctAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                _correctAnswers[index] = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _optionControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Вариант ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введите вариант ответа';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(onPressed: () => _removeOption(index), icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
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
