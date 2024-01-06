// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_page.dart';

class _RoomTab extends StatelessWidget {
  _RoomTab({
    required this.index,
  });

  final roomFocusNode = FocusNode();
  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return _TimetableAddSection(
      index: index,
      title: 'Gib einen Raum an (optional)',
      child: StreamBuilder<String>(
        stream: bloc.room,
        builder: (context, snapshot) {
          final room = snapshot.hasData ? snapshot.data : null;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrefilledTextField(
              prefilledText: room,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Raum"),
              onChanged: (newRoom) => bloc.changeRoom(newRoom),
              maxLength: 32,
            ),
          );
        },
      ),
    );
  }
}
