import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tugas1_ui/pages/login.dart';
import 'package:tugas1_ui/pages/splash_screen_app.dart';
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");

  WidgetsFlutterBinding.ensureInitialized();

  // Only apply constraints if the app is running on desktop
  if (Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isFuchsia) {
    setWindowTitle('Alumni Finder');
    var windowInfo = await getWindowInfo();
    var size = windowInfo.frame.size;
    setWindowMinSize(
        Size(size.width * 0.3125, size.height * 0.8333)); // Minimum window size
    setWindowMaxSize(
        Size(size.width * 1.5, size.height * 1.5)); // Maximum window size
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
      home: const SplashScreenApp(
          targetPage: LoginPage(), message: "Alumni Finder App"),
      debugShowCheckedModeBanner: false,
    );
  }
}
