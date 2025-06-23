import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();

  Future<void> _fetchProfile() async {
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    setState(() {
      firstNameController.text = response['first_name'] ?? '';
      lastNameController.text = response['last_name'] ?? '';
      birthdateController.text = response['birthdate'] ?? '';
      phoneController.text = response['phone'] ?? '';
    });
  }

  Future<void> _pickBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(birthdateController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdateController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _updateProfile() async {
    final userId = supabase.auth.currentUser?.id;

    try {
      await supabase.from('profiles').update({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'birthdate': birthdateController.text,
        'phone': phoneController.text,
      }).eq('id', userId);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Profil berhasil diperbarui.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Gagal update: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthdateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
              controller: birthdateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
              onTap: _pickBirthdate,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'No. Telepon'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
