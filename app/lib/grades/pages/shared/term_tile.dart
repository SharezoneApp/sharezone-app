// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page.dart';

class TermTile extends StatelessWidget {
  const TermTile({
    super.key,
    required this.displayName,
    required this.avgGrade,
    required this.title,
    required this.termId,
    this.showEditButton = true,
  });

  final TermId termId;
  final bool showEditButton;
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
          Row(
            children: [
              if (showEditButton) ...[
                _EditIconButton(termId: termId),
                const SizedBox(width: 6),
              ],
              _TermGrade(grade: avgGrade),
            ],
          )
        ],
      ),
    );
  }
}

class _EditIconButton extends StatelessWidget {
  const _EditIconButton({
    required this.termId,
  });

  final TermId termId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Bearbeiten des Schnitts',
      icon: const Icon(Icons.edit),
      color: Theme.of(context).listTileTheme.iconColor,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TermSettingsPage(termId: termId),
        ),
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
