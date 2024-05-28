import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_chat_bot/consts.dart';
import 'package:gemini_chat_bot/gemini_chat_screen.dart';
import 'package:gemini_chat_bot/gemini_splash_screen.dart';
import 'package:gemini_chat_bot/prompt_screen.dart';
import 'package:gemini_chat_bot/splash_screen.dart';
import 'package:gemini_chat_bot/text_recognition.dart';
import 'package:gemini_chat_bot/text_summarizer.dart';

import 'label_image.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home:    GeminiSplashScreen(),
    );
  }
}
