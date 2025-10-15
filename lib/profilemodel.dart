import 'package:flutter/material.dart';
import 'dart:io';

class ProfileModel extends ChangeNotifier {
  String name = "Wednesday";
  int score = 0;

  String playername = "Player Name";
  File? avatarFile;
  String? avatarAsset;

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateScore(int value) {
    score = value;
    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }

  void setAvatarFile(File file) {
    avatarFile = file;
    avatarAsset = null; // deselect asset if custom file
    notifyListeners();
  }

  void setAvatarAsset(String asset) {
    avatarAsset = asset;
    avatarFile = null; // deselect file if asset chosen
    notifyListeners();
  }
}
