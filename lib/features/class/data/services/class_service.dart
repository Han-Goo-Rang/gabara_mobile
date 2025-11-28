import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_model.dart';

class ClassService {
  final SupabaseClient supabaseClient;

  ClassService(this.supabaseClient);

  Future<List<ClassModel>> getClasses() async {
    try {
      final response = await supabaseClient
          .from('classes')
          .select('*, subjects(name), tutor:profiles(full_name)')
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      // Jika error (misal tabel belum ada), return list kosong dummy untuk testing UI
      return []; 
    }
  }

  Future<void> createClass({
    required String name,
    required String description,
    required int subjectId,
    required int maxStudents,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    await supabaseClient.from('classes').insert({
      'name': name,
      'description': description,
      'subject_id': subjectId,
      'tutor_id': user.id,
      'max_students': maxStudents,
      'is_active': true,
    });
  }
  
  Future<List<Map<String, dynamic>>> getSubjects() async {
    try {
      final response = await supabaseClient
          .from('subjects')
          .select('id, name')
          .order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // --- FUNGSI BARU: JOIN CLASS (Simulasi) ---
  Future<void> joinClass(String classCode) async {
    // Di sini seharusnya memanggil API Supabase untuk cek kode dan insert ke class_enrollments
    // Untuk dummy/simulasi saat ini, kita anggap sukses setelah delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Jika ingin implementasi real nanti:
    /*
    final classData = await supabaseClient
        .from('classes')
        .select('id')
        .eq('class_code', classCode)
        .single();
    
    await supabaseClient.from('class_enrollments').insert({
      'class_id': classData['id'],
      'user_id': supabaseClient.auth.currentUser!.id,
    });
    */
  }
}