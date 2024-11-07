import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/pages/login.dart';
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");

  WidgetsFlutterBinding.ensureInitialized();

  // Only apply constraints if the app is running on desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My Flutter App');
    setWindowMinSize(const Size(400, 600));  // Minimum window size
    setWindowMaxSize(const Size(1200, 800)); // Maximum window size
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo Integration Group 7',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
