import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Constants/Buttons/primary_button.dart';
import '../Constants/TextField/custom_textfield.dart';
import '../Constants/TextsStyles/body_texts.dart';
import '../Constants/TextsStyles/heading_texts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final TextEditingController _passwordController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();

bool isPasswordVisible = false;

class _SignUpPageState extends State<SignUpPage> {
  Future<void> createUserWithEmailAndPassword() async {
    try {
      //Authentication
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //Add user details to users db
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user?.uid)
          .set({
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        'saved': [],
        'created': []
      });

      //added becasue createUserWithEmailAndPassword automatically log user in
      FirebaseAuth.instance.signOut();

      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //Petaei error otna kaneis logout kai patas sign up
  // @override
  // void dispose() {
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeadingTexts(
                text: "SIGN UP",
                type: HeadingType.h1,
                color: Colors.black,
              ),
              const SizedBox(height: 40),
              CustomTextfield(
                controller: _firstNameController,
                label: 'First Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: _lastNameController,
                label: 'Last Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: _emailController,
                label: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                controller: _passwordController,
                label: "Password",
                obscureText: !isPasswordVisible,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BodyTexts(
                    text: "Already have an account? ",
                    type: BodyTextType.s,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const BodyTexts(
                      text: "Login Here",
                      type: BodyTextType.s_bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: 'REGISTER',
                height: 50,
                width: 120,
                onPressed: () async {
                  createUserWithEmailAndPassword();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
