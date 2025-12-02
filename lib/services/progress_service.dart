import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProgressService {
  static const _keyPrefix = 'quiz_score_';
  static const _profileKey = 'profile_data';

  Future<void> saveScore(String category, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();

    // Salva pontuação no formato correto
    await prefs.setString('$_keyPrefix$category', '$score/$total');

    // Adiciona pontos (15 por acerto, estilo Duolingo)
    await addPoints(score * 15);

    // Desbloqueia badge se acertou tudo
    if (score == total) {
      await unlockBadge("Conquistador de $category");
    }

    // Atualiza progresso geral
    await _updateLevelProgress(category, score, total);
  }

  Future<String?> getScore(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_keyPrefix$category');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);

    if (raw == null) {
      final newProfile = {
        "name": "Aventureiro",
        "points": 0,
        "badges": [],
        "level": 1,
        "xp": 0,
        "mapProgress": {}
      };

      prefs.setString(_profileKey, jsonEncode(newProfile));
      return newProfile;
    }

    return jsonDecode(raw);
  }

  Future<void> addPoints(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final p = await getProfile();

    p["points"] = (p["points"] as int) + amount;
    p["xp"] = (p["xp"] as int) + amount;

    // Sobe de nível a cada 100 XP
    while (p["xp"] >= 100) {
      p["xp"] -= 100;
      p["level"] = (p["level"] as int) + 1;
    }

    prefs.setString(_profileKey, jsonEncode(p));
  }

  Future<void> unlockBadge(String badge) async {
    final prefs = await SharedPreferences.getInstance();
    final p = await getProfile();

    final badges = List<String>.from(p["badges"] ?? []);

    if (!badges.contains(badge)) {
      badges.add(badge);
      p["badges"] = badges;
      prefs.setString(_profileKey, jsonEncode(p));
    }
  }

  Future<void> _updateLevelProgress(String category, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final p = await getProfile();

    final mapProg = Map<String, dynamic>.from(p["mapProgress"] ?? {});

    mapProg[category] = {
      "lastScore": score,
      "total": total,
    };

    p["mapProgress"] = mapProg;

    prefs.setString(_profileKey, jsonEncode(p));
  }
}
