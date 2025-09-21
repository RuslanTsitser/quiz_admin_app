import 'question.dart';

class Quiz {
  final String id;
  final String name;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Quiz({
    required this.id,
    required this.name,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  Quiz copyWith({String? id, String? name, List<Question>? questions, DateTime? createdAt, DateTime? updatedAt}) {
    return Quiz(
      id: id ?? this.id,
      name: name ?? this.name,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quiz &&
        other.id == id &&
        other.name == name &&
        other.questions.toString() == questions.toString() &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ questions.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Quiz(id: $id, name: $name, questions: $questions, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      name: json['name'] as String,
      questions: (json['questions'] as List).map((q) => Question.fromJson(q as Map<String, dynamic>)).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
