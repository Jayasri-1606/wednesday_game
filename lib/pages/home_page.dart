import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rps/profilemodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 700;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Text(
                      "ROCK • PAPER • SCISSORS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isWide ? 38 : 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Profile Avatar Section
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/profile'),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: isWide ? 60 : 48,
                            backgroundColor: Colors.black45,
                            backgroundImage: profile.avatarFile != null
                                ? FileImage(profile.avatarFile!)
                                : (profile.avatarAsset != null
                                    ? AssetImage(profile.avatarAsset!)
                                    : null),
                            child: (profile.avatarFile == null &&
                                    profile.avatarAsset == null)
                                ? const Icon(Icons.person,
                                    color: Colors.white, size: 50)
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profile.name.isNotEmpty
                                ? profile.name
                                : "Tap to create your profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWide ? 18 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _ChoiceIcon(icon: Icons.front_hand, label: "Rock"),
                        _ChoiceIcon(icon: Icons.pan_tool, label: "Paper"),
                        _ChoiceIcon(icon: Icons.content_cut, label: "Scissors"),
                      ],
                    ),
                    const SizedBox(height: 80),

                    // Buttons
                    _MenuButton(
                      label: "PROFILE",
                      onPressed: () =>
                          Navigator.pushNamed(context, '/profile'),
                    ),
                    const SizedBox(height: 16),

                    _MenuButton(
                      label: "START GAME",
                      onPressed: () {
                        if (profile.name.isNotEmpty) {
                          Navigator.pushNamed(context, '/playing');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please create a profile first!")),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    _MenuButton(
                      label: "PLAY WITH WEDNESDAY ADDAMS",
                      onPressed: () {
                        if (profile.name.isNotEmpty) {
                          Navigator.pushNamed(context, '/play_with_wednesday');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please create a profile first!")),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
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

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff772335),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
