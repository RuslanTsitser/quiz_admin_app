import 'package:cloud_firestore/cloud_firestore.dart';

import 'question.dart';

class Quiz {
  final String id;
  final String name;
  final List<Question> questions;
  final DateTime createdAt;

  const Quiz({required this.id, required this.name, required this.questions, required this.createdAt});

  Quiz copyWith({String? id, String? name, List<Question>? questions, DateTime? createdAt}) {
    return Quiz(
      id: id ?? this.id,
      name: name ?? this.name,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quiz && other.id == id && other.name == name && other.questions.toString() == questions.toString();
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ questions.hashCode;
  }

  @override
  String toString() {
    return 'Quiz(id: $id, name: $name, questions: $questions, createdAt: $createdAt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json, String id) {
    return Quiz(
      id: id,
      name: json['name'] as String,
      questions: (json['questions'] as List).map((q) => Question.fromJson(q as Map<String, dynamic>)).toList(),
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }
}
