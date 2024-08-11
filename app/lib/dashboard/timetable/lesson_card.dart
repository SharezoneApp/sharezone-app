// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

Color _getLessonCardTextColor(BuildContext context) =>
    Theme.of(context).isDarkTheme ? Colors.lightBlue : darkBlueColor;

class _LessonCard extends StatelessWidget {
  const _LessonCard(this.view);

  final LessonView view;

  @override
  Widget build(BuildContext context) {
    final color = view.design.color;
    final isNow = view.timeStatus == LessonTimeStatus.isNow;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: _PassedLessonFade(
        lessonID: view.lesson.lessonID,
        percentTimePassed: view.percentTimePassed,
        hasAlreadyTakenPlace:
            view.timeStatus == LessonTimeStatus.hasAlreadyTakenPlace,
        child: CustomCard.roundVertical(
          onTap: () => showLessonModelSheet(
            context,
            view.lesson,
            view.date,
            view.design,
          ),
          onLongPress: () => onLessonLongPress(context, view.lesson),
          size: isNow ? const Size(150, 65) : const Size(135, 60),
          child: Stack(
            children: <Widget>[
              if (isNow)
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              Align(
                child: Column(
                  children: <Widget>[
                    _LessonNumber(view.periodNumber),
                    SizedBox(height: isNow ? 8 : 3),
                    CircleAvatar(
                      radius: 17.5,
                      backgroundColor: isNow
                          ? Theme.of(context).isDarkTheme
                              ? Theme.of(context).cardColor
                              : Colors.white
                          : color.withOpacity(0.2),
                      foregroundColor: color,
                      child: Text(
                        view.abbreviation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: isNow ? 10 : 7),
                    _Time(start: view.start, end: view.end),
                    SizedBox(height: isNow ? 10 : 6),
                    _Room(room: view.room, isNow: isNow),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassedLessonFade extends StatelessWidget {
  const _PassedLessonFade({
    this.hasAlreadyTakenPlace,
    this.child,
    this.lessonID,
    this.percentTimePassed,
  });

  final Widget? child;
  final bool? hasAlreadyTakenPlace;
  final String? lessonID;
  final double? percentTimePassed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 375),
      child: Stack(
        key: ValueKey("$lessonID;$hasAlreadyTakenPlace"),
        children: <Widget>[
          Opacity(opacity: 0.5, child: child),
          ClipRRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 1 - percentTimePassed!,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Erste Stunde = 1, zweite Stunde = 2, etc.
class _LessonNumber extends StatelessWidget {
  const _LessonNumber(this.periodNumber);

  final String? periodNumber;

  @override
  Widget build(BuildContext context) {
    if (isEmptyOrNull(periodNumber) || periodNumber == "null") {
      return const SizedBox(height: 14);
    }
    return Text(
      periodNumber!,
      style: TextStyle(
        fontSize: 12,
        color: _getLessonCardTextColor(context),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({this.start, this.end});

  final String? start, end;

  @override
  Widget build(BuildContext context) {
    final textColor = _getLessonCardTextColor(context);
    final textStyle = TextStyle(fontSize: 11, color: textColor);
    return Column(
      children: <Widget>[
        Text(start ?? "10:00", style: textStyle),
        const SizedBox(height: 2.5),
        Container(
          width: 8.5,
          height: 1.25,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 2.5),
        Text(end ?? "-", style: textStyle),
      ],
    );
  }
}

class _Room extends StatelessWidget {
  const _Room({this.room, this.isNow});

  final String? room;
  final bool? isNow;

  @override
  Widget build(BuildContext context) {
    if (isEmptyOrNull(room)) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Text(
        room!,
        style: TextStyle(
          fontSize: 11,
          color: _getLessonCardTextColor(context),
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
