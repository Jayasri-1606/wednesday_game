import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rps/profilemodel.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameCtrl = TextEditingController();

  final List<String> avatars = [
    "assets/images/boy_1.png",
    "assets/images/boy_2.png",
    "assets/images/boy_3.png",
    "assets/images/girl_1.png",
    "assets/images/girl_2.png",
    "assets/images/girl_3.png",
  ];

  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileModel>(context,listen: false);

    _nameCtrl.text = profile.playername;
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      Provider.of<ProfileModel>(context, listen: false).setAvatarFile(file);
      setState(() {
        selectedIndex = null; // deselect avatar
      });
    }
  }

  void _saveProfile() {
    final profile = Provider.of<ProfileModel>(context, listen: false);
    profile.setName(_nameCtrl.text.trim().isEmpty
        ? "Player Name"
        : _nameCtrl.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/profile.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Avatar
              GestureDetector(
  onTap: _pickFromGallery,
  child: CircleAvatar(
    radius: 60,
    backgroundColor: Colors.black38,
    backgroundImage: profile.avatarFile != null
        ? FileImage(profile.avatarFile!)
        : (profile.avatarAsset != null
            ? AssetImage(profile.avatarAsset!) as ImageProvider
            : null),
    child: (profile.avatarFile == null && profile.avatarAsset == null)
        ? const Icon(Icons.camera_alt, size: 36, color: Colors.white)
        : null,
  ),
),


              const SizedBox(height: 20),

              // Name
              TextField(
                controller: _nameCtrl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black45,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Enter your name",
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),

              const SizedBox(height: 30),
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

              // Avatar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: avatars.length + 1,
                itemBuilder: (context, index) {
                  if (index == avatars.length) {
                    // Gallery upload
                    return GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white70,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 40,
                          child: Icon(Icons.add_a_photo,
                              color: Colors.white, size: 40),
                        ),
                      ),
                    );
                  } else {
                    // Predefined avatar
                    return GestureDetector(
                      onTap: () {
  Provider.of<ProfileModel>(context, listen: false)
      .setAvatarAsset(avatars[index]);
  setState(() => selectedIndex = index);
},

                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedIndex == index
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
              const SizedBox(height: 40),

              // Save button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "SAVE PROFILE",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
