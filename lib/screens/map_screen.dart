import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ProgressService _progress = ProgressService();
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await _progress.getProfile();
    setState(() => profile = p);
  }

  @override
  Widget build(BuildContext context) {
    final level = profile['level'] ?? 1;
    final badges = List<String>.from(profile['badges'] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Aventuras')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nível atual: $level',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // TRILHA ESTILO DUOLINGO
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(10, (i) {
                  final reached = i < level;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: reached
                                ? Colors.orangeAccent
                                : Colors.grey.shade300,
                            child: Icon(
                              reached ? Icons.landscape : Icons.lock,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Nível ${i + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: reached ? Colors.black : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Badges conquistados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            badges.isEmpty
                ? const Text('Nenhuma badge ainda...')
                : Wrap(
                    spacing: 12,
                    children: badges.map((b) {
                      return Chip(
                        label: Text(b),
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
