
import 'package:flutter/material.dart';
import 'package:rps/pages/home_page.dart';

void main() => runApp(const RPSApp());

class RPSApp extends StatelessWidget {
  const RPSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


