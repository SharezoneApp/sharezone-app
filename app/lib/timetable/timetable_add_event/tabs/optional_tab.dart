// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_event_page.dart';

/// All optional fields in one tab
class _OptionalTab extends StatelessWidget {
  _OptionalTab({Key key, @required this.isExam}) : super(key: key);

  final bool isExam;
  final placeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _TimetableAddSection(
      index: 5,
      title: 'Optionale Felder',
      child: Column(
        children: <Widget>[
          _PlaceField(isExam: isExam),
          const SizedBox(height: 12),
          _DescriptionField(isExam: isExam),
          const SizedBox(height: 12),
          Divider(),
          _SendNotificationField(isExam: isExam),
        ],
      ),
    );
  }
}

class _PlaceField extends StatelessWidget {
  const _PlaceField({Key key, @required this.isExam}) : super(key: key);

  final bool isExam;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.place,
      builder: (context, snapshot) {
        final place = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PrefilledTextField(
            prefilledText: place,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: isExam ? 'Raum' : 'Ort',
              hintText: isExam ? 'z. B. Raum 203' : 'Aula',
            ),
            onChanged: bloc.changePlace,
            onEditingComplete: () => _submit(context),
            textInputAction: TextInputAction.done,
            maxLength: 32,
          ),
        );
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key key, @required this.isExam}) : super(key: key);

  final bool isExam;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.detail,
      builder: (context, snapshot) {
        final description = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrefilledTextField(
                prefilledText: description,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      isExam ? "Themen der Prüfung" : "Zusatzinformationen",
                  hintText: isExam
                      ? "z.B. Lineare Funktionen"
                      : "z.B. Sportsachen mitbringen!",
                ),
                onChanged: bloc.changeDetail,
                maxLines: null,
                onEditingComplete: () => _submit(context),
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: MarkdownSupport(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SendNotificationField extends StatelessWidget {
  const _SendNotificationField({Key key, @required this.isExam})
      : super(key: key);

  final bool isExam;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.sendNotification,
      builder: (context, snapshot) {
        final sendNotification = snapshot.data ?? false;
        return ListTileWithDescription(
          onTap: () => bloc.changeSendNotification(!sendNotification),
          leading: const Icon(Icons.notifications_active),
          title: const Text("Kursmitglieder benachrichtigen"),
          trailing: Switch.adaptive(
            onChanged: bloc.changeSendNotification,
            value: sendNotification,
          ),
          description: Text(
              "Sende eine Benachrichtigung an deine Kursmitglieder, dass du eine${isExam ? " Prüfung" : "n Termin"} erstellt hast."),
        );
      },
    );
  }
}
