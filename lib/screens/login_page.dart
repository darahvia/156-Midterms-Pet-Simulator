import 'package:flutter/material.dart';
import '../widgets/pixel_button.dart';
import 'start_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Username not found');
      }

      final email = snapshot.docs.first['email'] as String;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StartScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/outdoor.png', fit: BoxFit.cover),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/PixelPawLogo_fin.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.pressStart2p(fontSize: 12),
                      ),
                      style: GoogleFonts.pressStart2p(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.pressStart2p(fontSize: 12),
                      ),
                      style: GoogleFonts.pressStart2p(fontSize: 12),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    PixelButton(
                      label: 'Login',
                      icon: Icons.login,
                      color: Colors.yellow,
                      onPressed: login,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Create an account',
                        style: GoogleFonts.pressStart2p(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
