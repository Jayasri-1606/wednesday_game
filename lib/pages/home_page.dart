import 'package:flutter/material.dart';
import 'package:rps/pages/playing_page.dart';
import 'package:rps/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? playerName;
String? profileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rock, Paper, Scissors icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ChoiceIcon(icon: Icons.front_hand, label: "Rock"),
                _ChoiceIcon(icon: Icons.pan_tool, label: "Paper"),
                _ChoiceIcon(icon: Icons.content_cut, label: "Scissors"),
              ],
            ),
            const SizedBox(height: 60),

            // Profile & Start Game buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff772335),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
               final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                if (result != null) {
      setState(() {
        playerName = result["name"];
        profileUrl = result["avatar"];
      });
    }
              },
              child: const Text(
                "PROFILE",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff772335),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
    if (playerName != null && profileUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayingPage(
            playerName: playerName!,
            profileUrl: profileUrl!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please create a profile first!")),
      );
    }
  },
              child: const Text(
                "START GAME",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff772335),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const PlayingPage()),
                // );
              },
              child: const Text(
                "PLAY WITH WEDNESDAY ADDAMS",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ChoiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 50, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
