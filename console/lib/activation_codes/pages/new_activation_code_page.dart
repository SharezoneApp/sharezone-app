// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_console/activation_codes/bloc/new_activation_code_bloc.dart';
import 'package:sharezone_console/bloc/bloc_provider.dart';
import 'package:sharezone_console/home_page.dart';
import 'package:sharezone_console/widgets/date_picker.dart';
import 'package:sharezone_console/widgets/picker.dart';
import 'package:sharezone_console/widgets/text_field_labeled.dart';

Future<void> openNewActivationPage(BuildContext context) {
  return openPage(
    context,
    BlocProvider(
      bloc: NewActivationCodeBloc(),
      child: _CreateActivationCodePage(),
    ),
  );
}

class _CreateActivationCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Neuer Aktivierungscode"),
          actions: [
            TextButton(
              child: const Text(
                "Erstellen",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final bloc = BlocProvider.of<NewActivationCodeBloc>(context);
                final result = await bloc.submit(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Ergebnis"),
                    content: Builder(builder: (context) {
                      return Column(
                        children: [
                          Text(result.runtimeType.toString()),
                          Text(result.data.toString()),
                        ],
                        mainAxisSize: MainAxisSize.min,
                      );
                    }),
                    actions: [
                      TextButton(
                        child: const Text("Fertig"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: _Body());
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewActivationCodeBloc>(context);
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Code
              TextFieldLabeled(
                decoration: InputDecoration(
                  labelText: "Code (auf Groß/Kleinschreibung achten!)",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.continueAction,
                onChanged: bloc.changeCode,
                label: "",
              ),
              const SizedBox(height: 10),
              // Codename
              TextFieldLabeled(
                decoration: InputDecoration(
                  labelText:
                      "Titel des Codes (dies wird dem Nutzer bei erfolgreicher Eingabe angezeigt)",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.continueAction,
                onChanged: bloc.changeCodeName,
                label: "",
              ),
              SizedBox(height: 10),
              // CodeDescription
              SizedBox(height: 10),
              TextFieldLabeled(
                decoration: InputDecoration(
                  labelText:
                      "Beschreibung des Codes (dies wird dem Nutzer bei erfolgreicher Eingabe angezeigt)",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.continueAction,
                onChanged: bloc.changeCodeDescription,
                label: "",
              ),
              SizedBox(height: 10),
              TextFieldLabeled(
                decoration: InputDecoration(
                  labelText: "Maximale Anzahl an Aktivierungen",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.continueAction,
                onChanged: (newText) {
                  final value = int.parse(newText);
                  bloc.changeTotalAmount(value);
                },
                keyboardType: TextInputType.number,
                label: "0",
              ),
              SizedBox(height: 10),
              StreamBuilder<DateTime>(
                stream: bloc.endTime,
                builder: (context, snapshot) {
                  final currentDate = snapshot.data;
                  return DatePicker(
                    labelText: "Gültig bis:",
                    selectedDate: currentDate,
                    selectDate: bloc.changeDateTime,
                  );
                },
              ),
              SizedBox(height: 10),
              _ActionsField(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewActivationCodeBloc>(context);
    return StreamBuilder<List<String>>(
      stream: bloc.actions,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Aktionen:"),
                for (final item in data)
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: Text(item),
                  ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          onTap: () {
            selectAction(context);
          },
        );
      },
    );
  }

  void selectAction(BuildContext context) async {
    final bloc = BlocProvider.of<NewActivationCodeBloc>(context);
    final selected = await selectItem<String>(
        context: context,
        items: NewActivationCodeBloc.allPossibleActions,
        builder: (context, value) {
          return ListTile(
            title: Text(value),
            onTap: () => Navigator.pop(context, value),
          );
        });
    if (selected != null) {
      bloc.changeActions([selected]);
    }
  }
}
