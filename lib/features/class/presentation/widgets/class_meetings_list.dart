// lib/features/class/presentation/widgets/class_meetings_list.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Widget untuk menampilkan daftar pertemuan/materi dalam sebuah kelas
/// Saat ini masih placeholder, akan diimplementasikan lebih lanjut
class ClassMeetingsList extends StatelessWidget {
  final String classId;
  final bool isMentor;

  const ClassMeetingsList({
    super.key,
    required this.classId,
    this.isMentor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: primaryBlue, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Pertemuan & Materi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (isMentor)
                IconButton(
                  onPressed: () => _showAddMeetingDialog(context),
                  icon: Icon(Icons.add_circle_outline, color: primaryBlue),
                  tooltip: 'Tambah Pertemuan',
                ),
            ],
          ),
        ),

        // Empty state (placeholder)
        _buildEmptyState(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            isMentor
                ? 'Belum ada pertemuan untuk kelas ini'
                : 'Belum ada materi yang tersedia',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Fitur pertemuan akan segera hadir',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddMeetingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Segera Hadir'),
        content: const Text(
          'Fitur untuk menambah pertemuan dan materi akan segera tersedia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Widget item untuk setiap pertemuan (untuk implementasi selanjutnya)
class MeetingListItem extends StatelessWidget {
  final String title;
  final String? description;
  final DateTime? date;
  final List<String>? materials;
  final List<String>? assignments;
  final VoidCallback? onTap;

  const MeetingListItem({
    super.key,
    required this.title,
    this.description,
    this.date,
    this.materials,
    this.assignments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.event_note, color: primaryBlue, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (date != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(date!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(
                  description!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if ((materials?.isNotEmpty ?? false) ||
                  (assignments?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (materials?.isNotEmpty ?? false)
                      _buildCountChip(
                        Icons.description_outlined,
                        '${materials!.length} materi',
                      ),
                    if ((materials?.isNotEmpty ?? false) &&
                        (assignments?.isNotEmpty ?? false))
                      const SizedBox(width: 12),
                    if (assignments?.isNotEmpty ?? false)
                      _buildCountChip(
                        Icons.assignment_outlined,
                        '${assignments!.length} tugas',
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
