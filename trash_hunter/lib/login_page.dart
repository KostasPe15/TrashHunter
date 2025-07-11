import 'package:flutter/material.dart';
import 'package:trash_hunter/Buttons/primary_button.dart';
import 'package:trash_hunter/TextField/custom_textfield.dart';
import 'package:trash_hunter/TextsStyles/body_texts.dart';
import 'package:trash_hunter/TextsStyles/heading_texts.dart';
import 'package:trash_hunter/signup_page.dart';

void main() {
  runApp(
    MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose(); 
  }

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
                text: "SIGN IN",
                type: HeadingType.h1,
                color: Colors.black,
              ),
              const SizedBox(height: 40),
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
                    text: "Don't have an account? ",
                    type: BodyTextType.s,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpPage();
                          },
                        ),
                      );
                    },
                    child: BodyTexts(
                      text: "Register Here",
                      type: BodyTextType.s_bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: 'LOGIN',
                height: 50,
                width: 120,
                
                onPressed: () {
                  // Handle login
                },
                
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
