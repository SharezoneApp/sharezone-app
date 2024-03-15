import 'package:flutter/material.dart';
import 'package:sharezone/grades/pages/grades_view.dart';

class TermTile extends StatelessWidget {
  const TermTile({
    super.key,
    required this.displayName,
    required this.avgGrade,
    required this.title,
  });

  final String title;
  final DisplayName displayName;
  final AvgGradeView avgGrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _TermGrade(grade: avgGrade)
        ],
      ),
    );
  }
}

class _TermGrade extends StatelessWidget {
  const _TermGrade({required this.grade});

  final AvgGradeView grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grade.$2.toColor().withOpacity(0.1),
      ),
      child: Text(
        '⌀ ${grade.$1}',
        style: TextStyle(
          color: grade.$2.toColor(),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
