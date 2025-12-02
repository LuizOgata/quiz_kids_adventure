import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/question.dart';
import 'quiz_page.dart';
import 'profile_page.dart';
import 'map_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../services/progress_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Question>> categories = {};
  bool loading = true;
  final ProgressService _progress = ProgressService();
  Map<String, String> saved = {};

  final Map<String, String> categoryImages = {
    "Matemática": "assets/images/math.png",
    "Geografia": "assets/images/geo.png",
    "História": "assets/images/history.png",
    "Variedades": "assets/images/mix.png",
  };

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final raw = await rootBundle.loadString('assets/questions.json');
    final map = json.decode(raw) as Map<String, dynamic>;

    final result = <String, List<Question>>{};
    for (final entry in map.entries) {
      result[entry.key] =
          (entry.value as List).map((e) => Question.fromMap(e)).toList();

      final s = await _progress.getScore(entry.key);
      if (s != null) saved[entry.key] = s;
    }

    setState(() {
      categories = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background map
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // CUSTOM APP BAR
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      const Text(
                        'Adventure Quest',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Color.fromARGB(96, 190, 189, 189),
                                blurRadius: 4)
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.map, size: 28),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MapScreen()));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.person, size: 28),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfilePage()));
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 500),
                          child: GridView.count(
                            padding: const EdgeInsets.all(16),
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.9,
                            children: categories.keys.map((title) {
                              final count = categories[title]?.length ?? 0;
                              final last = saved[title];

                              return GestureDetector(
                                onTap: () {
                                  final qs = categories[title]!;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => QuizPage(
                                              title: title, questions: qs)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 160, 185, 197)
                                            .withOpacity(0.80),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 6))
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            categoryImages[title] ??
                                                "assets/images/default.png",
                                            width: 100,
                                            height: 100,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '$count perguntas',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                      if (last != null)
                                        Text(
                                          'Último: $last',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
