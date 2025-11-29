import 'package:flutter/material.dart';
import 'class_quiz_list.dart';
import 'class_meetings_list.dart';

// =================================================================
// TAB 1: KURSUS (QUIZ + MATERI & PERTEMUAN)
// =================================================================
class ClassCourseTab extends StatelessWidget {
  final String? classId;
  final bool isMentor;

  const ClassCourseTab({super.key, this.classId, this.isMentor = false});

  @override
  Widget build(BuildContext context) {
    // Jika classId null, tampilkan empty state
    if (classId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              "Materi Kursus",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Belum ada materi atau pertemuan.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Tampilkan layout dengan Quiz di atas dan Meetings di bawah
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Section 1: Daftar Quiz
          ClassQuizList(classId: classId!, isMentor: isMentor),

          const SizedBox(height: 24),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey.shade300),
          ),

          const SizedBox(height: 8),

          // Section 2: Daftar Pertemuan & Materi
          ClassMeetingsList(classId: classId!, isMentor: isMentor),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// =================================================================
// TAB 2: PESERTA - Empty State
// =================================================================
class ClassParticipantsTab extends StatelessWidget {
  final String? classId;

  const ClassParticipantsTab({super.key, this.classId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Peserta Kelas",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Belum ada peserta terdaftar.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// TAB 3: DISKUSI - Empty State
// =================================================================
class ClassDiscussionTab extends StatelessWidget {
  final String? classId;

  const ClassDiscussionTab({super.key, this.classId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Forum Diskusi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Belum ada diskusi yang dimulai.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// TAB 4: NILAI - Empty State
// =================================================================
class ClassGradesTab extends StatelessWidget {
  final String? classId;

  const ClassGradesTab({super.key, this.classId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grade_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Nilai",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Belum ada nilai yang tersedia.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
