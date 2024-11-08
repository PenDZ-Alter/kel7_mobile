import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget targetPage;
  final String message;
  final bool isRevert;

  const SplashScreen({
    super.key, 
    required this.targetPage, 
    required this.message,
    this.isRevert = false
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Create a curved animation for smooth water rising effect
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to the target page after animation
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.targetPage),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: widget.isRevert ? Colors.orangeAccent : Colors.deepPurple,
      body: Stack(
        children: [
          // Water animation
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              print("Height from Media Query : " + MediaQuery.of(context).size.height.toString());
              return ClipPath(
                clipper: WaveClipper(_animation.value),
                child: Container(
                  color: widget.isRevert ? Colors.deepPurple : Colors.orangeAccent,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                ),
              );
            },
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for wave effect
class WaveClipper extends CustomClipper<Path> {
  final double progress;

  WaveClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final h = size.height;
    final w = size.width;

    // Calculate wave parameters
    final waveHeight = 20.0;
    final phase = progress * 2 * 3.14159;
    final baseHeight = h - (h * progress);

    path.moveTo(0, h);
    path.lineTo(0, baseHeight);

    // Create wave pattern
    for (var i = 0.0; i <= w; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / w * 4 * 3.14159) + phase) * waveHeight,
      );
    }

    path.lineTo(w, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}