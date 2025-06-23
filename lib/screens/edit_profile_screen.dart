import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? avatarUrl;
  File? _selectedImage;

  Future<void> _fetchProfile() async {
    final userId = supabase.auth.currentUser?.id;
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    setState(() {
      firstNameController.text = data['first_name'] ?? '';
      lastNameController.text = data['last_name'] ?? '';
      birthdateController.text = data['birthdate'] ?? '';
      phoneController.text = data['phone'] ?? '';
      avatarUrl = data['avatar_url'];
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile, String userId) async {
    final fileExt = imageFile.path.split('.').last;
    final filePath = 'avatars/$userId.$fileExt';

    final fileBytes = await imageFile.readAsBytes();

    final res = await supabase.storage.from('avatars').uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$fileExt',
          ),
        );

    final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
    return publicUrl;
  }

  Future<void> _updateProfile() async {
    final userId = supabase.auth.currentUser?.id;
    String? newAvatarUrl = avatarUrl;

    if (_selectedImage != null) {
      newAvatarUrl = await _uploadImage(_selectedImage!, userId!);
    }

    try {
      await supabase.from('profiles').update({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'birthdate': birthdateController.text,
        'phone': phoneController.text,
        'avatar_url': newAvatarUrl,
      }).eq('id', userId);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Profil berhasil diperbarui.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Gagal: ${e.toString()}'),
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

  Widget _buildAvatar() {
    if (_selectedImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else if (avatarUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _buildAvatar(),
              ),
            ),
            const SizedBox(height: 16),
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