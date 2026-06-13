import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/add_student_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const StudentDirectoryApp());
}

class StudentDirectoryApp extends StatelessWidget {
  const StudentDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF3D5AFE),
          surface: const Color(0xFFF5F6FA),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add': (context) => AddStudentPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}