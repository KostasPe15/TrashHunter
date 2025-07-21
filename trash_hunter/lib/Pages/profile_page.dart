import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trash_hunter/Pages/login_page.dart';
import '../Constants/Buttons/primary_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? firstName;
  String? lastName;
  String? email;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final user = auth.currentUser;
    if (user == null) return;

    final docSnapshot = await firestore.collection('users').doc(user.uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        firstName = data?['first_name'];
        lastName = data?['last_name'];
        email = user.email;
      });
    } else {
      setState(() {
        firstName = 'Unknown';
        email = user.email ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Signed in as:"),
            const SizedBox(height: 8),
            Text("First name: ${firstName}"),
            const SizedBox(height: 8),
            Text("Last name: ${lastName}"),
            const SizedBox(height: 8),
            Text("Email: ${email}"),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Logout',
              height: 50,
              width: 120,
              onPressed: () async {
                await auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
