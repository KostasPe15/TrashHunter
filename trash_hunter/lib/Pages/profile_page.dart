import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants/Buttons/primary_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Signed in as: ${auth.currentUser?.email ?? 'Unknown'}"),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Logout',
              height: 50,
              width: 120,
              onPressed: () async {
                await auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
