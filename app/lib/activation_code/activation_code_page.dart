// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/bloc/enter_activation_code_bloc_factory.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/widgets/enter_activation_code_text_field.dart';

Future<dynamic> openEnterActivationCodePage(BuildContext context) {
  final blocFactory = BlocProvider.of<EnterActivationCodeBlocFactory>(context);
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        bloc: blocFactory.createBloc(),
        child: const _EnterActivationCodePage(),
      ),
      settings: const RouteSettings(name: _EnterActivationCodePage.tag),
    ),
  );
}

class _EnterActivationCodePage extends StatelessWidget {
  const _EnterActivationCodePage();

  static const tag = "enter-activation-code-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _EnterActivationCodeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _EnterActivationCodeDescription(),
        ),
      ),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}

class _EnterActivationCodeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EnterActivationCodeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Aktivierungscode eingeben",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor:
          Theme.of(context).isDarkTheme ? null : Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: const [],
      bottom: const EnterActivationCodeTextField(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(190);
}

class _EnterActivationCodeDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
