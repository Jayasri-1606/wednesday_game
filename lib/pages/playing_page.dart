import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rps/game_model.dart';
import 'package:rps/profilemodel.dart';

class PlayingPage extends StatefulWidget {
  const PlayingPage({super.key});

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

enum Move { rock, paper, scissors }

extension MoveExtension on Move {
  String get emoji {
    switch (this) {
      case Move.rock:
        return '✊';
      case Move.paper:
        return '✋';
      case Move.scissors:
        return '✌️';
    }
  }

  String get name {
    switch (this) {
      case Move.rock:
        return 'Rock';
      case Move.paper:
        return 'Paper';
      case Move.scissors:
        return 'Scissors';
    }
  }
}

enum Result { win, lose, tie }

class _PlayingPageState extends State<PlayingPage> {
  Move? _playerMove;
  Move? _cpuMove;
  int _playerScore = 0;
  int _cpuScore = 0;
  String _result = "Tap a move to start!";
  final Random _rng = Random();

  void _play(Move player) {
    final cpu = Move.values[_rng.nextInt(3)];
    final res = _decide(player, cpu);

    setState(() {
      _playerMove = player;
      _cpuMove = cpu;

      if (res == Result.win) {
        _playerScore++;
        _result = "🎉 You Win!";
      } else if (res == Result.lose) {
        _cpuScore++;
        _result = "😢 You Lose!";
      } else {
        _result = "🤝 It's a Tie!";
      }
    });
  }

  void _reset() {
    setState(() {
      _playerMove = null;
      _cpuMove = null;
      _playerScore = 0;
      _cpuScore = 0;
      _result = "Tap a move to start!";
    });
  }

  void _finish() {
    Provider.of<GameModel>(context, listen: false).updateHigh(_playerScore);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Your Score: $_playerScore"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Result _decide(Move p, Move c) {
    if (p == c) return Result.tie;
    if ((p == Move.rock && c == Move.scissors) ||
        (p == Move.paper && c == Move.rock) ||
        (p == Move.scissors && c == Move.paper)) {
      return Result.win;
    }
    return Result.lose;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel>(context);
    final high = Provider.of<GameModel>(context).highScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Start"),
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffc12d4c), Color(0xff120a12)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Rock Paper Scissors",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Scoreboard
            Container(
              padding: const EdgeInsets.all(12),
              width: 380,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff120a12), Color(0xffc12d4c)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Score",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _scoreBox("You", _playerScore),
                      const Text("⚡",
                          style: TextStyle(fontSize: 26, color: Colors.white)),
                      _scoreBox("WEDNESDAY ADDAMS", _cpuScore),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Versus section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _handCard("You", _playerMove?.emoji ?? "❓",
                          profile: profile),
                      const Text(
                        "VS",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      _handCard("WEDNESDAY ADDAMS", _cpuMove?.emoji ?? "❓"),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Move.values.map((m) {
                  return GestureDetector(
                    onTap: () => _play(m),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: const Color(0xff120a12),
                      child: Text(
                        m.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _finish,
              child: const Text("Finish & Save"),
            ),
            const SizedBox(height: 10),
            Text(
              "High Score: $high",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _scoreBox(String label, int score) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(
          score.toString(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _handCard(String label, String emoji, {ProfileModel? profile}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xff120a12),
          backgroundImage: profile?.avatarFile != null
              ? FileImage(profile!.avatarFile!)
              : (profile?.avatarAsset != null
                  ? AssetImage(profile!.avatarAsset!) as ImageProvider
                  : null),
          child: (profile == null ||
                  (profile.avatarFile == null && profile.avatarAsset == null))
              ? const Icon(Icons.person, color: Colors.white, size: 30)
              : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Text(emoji, style: const TextStyle(fontSize: 50, color: Colors.white)),
      ],
    );
  }
}
