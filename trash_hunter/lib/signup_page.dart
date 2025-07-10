import 'package:flutter/material.dart';
import 'package:trash_hunter/login_page.dart';

void main() {
  runApp(
    const MaterialApp(home: SignUpPage(), debugShowCheckedModeBanner: false),
  );
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
              const Text(
                "SIGN UP",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: "Full Name",
                  border: UnderlineInputBorder(),
                ),
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
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Password",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
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
                    child: const Text(
                      "Login Here",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle sign up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 60,
                  ),
                ),
                child: const Text(
                  "REGISTER",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
