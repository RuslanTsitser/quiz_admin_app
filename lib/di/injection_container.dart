import 'package:provider/provider.dart';

import '../data/repositories/quiz_repository_impl.dart';
import '../domain/repositories/quiz_repository.dart';
import '../view/providers/quiz_provider.dart';

class InjectionContainer {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<QuizProvider>(create: (context) => QuizProvider(_getQuizRepository())),
  ];

  static QuizRepository _getQuizRepository() {
    return QuizRepositoryImpl();
  }
}
