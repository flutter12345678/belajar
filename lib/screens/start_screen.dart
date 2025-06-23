import 'package:flutter/material.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('HireLink', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Mulai'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
