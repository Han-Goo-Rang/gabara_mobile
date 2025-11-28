import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/class_entity.dart';
import '../../../../core/constants/app_colors.dart';

class ClassCard extends StatelessWidget {
  final ClassEntity classEntity;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isMentor;
  final int enrolledCount;

  const ClassCard({
    super.key,
    required this.classEntity,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isMentor = false,
    this.enrolledCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap:
            onTap ??
            () {
              Navigator.pushNamed(
                context,
                '/class-detail',
                arguments: classEntity,
              );
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image dengan Peta Indonesia
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Image
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/indonesia.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Badge Tahun Ajaran (kiri atas)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '2025/2026',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Avatar Tutor (kanan) - posisi overlap
                Positioned(
                  top: 100,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        _getInitials(classEntity.tutorName),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // Menu untuk Mentor (Edit/Delete)
                if (isMentor)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) onEdit!();
                        if (value == 'delete' && onDelete != null) onDelete!();
                        if (value == 'copy' && classEntity.classCode != null) {
                          Clipboard.setData(
                            ClipboardData(text: classEntity.classCode!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode kelas disalin!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        if (classEntity.classCode != null)
                          PopupMenuItem(
                            value: 'copy',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text('Salin Kode: ${classEntity.classCode}'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Edit Kelas'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Hapus Kelas',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Content Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kelas
                  Text(
                    classEntity.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi
                  Text(
                    classEntity.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Footer
                  Row(
                    children: [
                      // Participant Avatars (dummy untuk sekarang)
                      ..._buildParticipantAvatars(),
                      const Spacer(),
                      // Mentor Name
                      Text(
                        'Mentor: ${classEntity.tutorName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticipantAvatars() {
    // Untuk sementara tampilkan placeholder avatars
    // Nanti bisa diisi dari data real enrolled students
    final List<String> dummyParticipants = ['GF', 'DM', 'FN'];
    final int additionalCount = classEntity.maxStudents > 3
        ? (enrolledCount > 3 ? enrolledCount - 3 : 1)
        : 0;

    final List<Widget> avatars = [];

    for (int i = 0; i < dummyParticipants.length && i < 3; i++) {
      avatars.add(
        Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 0),
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(i),
              child: Text(
                dummyParticipants[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // +N indicator
    if (additionalCount > 0) {
      avatars.add(
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              '+$additionalCount',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return avatars;
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF64B5F6), // Blue
      const Color(0xFF81C784), // Green
      const Color(0xFFFFB74D), // Orange
    ];
    return colors[index % colors.length];
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
