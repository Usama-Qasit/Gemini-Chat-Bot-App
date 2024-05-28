import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gemini_chat_bot/gemini_chat_screen.dart';

class GeminiSplashScreen extends StatefulWidget {
  @override
  _GeminiSplashScreenState createState() => _GeminiSplashScreenState();
}

class _GeminiSplashScreenState extends State<GeminiSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/gemini.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,

              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Gemini Chat Bot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
