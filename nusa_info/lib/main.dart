import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NusaInfoApp());
}

class NusaInfoApp extends StatelessWidget {
  const NusaInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NusaInfo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}