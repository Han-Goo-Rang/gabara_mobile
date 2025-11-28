import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_model.dart';

class ClassService {
  final SupabaseClient supabaseClient;

  ClassService(this.supabaseClient);

  // Get enrolled classes (for student)
  Future<List<ClassModel>> getEnrolledClasses() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return [];

      // Get enrollments first
      final enrollments = await supabaseClient
          .from('class_enrollments')
          .select('class_id')
          .eq('user_id', user.id)
          .eq('status', 'active');

      if ((enrollments as List).isEmpty) return [];

      final classIds = enrollments.map((e) => e['class_id']).toList();

      // Get classes with subjects
      final response = await supabaseClient
          .from('classes')
          .select(
            'id, name, description, class_code, max_students, is_active, created_at, tutor_id, subjects(name)',
          )
          .inFilter('id', classIds)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;

      // Fetch tutor names
      return await _mapClassesWithTutorNames(data);
    } catch (e) {
      debugPrint('Error getEnrolledClasses: $e');
      return [];
    }
  }

  // Get classes created by mentor (tutor_id = current user)
  Future<List<ClassModel>> getMyClasses() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return [];

      final response = await supabaseClient
          .from('classes')
          .select(
            'id, name, description, class_code, max_students, is_active, created_at, tutor_id, subject_id, subjects(name)',
          )
          .eq('tutor_id', user.id)
          .eq('is_active', true) // Hanya ambil kelas aktif
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;

      // Fetch tutor names
      return await _mapClassesWithTutorNames(data);
    } catch (e) {
      debugPrint('Error getMyClasses: $e');
      return [];
    }
  }

  // Helper: Map classes with tutor names from profiles
  Future<List<ClassModel>> _mapClassesWithTutorNames(
    List<dynamic> classes,
  ) async {
    if (classes.isEmpty) return [];

    // Get unique tutor IDs
    final tutorIds = classes
        .map((c) => c['tutor_id'] as String?)
        .where((id) => id != null)
        .toSet()
        .toList();

    // Fetch profiles for tutors
    Map<String, String> tutorNames = {};
    if (tutorIds.isNotEmpty) {
      final profiles = await supabaseClient
          .from('profiles')
          .select('id, full_name')
          .inFilter('id', tutorIds);

      for (var profile in profiles) {
        tutorNames[profile['id']] = profile['full_name'] ?? 'Mentor';
      }
    }

    // Map to ClassModel with tutor names
    return classes.map((json) {
      final tutorId = json['tutor_id'] as String?;
      final tutorName = tutorNames[tutorId] ?? 'Mentor';

      return ClassModel.fromJson({
        ...json,
        'tutor': {'full_name': tutorName},
      });
    }).toList();
  }

  // Generate unique class code
  String _generateClassCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // Create new class
  Future<void> createClass({
    required String name,
    required String description,
    required int subjectId,
    required int maxStudents,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    final classCode = _generateClassCode();

    await supabaseClient.from('classes').insert({
      'name': name,
      'description': description,
      'subject_id': subjectId,
      'tutor_id': user.id,
      'max_students': maxStudents,
      'class_code': classCode,
      'is_active': true,
    });
  }

  // Update class
  Future<void> updateClass({
    required String classId,
    required String name,
    required String description,
    required int subjectId,
    required int maxStudents,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    await supabaseClient
        .from('classes')
        .update({
          'name': name,
          'description': description,
          'subject_id': subjectId,
          'max_students': maxStudents,
        })
        .eq('id', classId)
        .eq('tutor_id', user.id);
  }

  // Delete class (soft delete - set is_active = false)
  // Note: Hard delete memerlukan RLS policy update di Supabase
  Future<void> deleteClass(String classId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    // Soft delete: set is_active = false
    final response = await supabaseClient
        .from('classes')
        .update({'is_active': false})
        .eq('id', classId)
        .eq('tutor_id', user.id)
        .select();

    if ((response as List).isEmpty) {
      throw Exception(
        'Gagal menghapus kelas. Pastikan Anda adalah pemilik kelas ini.',
      );
    }
  }

  // Get subjects list
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

  // Join class by code (for student)
  Future<void> joinClass(String classCode) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    // Find class by code
    final classData = await supabaseClient
        .from('classes')
        .select('id')
        .eq('class_code', classCode.toUpperCase())
        .eq('is_active', true)
        .maybeSingle();

    if (classData == null) {
      throw Exception('Kode kelas tidak ditemukan');
    }

    // Enroll student
    await supabaseClient.from('class_enrollments').insert({
      'class_id': classData['id'],
      'user_id': user.id,
      'status': 'active',
    });
  }

  // Get enrolled students count for a class
  Future<int> getEnrolledCount(String classId) async {
    try {
      final response = await supabaseClient
          .from('class_enrollments')
          .select('id')
          .eq('class_id', classId)
          .eq('status', 'active');
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
