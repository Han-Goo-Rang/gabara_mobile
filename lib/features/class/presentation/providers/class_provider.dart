import 'package:flutter/material.dart';
import '../../data/models/class_model.dart';
import '../../data/services/class_service.dart';

class ClassProvider extends ChangeNotifier {
  final ClassService classService;

  ClassProvider(this.classService);

  List<ClassModel> _classes = [];
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ClassModel> get classes => _classes;
  List<Map<String, dynamic>> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch enrolled classes (for student)
  Future<void> fetchClasses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await classService.getEnrolledClasses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch classes created by mentor
  Future<void> fetchMyClasses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await classService.getMyClasses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubjects() async {
    try {
      _subjects = await classService.getSubjects();
      notifyListeners();
    } catch (e) {
      debugPrint("Gagal ambil subjects: $e");
    }
  }

  Future<bool> createClass({
    required String name,
    required String description,
    required int subjectId,
    required int maxStudents,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await classService.createClass(
        name: name,
        description: description,
        subjectId: subjectId,
        maxStudents: maxStudents,
      );
      // Refresh kelas mentor setelah create
      await fetchMyClasses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update class
  Future<bool> updateClass({
    required String classId,
    required String name,
    required String description,
    required int subjectId,
    required int maxStudents,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await classService.updateClass(
        classId: classId,
        name: name,
        description: description,
        subjectId: subjectId,
        maxStudents: maxStudents,
      );
      await fetchMyClasses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete class
  Future<bool> deleteClass(String classId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await classService.deleteClass(classId);
      await fetchMyClasses();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Join class by code (for student)
  Future<bool> joinClass(String classCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await classService.joinClass(classCode);
      await fetchClasses();
      return true;
    } catch (e) {
      _errorMessage = "Kode kelas tidak valid atau sudah bergabung.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
