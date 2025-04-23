import 'package:flutter/material.dart';
import 'menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.green,
        ),
      ),
      home: MenuScreen(),
    );
  }
}
