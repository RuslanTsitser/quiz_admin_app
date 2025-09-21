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
        theme: _buildModernTheme(),
        home: const QuizListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _buildModernTheme() {
    const primaryColor = Color(0xFF6366F1); // Indigo-500
    const secondaryColor = Color(0xFF8B5CF6); // Violet-500
    const surfaceColor = Color(0xFFF8FAFC); // Slate-50
    const errorColor = Color(0xFFEF4444); // Red-500

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1E293B), // Slate-800
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 8, shape: CircleBorder()),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF475569)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
      ),
    );
  }
}
