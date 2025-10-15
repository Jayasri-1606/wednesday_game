import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameModel extends ChangeNotifier {
  final SharedPreferences prefs;

  int wins = 0;
  int losses = 0;
  int _highScore = 0;

  GameModel(this.prefs) {
    wins = prefs.getInt('wins') ?? 0;
    losses = prefs.getInt('losses') ?? 0;
    _highScore = prefs.getInt('highScore') ?? 0;
  }

  int get highScore => _highScore;

  void updateHigh(int score) {
    if (score > _highScore) {
      _highScore = score;
      prefs.setInt('highScore', _highScore);
      notifyListeners();
    }
  }

  void resetHigh() {
    _highScore = 0;
    prefs.setInt('highScore', 0);
    notifyListeners();
  }

  void addWin() {
    wins++;
    prefs.setInt('wins', wins);
    notifyListeners();
  }

  void addLoss() {
    losses++;
    prefs.setInt('losses', losses);
    notifyListeners();
  }
}
