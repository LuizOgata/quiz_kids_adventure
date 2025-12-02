import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final String title;
  const ResultPage({super.key, required this.score, required this.total, required this.title});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).round();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]
                ),
                child: Column(
                  children: [
                    Text('$score / $total', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('$percent% correto', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.replay),
                      label: const Text('Voltar ao mapa'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
