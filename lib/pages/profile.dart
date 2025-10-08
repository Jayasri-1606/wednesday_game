import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? customAvatar; // for user-picked image
  final ImagePicker _picker = ImagePicker();

  int selectedAvatar = 0;
  String playerName = "Player Name";

  final List<String> avatars = [
    "assets/images/boy_1.png",
    "assets/images/boy_2.png",
    "assets/images/boy_3.png",
    "assets/images/girl_1.png",
    "assets/images/girl_2.png",
    "assets/images/girl_3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/profile.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(avatars[selectedAvatar]),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    playerName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    final nameController = TextEditingController(
                      text: playerName,
                    );
                    String? newName = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Edit Name"),
                        content: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Player Name",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                              context,
                              nameController.text,
                            ),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    );
                    if (newName != null && newName.isNotEmpty) {
                      setState(() => playerName = newName);
                    }
                  },
                ),
              ],
            ),
        SizedBox(height: 5),
            const Text(
              "SELECT AVATAR",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
                        
            SizedBox(
              height: 400,
              width: 500,
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                itemCount: avatars.length + 1, // +1 for gallery option
                itemBuilder: (context, index) {
                  if (index == avatars.length) {
                    // 👉 last item = gallery picker
                    return GestureDetector(
                      onTap: () async {
                        final picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          setState(() {
                            customAvatar = File(picked.path);
                            selectedAvatar = index; // mark as selected
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedAvatar == index
                                ? Colors.greenAccent
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 40,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // 👉 normal avatar
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = index;
                          customAvatar =
                              null; // clear custom if switching back
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedAvatar == index
                                ? Colors.greenAccent
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(avatars[index]),
                          radius: 40,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 5),
            // Create button
            ElevatedButton(
  onPressed: () {
    Navigator.pop(context, {
      "name": playerName,
      "avatar": avatars[selectedAvatar],
    });
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 15,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text(
    "CREATE",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
