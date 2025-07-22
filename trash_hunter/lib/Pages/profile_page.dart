import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trash_hunter/Constants/TextsStyles/body_texts.dart';
import 'package:trash_hunter/Constants/TextsStyles/heading_texts.dart';
import 'package:trash_hunter/Constants/posts_card.dart';
import 'package:trash_hunter/Constants/user_info_card.dart';
import 'package:trash_hunter/Pages/login_page.dart';
import 'package:trash_hunter/Pages/posts_page.dart';
import '../Constants/Buttons/primary_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? firstName;
  String? lastName;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    setState(() => _isLoading = true);

    final user = auth.currentUser;
    if (user == null) return;

    final docSnapshot = await firestore.collection('users').doc(user.uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        firstName = data?['first_name'];
        lastName = data?['last_name'];
        _nameController.text = "${firstName ?? ''} ${lastName ?? ''}";
        _emailController.text = user.email ?? '';
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: const HeadingTexts(
          text: 'Profile',
          type: HeadingType.h2,
          color: Colors.black,
        )),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    UserInfoCard(
                      fullName: _nameController.text,
                      email: _emailController.text,
                    ),
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
                        await auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyTexts(
                text: label,
                type: BodyTextType.s,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              BodyTexts(
                text: value,
                type: BodyTextType.l,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }
}
