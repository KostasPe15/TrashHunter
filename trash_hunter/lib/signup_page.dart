import 'package:flutter/material.dart';
import 'package:trash_hunter/Buttons/primary_button.dart';
import 'package:trash_hunter/TextField/custom_textfield.dart';
import 'package:trash_hunter/TextsStyles/body_texts.dart';
import 'package:trash_hunter/TextsStyles/heading_texts.dart';
import 'package:trash_hunter/login_page.dart';

void main() {
  runApp(
    const MaterialApp(home: SignUpPage(), debugShowCheckedModeBanner: false),
  );
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final TextEditingController _passwordController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _nameController = TextEditingController();


bool isPasswordVisible = false;

class _SignUpPageState extends State<SignUpPage> {
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
                controller: _emailController,
                label: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                  border: UnderlineInputBorder(),
                ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
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
                onPressed: () {
                  // Handle sign up
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
