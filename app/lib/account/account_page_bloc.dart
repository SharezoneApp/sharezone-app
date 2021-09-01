import 'dart:async';
import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';

import 'package:sharezone/overview/views/user_view.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_utils/streams.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_common/api_errors.dart';

enum LinkAction { credentialAlreadyInUse, finished }

class AccountPageBloc extends BlocBase {
  final GlobalKey<ScaffoldMessengerState> globalKey;
  final LinkProviderGateway linkProviderGateway;
  final UserGateway userGateway;

  final _analytics = LinkProviderAnalytics(Analytics(getBackend()));

  Stream<UserView> userViewStream;

  AccountPageBloc({
    @required this.userGateway,
    @required this.linkProviderGateway,
    @required this.globalKey,
  }) {
    final userStream = userGateway.userStream;
    final authUserStream = userGateway.authUserStream;

    userViewStream = TwoStreams(userStream, authUserStream).stream.map(
          (result) =>
              UserView.fromUserAndFirebaseUser(result.data0, result.data1),
        );
  }

  Future<LinkAction> linkWithGoogleAndHandleExceptions() async {
    bool confirmed;
    try {
      confirmed = await linkProviderGateway.linkUserWithGoogle();
    } on Exception catch (e, s) {
      final internalException = mapExceptionIntoInternalException(e);
      if (internalException is FirebaseCredentialAlreadyInUseException) {
        _analytics.logCredentialAlreadyInUseError();
        return LinkAction.credentialAlreadyInUse;
      }
      _showErrorSnackBar(e, s);
    }

    if (confirmed != null && confirmed) _showGoogleSignInConfirmation();
    return null;
  }

  Future<LinkAction> linkWithAppleAndHandleExceptions() async {
    bool confirmed;
    try {
      confirmed = await linkProviderGateway.linkUserWithApple();
    } on Exception catch (e, s) {
      final internalException = mapExceptionIntoInternalException(e);
      if (internalException is FirebaseCredentialAlreadyInUseException) {
        _analytics.logCredentialAlreadyInUseError();
        return LinkAction.credentialAlreadyInUse;
      }
      _showErrorSnackBar(e, s);
    }

    if (confirmed != null && confirmed) _showAppleeSignInConfirmation();
    return null;
  }

  void _showGoogleSignInConfirmation() {
    showSnackSec(
      key: globalKey,
      text: "Dein Account wurde mit einem Google-Konto verknüpft.",
    );
  }

  void _showAppleeSignInConfirmation() {
    showSnackSec(
      key: globalKey,
      text: "Dein Account wurde mit einem Apple-Konto verknüpft.",
    );
  }

  void _showErrorSnackBar(Exception e, StackTrace s) {
    showSnackSec(
      key: globalKey,
      text: handleErrorMessage(e.toString(), s),
      seconds: 4,
    );
  }

  @override
  void dispose() {}
}
