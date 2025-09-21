import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di/injection_container.dart';
import 'view/pages/quiz_list_page.dart';

void main() {
  runApp(const QuizAdminApp());
}

class QuizAdminApp extends StatelessWidget {
  const QuizAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: InjectionContainer.providers,
      child: MaterialApp(
        title: 'Quiz Admin App',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        home: const QuizListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
