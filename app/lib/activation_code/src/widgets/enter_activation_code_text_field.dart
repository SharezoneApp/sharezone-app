// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc.dart';
import 'package:sharezone/activation_code/src/enter_activation_code_result_dialog.dart';
import 'package:sharezone/auth/login_button.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class EnterActivationCodeTextField extends StatelessWidget
    implements PreferredSizeWidget {
  const EnterActivationCodeTextField({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EnterActivationCodeBloc>(context);
    return MaxWidthConstraintBox(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.white,
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
              ),
              child: TextField(
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
                onChanged: bloc.updateFieldText,
                cursorColor: Colors.white,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => onSend(context, bloc),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Aktivierungscode',
                  hintText: "z.B. Promo2020",
                  suffixIcon: Theme(
                    data: Theme.of(context),
                    child: ContinueRoundButton(
                      tooltip: 'Senden',
                      onTap: () => onSend(context, bloc),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Future<void> onSend(
    BuildContext context,
    EnterActivationCodeBloc bloc,
  ) async {
    hideKeyboard(context: context);
    if (bloc.isValidActivationCodeID) {
      bloc.submit(context);
      final dialog = EnterActivationCodeResultDialog(bloc);
      dialog.show(context);
    }
  }
}
