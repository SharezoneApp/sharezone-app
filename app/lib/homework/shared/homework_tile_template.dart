// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class HomeworkTileTemplate extends StatelessWidget {
  final String title;
  final String courseName;
  final String todoDate;
  final Color? todoDateColor;
  final Color courseColor;
  final String courseAbbreviation;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String? heroTag;
  final bool isCompleted;

  const HomeworkTileTemplate({
    super.key,
    required this.title,
    required this.courseName,
    required this.todoDate,
    required this.todoDateColor,
    required this.courseColor,
    required this.courseAbbreviation,
    required this.trailing,
    required this.onTap,
    required this.onLongPress,
    required this.isCompleted,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.0),
      child: CustomCard(
        child: ListTile(
          minVerticalPadding: 4,
          dense: true,
          title: _Title(
            title: title,
            isCompleted: isCompleted,
          ),
          subtitle: _Subtitle(
            courseName: courseName,
            todoDate: todoDate,
            todoDateColor: todoDateColor,
            isCompleted: isCompleted,
          ),
          leading: CircleAvatar(
            backgroundColor: courseColor.withOpacity(0.2),
            child: _StrikeThrough(
              isStrikeThrough: isCompleted,
              delay: const Duration(milliseconds: 50),
              child: Text(
                courseAbbreviation,
                style: TextStyle(color: courseColor),
              ),
            ),
          ),
          trailing: trailing,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.courseName,
    required this.todoDate,
    required this.todoDateColor,
    required this.isCompleted,
  });

  final String courseName;
  final String todoDate;
  final Color? todoDateColor;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StrikeThrough(
            isStrikeThrough: isCompleted,
            delay: const Duration(milliseconds: 100),
            child: Text(
              courseName,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 4),
          _StrikeThrough(
            isStrikeThrough: isCompleted,
            delay: const Duration(milliseconds: 200),
            child: Text(todoDate, style: TextStyle(color: todoDateColor)),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.isCompleted,
  });

  final String title;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StrikeThrough(
          isStrikeThrough: isCompleted,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ),
        // A ListTile widget expands the title to the full width of the screen.
        // This would cause the strike through to be drawn over the whole
        // screen. To prevent this, we add a spacer that takes up the remaining
        // space.
        const Spacer(),
      ],
    );
  }
}

class _StrikeThrough extends StatefulWidget {
  const _StrikeThrough({
    required this.isStrikeThrough,
    required this.child,
    this.delay = Duration.zero,
  });

  final bool isStrikeThrough;
  final Duration delay;
  final Widget child;

  @override
  State<_StrikeThrough> createState() => _StrikeThroughState();
}

class _StrikeThroughState extends State<_StrikeThrough>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final begin = widget.isStrikeThrough ? 1.0 : 0.0;
    final end = widget.isStrikeThrough ? 0.0 : 1.0;

    animation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInQuart),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(_StrikeThrough oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStrikeThrough != widget.isStrikeThrough) {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: CustomPaint(
            painter:
                _StrikeThroughPainter(animation.value, widget.isStrikeThrough),
          ),
        ),
      ],
    );
  }
}

class _StrikeThroughPainter extends CustomPainter {
  final double progress;
  final bool isDone;

  _StrikeThroughPainter(this.progress, this.isDone);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width * progress, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
