// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_page.dart';

class _RoomAndTeachersTab extends StatelessWidget {
  const _RoomAndTeachersTab({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return _TimetableAddSection(
      index: index,
      title: context.l10n.timetableAddRoomAndTeacherOptionalTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            RoomField(onChanged: bloc.changeRoom),
            const SizedBox(height: 16),
            TeacherField(
              teachers: BlocProvider.of<TimetableBloc>(context).currentTeachers,
              onTeacherChanged: bloc.changeTeacher,
            ),
          ],
        ),
      ),
    );
  }
}
