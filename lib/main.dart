import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/profile.dart';
import 'pages/playing_page.dart';
import 'pages/playwithwednesday.dart';

import 'package:rps/game_model.dart';
import 'package:rps/profilemodel.dart';

import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileModel()),
        ChangeNotifierProvider(create: (_) => GameModel(prefs)),
      ],
      child: const RPSApp(),
    ),
  );
}

class RPSApp extends StatelessWidget {
  const RPSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wednesday Addams RPS',
      debugShowCheckedModeBanner: false,
      theme: wednesdayDarkTheme,
      darkTheme: wednesdayDarkTheme,
      home: const HomePage(),
      routes: {
        '/profile': (_) => const ProfilePage(),
        '/playing': (_) => const PlayingPage(),
        '/play_with_wednesday': (_) => const PlayWithWednesday(),
      },
    );
  }
}
