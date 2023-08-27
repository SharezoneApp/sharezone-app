// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

part of '../timetable_add_event_page.dart';

class _TitleTab extends StatelessWidget {
  _TitleTab({Key? key, required this.isExam}) : super(key: key);

  final roomFocusNode = FocusNode();
  final bool isExam;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return _TimetableAddSection(
      index: 2,
      title: 'Gib einen Titel für ${isExam ? "die Prüfung" : "den Termin"} an',
      child: StreamBuilder<String>(
        stream: bloc.title,
        builder: (context, snapshot) {
          final title = snapshot.hasData ? snapshot.data : null;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrefilledTextField(
              prefilledText: title,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Titel",
                  hintText: isExam ? "Philosophie Klausur Nr. 1" : "Sportfest"),
              onChanged: (newTitle) => bloc.changeTitle(newTitle),
              maxLength: 36,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => navigateToNextTab(context),
              textCapitalization: TextCapitalization.sentences,
            ),
          );
        },
      ),
    );
  }
}
