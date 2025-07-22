import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash_hunter/Constants/TextsStyles/heading_texts.dart';
import 'package:trash_hunter/Constants/posts_card.dart';
import 'package:trash_hunter/Constants/user_info_card.dart';
import 'package:trash_hunter/Pages/login_page.dart';
import 'package:trash_hunter/Pages/posts_page.dart';
import '../Constants/Buttons/primary_button.dart';
import '../Constants/notifiers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data via notifier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: HeadingTexts(
            text: 'Profile',
            type: HeadingType.h2,
            color: Colors.black,
          ),
        ),
      ),
      body: ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: userDataNotifier,
        builder: (context, userData, _) {
          if (userData == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          final fullName = "${userData['firstName']} ${userData['lastName']}";
          final email = userData['email'];

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  UserInfoCard(fullName: fullName, email: email),
                  const SizedBox(height: 32),
                  PostsCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Logout',
                    height: 50,
                    width: double.infinity,
                    onPressed: () async {
                      await _auth.signOut();
                      userDataNotifier.value = null; // Clear user data
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
