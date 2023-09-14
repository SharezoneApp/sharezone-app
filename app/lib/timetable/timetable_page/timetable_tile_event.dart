// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'timetable_page.dart';

class TimetableEntryEvent extends StatelessWidget {
  final CalendricalEvent event;
  final GroupInfo? groupInfo;

  const TimetableEntryEvent({
    super.key,
    required this.event,
    required this.groupInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: groupInfo?.design.color.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
              color: groupInfo?.design.color ?? Colors.grey, width: 1.5),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          onTap: () =>
              showTimetableEventDetails(context, event, groupInfo?.design),
          onLongPress: () => onEventLongPress(context, event),
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _EventTitle(
                  title: event.title,
                  color: groupInfo?.design.color,
                ),
                GroupName(
                    abbreviation: groupInfo?.abbreviation,
                    groupName: groupInfo!.name!,
                    color: groupInfo?.design.color),
                if (event.place != null && event.place != "")
                  Room(
                    room: event.place!,
                    color: groupInfo?.design.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventTitle extends StatelessWidget {
  const _EventTitle({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String? title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '-',
      style: TextStyle(
        color: color,
        // color: Colors.grey[800],
        fontWeight: FontWeight.w600,
        // fontSize: 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
