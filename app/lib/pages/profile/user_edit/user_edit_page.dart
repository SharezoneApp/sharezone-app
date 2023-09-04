// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/auth/email_and_password_link_page.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/pages/profile/user_edit/user_edit_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

Future<void> openUserEditPageIfUserIsLoaded(
    BuildContext context, AppUser? user) async {
  if (user != null) {
    final confirmed = await pushWithDefault<bool>(
      context,
      UserEditPage(user: user),
      defaultValue: false,
      name: UserEditPage.tag,
    );
    if (confirmed) _showConfirmationSnackbar(context);
  } else
    _showLoadingUserSnackBar(context);
}

void _showLoadingUserSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    text: "Informationen werden geladen! Warte kurz.",
    seconds: 2,
  );
}

void _showConfirmationSnackbar(BuildContext context) {
  showSnackSec(
    context: context,
    seconds: 2,
    text: "Dein Name wurde erfolgreich umbenannt.",
  );
}

Future<void> _submit(BuildContext context,
    {UserEditPageBloc? bloc,
    GlobalKey<ScaffoldMessengerState>? scaffoldKey}) async {
  bloc ??= BlocProvider.of<UserEditPageBloc>(context);
  showSnackSec(
    context: context,
    key: scaffoldKey,
    seconds: 60,
    withLoadingCircle: true,
    text: "Daten werden nach Frankfurt transportiert...",
    behavior: SnackBarBehavior.fixed,
  );
  try {
    final result = await bloc.submit();
    if (result) {
      Navigator.pop(context, result);
    } else {
      showSnack(
        context: context,
        key: scaffoldKey,
        behavior: SnackBarBehavior.fixed,
        text:
            'Der Vorgang konnte nicht korrekt abgeschlossen werden. Bitte kontaktiere den Support!',
      );
    }
  } on Exception catch (e, s) {
    showSnackSec(
      text: handleErrorMessage(e.toString(), s),
      context: context,
      behavior: SnackBarBehavior.fixed,
      key: scaffoldKey,
    );
  }
}

class UserEditPage extends StatefulWidget {
  const UserEditPage({Key? key, this.user}) : super(key: key);

  static const tag = "user-edit-page";
  final AppUser? user;

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  late UserEditPageBloc bloc;

  @override
  void initState() {
    super.initState();
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = UserEditPageBloc(
      name: widget.user!.name,
      gateway: UserEditBlocGateway(api.user, widget.user!),
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: WillPopScope(
        onWillPop: () async => bloc.hasInputChanged
            ? warnUserAboutLeavingOrSavingForm(context,
                () => _submit(context, bloc: bloc, scaffoldKey: scaffoldKey))
            : Future.value(true),
        child: Scaffold(
          key: scaffoldKey,
          appBar:
              AppBar(title: const Text("Name bearbeiten"), centerTitle: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: MaxWidthConstraintBox(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NameField(
                      initialName: widget.user!.name,
                      onChanged: bloc.changeName,
                      nameStream: bloc.name,
                      onEditingComplete: () => _submit(context,
                          bloc: bloc, scaffoldKey: scaffoldKey),
                      withIcon: false,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _UserEditPageFAB(),
        ),
      ),
    );
  }
}

class _UserEditPageFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text("Speichern"),
      onPressed: () => _submit(context),
      icon: const Icon(Icons.check),
    );
  }
}
