// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../dashboard_page.dart';

class _UpdateReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UpdateReminderBloc>(context);
    return FutureBuilder(
      future: bloc.shouldRemindToUpdate(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) return Container();
        return const Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: UpdatePromptCard(),
        );
      },
    );
  }
}
