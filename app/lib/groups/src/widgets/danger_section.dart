// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class DangerSection extends StatelessWidget {
  const DangerSection({
    super.key,
    this.onPressedLeaveButton,
    this.onPressedDeleteButton,
    required this.hasDeleteButton,
    required this.leaveButtonLabel,
    required this.deleteButtonLabel,
  });

  final VoidCallback? onPressedLeaveButton;
  final VoidCallback? onPressedDeleteButton;
  final bool hasDeleteButton;
  final Widget leaveButtonLabel;
  final Widget deleteButtonLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        children: [
          _LeaveButton(
            onPressed: onPressedLeaveButton,
            label: leaveButtonLabel,
          ),
          if (hasDeleteButton)
            _DeleteSchoolClassButton(
              onPressed: onPressedDeleteButton,
              label: deleteButtonLabel,
            ),
        ],
      ),
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return DangerButtonOutlined(
      onPressed: onPressed,
      label: label,
      icon: const Icon(Icons.exit_to_app),
    );
  }
}

class DangerButtonOutlined extends StatelessWidget {
  const DangerButtonOutlined({
    super.key,
    this.onPressed,
    required this.label,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton.icon(
        icon: icon,
        style: FilledButton.styleFrom(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.red,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.red.withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(512),
          ),
        ),
        onPressed: onPressed,
        label: label,
      ),
    );
  }
}

class DangerButtonFilled extends StatelessWidget {
  const DangerButtonFilled({
    super.key,
    this.onPressed,
    required this.label,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton.icon(
        icon: icon,
        style: FilledButton.styleFrom(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        onPressed: onPressed,
        label: label,
      ),
    );
  }
}

class _DeleteSchoolClassButton extends StatelessWidget {
  const _DeleteSchoolClassButton({
    this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return DangerButtonFilled(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      label: label,
    );
  }
}
