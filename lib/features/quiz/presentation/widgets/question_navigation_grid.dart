// lib/features/quiz/presentation/widgets/question_navigation_grid.dart
// Requirements: 4.6, 4.7, 4.8

import 'package:flutter/material.dart';

class QuestionNavigationGrid extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final bool Function(int) isAnswered;
  final void Function(int) onTap;

  const QuestionNavigationGrid({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(totalQuestions, (index) {
        final isCurrent = index == currentIndex;
        final answered = isAnswered(index);

        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getBackgroundColor(isCurrent, answered),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getBorderColor(isCurrent, answered),
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: _getTextColor(isCurrent, answered),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getBackgroundColor(bool isCurrent, bool answered) {
    if (isCurrent) {
      return Colors.blue;
    }
    if (answered) {
      return Colors.blue.shade50;
    }
    return Colors.white;
  }

  Color _getBorderColor(bool isCurrent, bool answered) {
    if (isCurrent) {
      return Colors.blue;
    }
    if (answered) {
      return Colors.blue.shade200;
    }
    return Colors.grey.shade300;
  }

  Color _getTextColor(bool isCurrent, bool answered) {
    if (isCurrent) {
      return Colors.white;
    }
    if (answered) {
      return Colors.blue.shade700;
    }
    return Colors.grey.shade600;
  }
}
