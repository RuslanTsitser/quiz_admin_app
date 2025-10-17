import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di/injection_container.dart';
import 'firebase_options.dart';
import 'view/pages/quiz_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        theme: _buildAntTheme(),
        home: const QuizListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildAntTheme() {
    const primaryColor = Color(0xFF1890FF); // Ant Design Blue
    const successColor = Color(0xFF52C41A); // Ant Design Green
    const errorColor = Color(0xFFF5222D); // Ant Design Red
    const textColor = Color(0xFF262626); // Ant Design Text Color
    const textColorSecondary = Color(0xFF8C8C8C); // Ant Design Secondary Text
    const borderColor = Color(0xFFD9D9D9); // Ant Design Border

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: successColor,
        surface: Colors.white,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
        bodyLarge: TextStyle(fontSize: 14, color: textColor),
        bodyMedium: TextStyle(fontSize: 12, color: textColorSecondary),
      ),
      fontFamily:
          'PingFang SC, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    );
  }
}
