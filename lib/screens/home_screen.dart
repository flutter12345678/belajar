import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutterya'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
            const SizedBox(height: 10),
            Text(user?.email ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
              child: const Text('Edit Profil'),
            ),
            const Divider(),
            ListTile(title: const Text('Personal Info'), onTap: () {}),
            ListTile(title: const Text('Application'), onTap: () {}),
            ListTile(title: const Text('Portofolio'), onTap: () {}),
            ListTile(title: const Text('Setting'), onTap: () {}),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Selamat datang di Flutterya!')),
    );
  }
}
