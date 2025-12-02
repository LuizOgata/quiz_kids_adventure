import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProgressService _progress = ProgressService();
  String name = "";
  int totalPoints = 0;
  List<String> badges = [];
  int level = 1;
  int xp = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await _progress.getProfile();
    setState(() {
      name = p["name"] ?? "Aventureiro";
      totalPoints = p["points"] ?? 0;
      badges = List<String>.from(p["badges"] ?? []);
      level = p["level"] ?? 1;
      xp = p["xp"] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 54,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.explore, size: 56, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Pontos: $totalPoints  •  Nível: $level", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: xp / 100, minHeight: 10),
            const SizedBox(height: 8),
            Text("$xp / 100 XP"),
            const SizedBox(height: 20),
            const Text("Badges", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            badges.isEmpty ? const Text("Nenhuma badge ainda.") : Wrap(spacing:12, children: badges.map((b) => Chip(label: Text(b))).toList())
          ],
        ),
      ),
    );
  }
}
