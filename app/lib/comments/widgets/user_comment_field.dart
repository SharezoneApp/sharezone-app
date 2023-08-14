// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/auth/login_button.dart';
import 'package:sharezone/comments/comments_bloc.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class UserCommentField extends StatefulWidget {
  final String textFieldMessage;
  final String userAbbreviation;

  const UserCommentField(
      {Key key,
      this.textFieldMessage = "Gib deinen Senf ab...",
      this.userAbbreviation = "?"})
      : super(key: key);

  @override
  _UserCommentFieldState createState() => _UserCommentFieldState();
}

class _UserCommentFieldState extends State<UserCommentField> {
  String text;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommentsBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 12, right: 12, bottom: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: widget.textFieldMessage,
          border: const OutlineInputBorder(),
          suffixIcon: ContinueRoundButton(
            onTap: () {
              if (isNotEmptyOrNull(text)) {
                bloc.addComment(text);
                text = null;
                controller.clear();
                FocusManager.instance.primaryFocus?.unfocus();
              } else {
                showSnackSec(
                  context: context,
                  text: 'Der Kommentar hat doch gar keinen Text! 🧐',
                );
              }
            },
          ),
        ),
        maxLines: null,
        onChanged: (s) => text = s,
        textInputAction: TextInputAction.newline,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
