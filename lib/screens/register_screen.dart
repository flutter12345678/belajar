import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  /// Fungsi untuk membuka DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdateController.text = picked.toIso8601String().split('T').first; // Format: yyyy-mm-dd
      });
    }
  }

  Future<void> register() async {
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await supabase.from('profiles').insert({
        'id': response.user!.id,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'birthdate': birthdateController.text,
        'phone': phoneController.text,
        'avatar_url': null,
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registrasi Berhasil'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Nama Depan'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Nama Belakang'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: birthdateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                onTap: () => _selectDate(context),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
