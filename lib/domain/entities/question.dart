class Question {
  final String questionText;
  final List<String> options;
  final List<int> correctAnswerIndexes;

  const Question({required this.questionText, required this.options, required this.correctAnswerIndexes});

  Question copyWith({String? questionText, List<String>? options, List<int>? correctAnswerIndexes}) {
    return Question(
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndexes: correctAnswerIndexes ?? this.correctAnswerIndexes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question &&
        other.questionText == questionText &&
        other.options.toString() == options.toString() &&
        other.correctAnswerIndexes.toString() == correctAnswerIndexes.toString();
  }

  @override
  int get hashCode {
    return questionText.hashCode ^ options.hashCode ^ correctAnswerIndexes.hashCode;
  }

  @override
  String toString() {
    return 'Question(questionText: $questionText, options: $options, correctAnswerIndexes: $correctAnswerIndexes)';
  }

  Map<String, dynamic> toJson() {
    return {'questionText': questionText, 'options': options, 'correctAnswerIndexes': correctAnswerIndexes};
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndexes: List<int>.from(json['correctAnswerIndexes'] as List),
    );
  }
}
