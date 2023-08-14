// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/auth/email_and_password_link_page.dart';
import 'package:sharezone/auth/login_button.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/notifications/is_firebase_messaging_supported.dart';
import 'package:sharezone/notifications/notifications_permission.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/turn_on_notifications.dart';
import 'package:sharezone/pages/profile/user_edit/user_edit_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'is_it_first_person_using_sharezone.dart';

class OnboardingChangeName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<SharezoneContext>(context).api.user;
    return FutureBuilder<AppUser>(
      future: user.userStream.first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Scaffold(body: Container());

        final user = snapshot.data;
        return _OnboardingChangeNameLoaded(user: user);
      },
    );
  }
}

class _OnboardingChangeNameLoaded extends StatefulWidget {
  final AppUser user;

  const _OnboardingChangeNameLoaded({Key key, @required this.user})
      : super(key: key);

  @override
  _OnboardingChangeNameState createState() => _OnboardingChangeNameState();
}

class _OnboardingChangeNameState extends State<_OnboardingChangeNameLoaded> {
  UserEditPageBloc userEditPageBloc;

  @override
  void initState() {
    super.initState();
    final api = BlocProvider.of<SharezoneContext>(context).api;
    userEditPageBloc = UserEditPageBloc(
      name: widget.user.name,
      gateway: UserEditBlocGateway(api.user, widget.user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: userEditPageBloc,
      child: GroupOnboardingPageTemplate(
        top: Container(),
        title:
            'Welcher Name soll anderen Schülern, Lehrkräften und Eltern angezeigt werden?',
        children: [
          _TextFieldSubmitButton(initalName: widget.user.name),
        ],
      ),
    );
  }
}

class _TextFieldSubmitButton extends StatefulWidget {
  const _TextFieldSubmitButton({Key key, this.initalName}) : super(key: key);

  final String initalName;

  @override
  __TextFieldSubmitButtonState createState() => __TextFieldSubmitButtonState();
}

class __TextFieldSubmitButtonState extends State<_TextFieldSubmitButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserEditPageBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 550),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: NameField(
                  initialName: widget.initalName,
                  onChanged: bloc.changeName,
                  nameStream: bloc.name,
                  onEditingComplete: () => _submit(context),
                  withIcon: false,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  selectText: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: LoadingCircle(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: PlatformCheck.isDesktopOrWeb ? 0 : 12),
                        child: ContinueRoundButton(
                          tooltip: 'Weiter',
                          onTap: () => _submit(context),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final userEditPageBloc = BlocProvider.of<UserEditPageBloc>(context);

    // Die Anfrage zum Ändern des Namnes soll nur abgeschickt werden, wenn
    // der Nutzer auch wirklich seinen Namen geändert hat.
    if (userEditPageBloc.hasInputChanged) {
      setState(() => isLoading = true);
      try {
        await userEditPageBloc.submit();
        await _continue(context);
      } on Exception catch (e, s) {
        setState(() => isLoading = false);
        showSnackSec(
          text: handleErrorMessage(e.toString(), s),
          context: context,
        );
      }
    } else {
      await _continue(context);
    }
  }

  /// Hier wird geprüft, was nun gemacht werden muss, nachdem
  /// [_submit()] aufgerufen worden ist.
  Future<void> _continue(BuildContext context) async {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    final status = await bloc.status();

    if (status == GroupOnboardingStatus.onlyName) {
      bloc.finsihOnboarding();
    } else {
      _navigateToNextPage(context, status);
    }
  }

  /// Falls Nutzer noch die Push-Nachrichten aktivieren muss, wird die [TurnOnNotifications]
  /// angezeigt. Falls nicht, wird das normale GroupOnboarding aufgerufen.
  Future<void> _navigateToNextPage(
      BuildContext context, GroupOnboardingStatus status) async {
    final notificationsPermission = context.read<NotificationsPermission>();
    final isNeededToRequestNotificationsPermission =
        await notificationsPermission.isRequiredToRequestPermission();
    final showNotificationsRequestPage =
        isNeededToRequestNotificationsPermission &&
            isFirebaseMessagingSupported();

    if (status == GroupOnboardingStatus.onlyNameAndTurnOfNotifactions ||
        showNotificationsRequestPage) {
      Navigator.push(
        context,
        FadeRoute(
          child: TurnOnNotifications(),
          tag: TurnOnNotifications.tag,
        ),
      );
    } else {
      Navigator.push(
        context,
        FadeRoute(
          child: GroupOnboardingIsItFirstPersonUsingSharezone(),
          tag: GroupOnboardingIsItFirstPersonUsingSharezone.tag,
        ),
      );
    }
  }
}
