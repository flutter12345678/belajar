import 'package:flutter/material.dart';
import 'start_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StartScreen()),
                );
              });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
