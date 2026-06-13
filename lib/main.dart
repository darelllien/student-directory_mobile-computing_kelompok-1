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
          seedColor: const Color(0xFF487EFD),
          brightness: Brightness.light,
          primary: const Color(0xFF487EFD),
          secondary: const Color(0xFF0347E4),
          surface: const Color(0xFFF8F9FA),
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
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