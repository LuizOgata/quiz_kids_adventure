import 'package:flutter/material.dart';
import '../models/question.dart';
import 'result_page.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/progress_service.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final List<Question> questions;
  const QuizPage({super.key, required this.title, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int? selected;
  bool answered = false;
  final player = AudioPlayer();
  final _progress = ProgressService();

  late int timeLeft;
  bool timeRunning = true;

  @override
  void initState() {
    super.initState();
    timeLeft = 20;
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !timeRunning) return false;
      setState(() => timeLeft--);
      if (timeLeft <= 0) {
        _select(-1);
        return false;
      }
      return true;
    });
  }

  void _playCorrect() async {
    try { await player.play(AssetSource('sounds/correct.mp3')); } catch(_) {}
  }
  void _playWrong() async {
    try { await player.play(AssetSource('sounds/wrong.mp3')); } catch(_) {}
  }

  void _select(int i) {
    if (answered) return;
    setState(() {
      selected = i;
      answered = true;
      if (i == widget.questions[index].answerIndex) {
        score += 1;
        _playCorrect();
      } else {
        _playWrong();
      }
      timeRunning = false;
    });
    Future.delayed(const Duration(milliseconds: 900), () async {
      if (index + 1 < widget.questions.length) {
        setState(() {
          index += 1;
          selected = null;
          answered = false;
          timeLeft = 20;
          timeRunning = true;
        });
        _startTimer();
      } else {
        await _progress.saveScore(widget.title, score, widget.questions.length);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(score: score, total: widget.questions.length, title: widget.title)));
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            // Timer row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: timeLeft <=5 ? Colors.red : Colors.green),
                const SizedBox(width: 8),
                Text('$timeLeft s', style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height:8),
            LinearProgressIndicator(value: timeLeft/20, minHeight: 8, backgroundColor: Colors.grey.shade300),
            const SizedBox(height:16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0,6))]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pergunta ${index+1} de ${widget.questions.length}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(q.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  ...List.generate(q.options.length, (i) {
                    final opt = q.options[i];
                    Color? bg;
                    Color txt = Colors.black87;
                    if (answered) {
                      if (i == q.answerIndex) { bg = Colors.green.shade200; txt = Colors.green.shade900; }
                      else if (selected == i) { bg = Colors.red.shade200; txt = Colors.red.shade900; }
                      else { bg = Colors.grey.shade100; }
                    } else {
                      bg = Colors.blue.shade50;
                    }
                    return GestureDetector(
                      onTap: () => _select(i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Text(String.fromCharCode(65 + i), style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(opt, style: TextStyle(color: txt, fontSize: 16))),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
