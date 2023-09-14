// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/widgets/settings/my_profile/change_data.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class ChangeStatePage extends StatelessWidget {
  const ChangeStatePage({super.key});
  static const tag = "change-state-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Bundesland ändern"), centerTitle: true),
        body: const _ChangeStatePageBody());
  }
}

class _ChangeStatePageBody extends StatelessWidget {
  const _ChangeStatePageBody();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);

    return StreamBuilder<StateEnum?>(
      stream: bloc.userState,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: AccentColorCircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text(
              "Error beim Anzeigen der Bundesländer. Falls der Fehler besteht kontaktiere uns bitte.");
        }
        final currentState = snapshot.data;
        return SingleChildScrollView(
          child: MaxWidthConstraintBox(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  _StateRadioGroup(initialState: currentState),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(),
                  ),
                  _WhyWeNeedTheState(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showExceptionSnackbar(BuildContext context) => showSnackSec(
      context: context,
      text: "Fehler beim Ändern deines Bundeslandes!:(",
      seconds: 3);
}

class _WhyWeNeedTheState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InfoMessage(
        title: "Wozu brauchen wir dein Bundesland?",
        message:
            "Mithilfe des Bundeslandes können wir die restlichen Tage bis zu den nächsten Ferien berechnen. Wenn du diese "
            "Angabe nicht machen möchtest, dann wähle beim Bundesland bitte einfach den Eintrag \"Anonym bleiben.\" aus.",
      ),
    );
  }
}

class _StateRadioGroup extends StatelessWidget {
  const _StateRadioGroup({Key? key, this.initialState}) : super(key: key);

  final StateEnum? initialState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _StateListTile(StateEnum.badenWuerttemberg, initialState: initialState),
        _StateListTile(StateEnum.bayern, initialState: initialState),
        _StateListTile(StateEnum.berlin, initialState: initialState),
        _StateListTile(StateEnum.brandenburg, initialState: initialState),
        _StateListTile(StateEnum.bremen, initialState: initialState),
        _StateListTile(StateEnum.hamburg, initialState: initialState),
        _StateListTile(StateEnum.hessen, initialState: initialState),
        _StateListTile(StateEnum.mecklenburgVorpommern,
            initialState: initialState),
        _StateListTile(StateEnum.niedersachsen, initialState: initialState),
        _StateListTile(StateEnum.nordrheinWestfalen,
            initialState: initialState),
        _StateListTile(StateEnum.rheinlandPfalz, initialState: initialState),
        _StateListTile(StateEnum.saarland, initialState: initialState),
        _StateListTile(StateEnum.sachsen, initialState: initialState),
        _StateListTile(StateEnum.sachsenAnhalt, initialState: initialState),
        _StateListTile(StateEnum.schleswigHolstein, initialState: initialState),
        _StateListTile(StateEnum.thueringen, initialState: initialState),
        _StateListTile(StateEnum.notFromGermany, initialState: initialState),
        _StateListTile(StateEnum.anonymous, initialState: initialState),
      ],
    );
  }
}

class _StateListTile extends StatelessWidget {
  const _StateListTile(this.state, {Key? key, this.initialState})
      : super(key: key);

  final StateEnum state;
  final StateEnum? initialState;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return RadioListTile(
      title: Text(stateEnumToString[state]!),
      value: state,
      groupValue: initialState,
      onChanged: (StateEnum? newState) {
        bloc.changeState(newState);
        savedChangesSnackBar(context);
      },
    );
  }
}
