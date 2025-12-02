import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home.dart';

void main() {
  runApp(const QuizKidsApp());
}

class QuizKidsApp extends StatelessWidget {
  const QuizKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Kids - Adventure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: GoogleFonts.fredoka().fontFamily,
        textTheme: GoogleFonts.fredokaTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C2FF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
