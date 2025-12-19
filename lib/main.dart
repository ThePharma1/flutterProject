import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'add_student.dart';
import 'students_page.dart';

void main() {
  runApp(const Project2App());
}

class Project2App extends StatelessWidget {
  const Project2App({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = Colors.blue;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: seed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: seed,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF4FF),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: seed,
          contentTextStyle: const TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/home': (_) => const HomePage(),
        '/add': (_) => const AddStudentPage(),
        '/students': (_) => const StudentsPage(),
      },
    );
  }
}
