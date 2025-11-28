import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// =================================================================
// TAB 1: KURSUS (MATERI & PERTEMUAN)
// =================================================================
class ClassCourseTab extends StatelessWidget {
  const ClassCourseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Card Deskripsi Kelas
        Card(
          elevation: 0,
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Mata pelajaran Bahasa Indonesia ini dirancang untuk mengembangkan keterampilan berbahasa yang meliputi menyimak, berbicara, membaca, dan menulis secara efektif.",
              style: TextStyle(height: 1.5, color: Colors.black87),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Pertemuan 1
        _buildMeetingCard(
          context,
          title: "Pertemuan 1 - Pentingnya Bahasa Indonesia sebagai Identitas Nasional",
          description: "Pada pertemuan pertama, siswa akan mempelajari mengenai kedudukan dan fungsi Bahasa Indonesia.",
          items: [
            _buildItemRow(context, Icons.description, "Berkas", "Lihat Materi PDF", Colors.blue),
            _buildItemRow(context, Icons.assignment, "Tugas", "Tugas 1 (Deadline: Besok)", Colors.orange),
            _buildItemRow(context, Icons.quiz, "Kuis", "Kuis 1: Pemahaman Teks", Colors.purple),
          ],
        ),

        const SizedBox(height: 16),

        // Pertemuan 2
        _buildMeetingCard(
          context,
          title: "Pertemuan 2 - Teks Eksposisi",
          description: "Membahas struktur dan kaidah kebahasaan teks eksposisi.",
          items: [
             _buildItemRow(context, Icons.video_library, "Video", "Rekaman Pembelajaran", Colors.red),
             _buildItemRow(context, Icons.forum, "Diskusi", "Forum Diskusi Kelompok", Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildMeetingCard(BuildContext context, {required String title, required String description, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            const Divider(),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, IconData icon, String type, String title, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Membuka $title")));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// TAB 2: PESERTA
// =================================================================
class ClassParticipantsTab extends StatelessWidget {
  const ClassParticipantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> participants = [
      {'name': 'Gilang Permana', 'initial': 'GP'},
      {'name': 'Dian Maharani', 'initial': 'DM'},
      {'name': 'Fajar Nugroho', 'initial': 'FN'},
      {'name': 'Melati Kusuma', 'initial': 'MK'},
      {'name': 'Rizky Saputra', 'initial': 'RS'},
      {'name': 'Siti Aminah', 'initial': 'SA'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari peserta berdasarkan nama...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final p = participants[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black54,
                  child: Text(p['initial']!),
                ),
                title: Text(p['name']!),
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

// =================================================================
// TAB 3: DISKUSI
// =================================================================
class ClassDiscussionTab extends StatelessWidget {
  const ClassDiscussionTab({super.key});

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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Buat Diskusi")));
            },
            icon: const Icon(Icons.add),
            label: const Text("Mulai Diskusi Baru"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

// =================================================================
// TAB 4: NILAI
// =================================================================
class ClassGradesTab extends StatelessWidget {
  const ClassGradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Card Ringkasan
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ringkasan Nilai", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGradeSummary("Tugas", "85.0", Colors.blue),
                    _buildGradeSummary("Kuis", "90.0", Colors.orange),
                    _buildGradeSummary("Ujian", "-", Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Detail Penilaian", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // Tabel Nilai
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildGradeItem("Tugas 1", "Membuat Puisi", "90", "Sangat bagus!"),
              const Divider(height: 1),
              _buildGradeItem("Kuis 1", "Pemahaman Teks", "80", "-"),
              const Divider(height: 1),
              _buildGradeItem("Tugas 2", "Analisis Struktur", "-", "Belum dinilai"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSummary(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGradeItem(String category, String title, String score, String feedback) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(score, 
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: score == "-" ? Colors.grey : Colors.black)
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(feedback, 
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: Colors.grey)
            ),
          ),
        ],
      ),
    );
  }
}