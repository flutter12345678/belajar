import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<void> insertUser(Map<String, dynamic> data) async {
    await _client.from('profiles').insert(data);
  }

  Future<Map<String, dynamic>?> getUserProfile(String id) async {
    final res = await _client.from('profiles').select().eq('id', id).single();
    return res;
  }
}
