import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rps/game_model.dart';
import 'package:rps/profilemodel.dart';

class PlayWithWednesday extends StatefulWidget {
  const PlayWithWednesday({super.key});

  @override
  State<PlayWithWednesday> createState() => _PlayWithWednesdayState();
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
}

class _PlayWithWednesdayState extends State<PlayWithWednesday> {
  int round = 1;
  int playerScore = 0;
  int wednesdayScore = 0;
  bool finished = false;
  bool lost = false;
  Move? _playerMove;
  Move? _wednesdayMove;
  String _roundResult = "";

  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
  }

  void _playMove(Move player) {
    final wednesday = Move.values[_rng.nextInt(3)];

    setState(() {
      _playerMove = player;
      _wednesdayMove = wednesday;

      if (player == wednesday) {
        _roundResult = "Tie!";
      } else if ((player == Move.rock && wednesday == Move.scissors) ||
          (player == Move.paper && wednesday == Move.rock) ||
          (player == Move.scissors && wednesday == Move.paper)) {
        playerScore++;
        _roundResult = "You Win!";
      } else {
        wednesdayScore++;
        _roundResult = "You Lose!";
      }

      round++;
      if (round > 10) {
        finished = true;
        lost = playerScore < wednesdayScore;
        Provider.of<GameModel>(context, listen: false).updateHigh(playerScore);
      }
    });
  }

  // void _startAutoGame() {
  //   Timer.periodic(const Duration(seconds: 2), (timer) {
  //     if (round > 10) {
  //       timer.cancel();
  //       _endGame();
  //       return;
  //     }

  //     // Random win/loss outcome
  //     bool playerWins = _rng.nextBool();

  //     setState(() {
  //       if (playerWins) {
  //         playerScore++;
  //       } else {
  //         wednesdayScore++;
  //       }
  //       round++;
  //     });
  //   });
  // }

  // void _endGame() {
  //   setState(() {
  //     finished = true;
  //     lost = playerScore < wednesdayScore;
  //   });

  //   Provider.of<GameModel>(context, listen: false).updateHigh(playerScore);
  // }

  void _restartGame() {
  setState(() {
    round = 1;
    playerScore = 0;
    wednesdayScore = 0;
    finished = false;
    lost = false;
    _playerMove = null;
    _wednesdayMove = null;
    _roundResult = "";
  });
}

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel>(context);
    final highScore = Provider.of<GameModel>(context).highScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Play With Wednesday Addams"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _restartGame),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: finished
                ? (lost
                      ? [Colors.black, Colors.red.shade900]
                      : [Colors.black, Colors.purple.shade700])
                : [const Color(0xff120a12), const Color(0xffc12d4c)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: finished ? _buildResult() : _buildGame(profile, highScore),
      ),
    );
  }

  // --- Main Game UI ---
  Widget _buildGame(ProfileModel profile, int highScore) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          "Round $round / 10",
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 20),

        _buildScoreboard(),

        const SizedBox(height: 40),
        _buildAvatars(profile),

        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: round / 10,
            minHeight: 8,
            backgroundColor: Colors.black26,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Move.values.map((m) {
            return GestureDetector(
              onTap: finished ? null : () => _playMove(m),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xff120a12),
                child: Text(m.emoji, style: const TextStyle(fontSize: 28)),
              ),
            );
          }).toList(),
        ),
SizedBox(height: 10),
        Text(
          _roundResult,
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),

      ],
    );
  }

  Widget _buildScoreboard() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xff120a12), Color(0xffc12d4c)],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          blurRadius: 10,
          spreadRadius: 3,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _scoreBox("You", playerScore),
        const Text("⚡", style: TextStyle(color: Colors.white, fontSize: 26)),
        _scoreBox("Wednesday", wednesdayScore),
      ],
    ),
  );

  Widget _scoreBox(String label, int score) => Column(
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
      Text(
        score.toString(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );

  Widget _buildAvatars(ProfileModel profile) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _avatar(profile.avatarFile, profile.avatarAsset, profile.name),
      const Text("VS", style: TextStyle(color: Colors.white, fontSize: 24)),
      _avatar(null, "assets/images/wed.png", "Wednesday"),
    ],
  );

  Widget _avatar(dynamic file, String? asset, String label) {
    ImageProvider? img;
    if (file != null) {
      img = FileImage(file);
    } else if (asset != null) {
      img = AssetImage(asset);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.black54,
          backgroundImage: img,
          child: img == null
              ? const Icon(Icons.person, color: Colors.white, size: 40)
              : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  // --- Result Screen (No Video) ---
  Widget _buildResult() => Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lost ? "💀 You Lost..." : "🎉 You Won!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: lost ? Colors.redAccent : Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Final Score: $playerScore - Wednesday: $wednesdayScore",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 30),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: lost ? Colors.red.shade900 : Colors.green.shade800,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: lost ? Colors.redAccent : Colors.greenAccent.shade200,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              lost ? Icons.dangerous : Icons.star,
              color: Colors.white,
              size: 100,
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            child: const Text(
              "BACK TO HOME",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
