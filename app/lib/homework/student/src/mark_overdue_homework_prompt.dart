// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MarkOverdueHomeworkPrompt extends StatefulWidget {
  const MarkOverdueHomeworkPrompt({super.key});

  @override
  State createState() => _MarkOverdueHomeworkPromptState();
}

class _MarkOverdueHomeworkPromptState extends State<MarkOverdueHomeworkPrompt> {
  late bool visible;
  late OverdueHomeworkDialogDismissedCache cache;

  @override
  void initState() {
    visible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // ignore:close_sinks
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);
    final analytics = AnalyticsProvider.ofOrNullObject(context);
    cache = BlocProvider.of<OverdueHomeworkDialogDismissedCache>(context);

    if (!cache.wasAlreadyDismissed()) {
      setState(() {
        visible = true;
      });
    }

    if (!visible) return Container();
    analytics.log(_OverdueAnalyticsEvent.displayed());
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: CustomCard(
        borderWidth: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Alle überfälligen Hausaufgaben abhaken?",
                style: textTheme.titleLarge?.apply(fontSizeFactor: 0.9),
                textAlign: TextAlign.center,
              ),
            ),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: const Text("Schließen"),
                  onPressed: () {
                    analytics.log(_OverdueAnalyticsEvent.closed());
                    setState(() {
                      visible = false;
                    });
                    cache.setAlreadyDismissed(true);
                  },
                ),
                FilledButton(
                  onPressed: () {
                    analytics.log(_OverdueAnalyticsEvent.confirmed());
                    bloc.add(CompletedAllOverdue());
                  },
                  child: const Text("Abhaken"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OverdueAnalyticsEvent implements AnalyticsEvent {
  static const base = "complete_overdue_homework_dialog";
  @override
  final String name;

  _OverdueAnalyticsEvent.displayed() : name = "${base}_displayed";
  _OverdueAnalyticsEvent.closed() : name = "${base}_closed";
  _OverdueAnalyticsEvent.confirmed() : name = "${base}_confirmed";

  @override
  Map<String, dynamic> get data => {};
}

class OverdueHomeworkDialogDismissedCache implements BlocBase {
  final KeyValueStore _keyValueStore;
  static const wasAlreadyShownKey = "wasOverdueHomeworkDialogAlreadyShown";

  OverdueHomeworkDialogDismissedCache(this._keyValueStore);

  bool wasAlreadyDismissed() {
    return _keyValueStore.getBool(wasAlreadyShownKey) ?? false;
  }

  void setAlreadyDismissed(bool alreadyShown) {
    _keyValueStore.setBool(wasAlreadyShownKey, alreadyShown);
  }

  @override
  void dispose() {}
}
