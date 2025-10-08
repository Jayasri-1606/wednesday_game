import 'package:flutter/material.dart';
import 'dart:math';
class PlayingPage extends StatefulWidget {
  final String playerName;
  final String? profileUrl;

  const PlayingPage({
    super.key,
    required this.playerName,
    this.profileUrl,
  });

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
    return Scaffold(
      body: 
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffc12d4c), Color(0xff120a12),],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rock Paper Scissors",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                  IconButton(onPressed: _reset, icon: const Icon(Icons.refresh,color: Colors.white,)),
                ],
              ),
            ),
            const SizedBox(height: 80),

            Container(
              padding: const EdgeInsets.all(12),
              width: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff120a12),Color(0xffc12d4c), ]) ,
             
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  Text("Score",style: TextStyle(fontSize: 26, color: Colors.white,fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _scoreBox("You", _playerScore),
                      Text("⚡", style: TextStyle(fontSize: 26, color: Colors.white)),
                      _scoreBox("WEDNESDAY ADDAMS", _cpuScore),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Versus board
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_result,
                      style: const TextStyle(
                          fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _handCard("You", _playerMove?.emoji ?? "❓",
        profileUrl: widget.profileUrl), // <-- your avatar
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

            // Player buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Move.values.map((m) {
                  return GestureDetector(
                    onTap: () => _play(m),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Color(0xff120a12),
                      child: Text(m.emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  );
                }).toList(),
              ),
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
        Text(score.toString(),
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

 Widget _handCard(String label, String emoji, {String? profileUrl}) {
  return Column(
    children: [
      // Profile image
      CircleAvatar(
        radius: 28,
        backgroundColor: Color(0xff120a12),
        backgroundImage: profileUrl != null ? NetworkImage(profileUrl) : null,
        child: profileUrl == null
            ? const Icon(Icons.person, color: Colors.white, size: 30)
            : null,
      ),
      const SizedBox(height: 8),

      // Label (You / CPU)
      Text(label, style: const TextStyle(color: Colors.white70)),

      const SizedBox(height: 8),

      // Emoji (move)
      Text(
        emoji,
        style: const TextStyle(fontSize: 50, color: Colors.white),
      ),
    ],
  );
}

}
