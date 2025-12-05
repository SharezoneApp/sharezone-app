// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/holidays/holiday_bloc.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_data.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class ChangeStatePage extends StatelessWidget {
  const ChangeStatePage({super.key});
  static const tag = "change-state-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.changeStatePageTitle),
        centerTitle: true,
      ),
      body: const _ChangeStatePageBody(),
    );
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
          return Text(context.l10n.changeStatePageErrorLoadingState);
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
    text: context.l10n.changeStatePageErrorChangingState,
    seconds: 3,
  );
}

class _WhyWeNeedTheState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InfoMessage(
        title: context.l10n.changeStatePageWhyWeNeedTheStateInfoTitle,
        message: context.l10n.changeStatePageWhyWeNeedTheStateInfoContent,
      ),
    );
  }
}

class _StateRadioGroup extends StatelessWidget {
  const _StateRadioGroup({this.initialState});

  final StateEnum? initialState;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HolidayBloc>(context);
    return RadioGroup(
      groupValue: initialState,
      onChanged: (StateEnum? newState) {
        bloc.changeState(newState);
        savedChangesSnackBar(context);
      },
      child: const Column(
        children: <Widget>[
          _StateListTile(StateEnum.badenWuerttemberg),
          _StateListTile(StateEnum.bayern),
          _StateListTile(StateEnum.berlin),
          _StateListTile(StateEnum.brandenburg),
          _StateListTile(StateEnum.bremen),
          _StateListTile(StateEnum.hamburg),
          _StateListTile(StateEnum.hessen),
          _StateListTile(StateEnum.mecklenburgVorpommern),
          _StateListTile(StateEnum.niedersachsen),
          _StateListTile(StateEnum.nordrheinWestfalen),
          _StateListTile(StateEnum.rheinlandPfalz),
          _StateListTile(StateEnum.saarland),
          _StateListTile(StateEnum.sachsen),
          _StateListTile(StateEnum.sachsenAnhalt),
          _StateListTile(StateEnum.schleswigHolstein),
          _StateListTile(StateEnum.thueringen),
          _StateListTile(StateEnum.notFromGermany),
          _StateListTile(StateEnum.anonymous),
        ],
      ),
    );
  }
}

class _StateListTile extends StatelessWidget {
  const _StateListTile(this.state);

  final StateEnum state;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(state.getDisplayName(context)),
      value: state,
    );
  }
}
