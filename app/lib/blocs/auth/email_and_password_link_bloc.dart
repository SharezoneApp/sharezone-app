import 'dart:async' show Stream;
import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/pages/profile/user_edit/user_edit_bloc.dart';

import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_common/api_errors.dart';

// * Using a shortcut getter method on the class to create simpler and friendlier API for the class to provide access of a particular function on StreamController
// * Mixin can only be used on a class that extends from a base class, therefore, we are adding Bloc class that extends from the Object class
// NOTE: Or you can write "class Bloc extends Validators" since we don't really need to extend Bloc from a base class
class EmailAndPasswordLinkBloc extends BlocBase
    with AuthentificationValidators {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final LinkProviderGateway linkProviderGateway;
  final UserEditBlocGateway userEditBlocGateway;
  final String initalName;

  final LinkProviderAnalytics _analytics =
      LinkProviderAnalytics(Analytics(getBackend()));

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _obscureTextSubject = BehaviorSubject.seeded(true);

  // Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<bool> get obscureText => _obscureTextSubject;

  EmailAndPasswordLinkBloc(this.linkProviderGateway, this.userEditBlocGateway,
      this.initalName, this.scaffoldKey) {
    _nameController.sink.add(initalName);
  }

  // change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(bool) get changeObscureText => _obscureTextSubject.sink.add;

  Future<LinkAction> linkWithEmailAndPasswordAndHandleExceptions() async {
    if (await _isSubmitValid()) {
      try {
        await _submit();
        return LinkAction.finished;
      } catch (e, s) {
        final internalException = mapExceptionIntoInternalException(e);
        if (internalException is FirebaseEmailAlreadyInUseException) {
          _hideCurrentSnackBar();
          _analytics.logCredentialAlreadyInUseError();
          return LinkAction.credentialAlreadyInUse;
        }
        _showErrorSnackBar(e, s);
      }
    } else
      _showMessageToFillFormularCompleteSnackBar();
    return null;
  }

  Future<void> _submit() async {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    final validName = _nameController.value;

    await _linkEmailandPasswordProviderToUser(validEmail, validPassword);
    if (_hasUserChangedName()) {
      _updateUserName(validName);
    }
  }

  void _hideCurrentSnackBar() => scaffoldKey.currentState.hideCurrentSnackBar();

  void _showErrorSnackBar(Exception e, StackTrace s) {
    showSnackSec(
      key: scaffoldKey,
      text: handleErrorMessage(e.toString(), s),
      seconds: 4,
    );
  }

  void _showMessageToFillFormularCompleteSnackBar() {
    showSnackSec(
      text: "Füll das Formular komplett aus! 😉",
      key: scaffoldKey,
    );
  }

  Future<bool> _isSubmitValid() async {
    final e = _emailController.value;
    final p = _passwordController.value;
    final n = _nameController.value;
    return isNotEmptyOrNull(e) && isNotEmptyOrNull(p) && isNotEmptyOrNull(n);
  }

  Future<void> _linkEmailandPasswordProviderToUser(
      String validEmail, String validPassword) async {
    await linkProviderGateway.linkUserWithEmailAndPassword(
        email: validEmail, password: validPassword);
  }

  Future<void> _updateUserName(String validName) async {
    await userEditBlocGateway.edit(UserInput(name: validName));
  }

  /// Checks, if the user has changed his name
  bool _hasUserChangedName() => _nameController.value != initalName;

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _nameController.close();
    _obscureTextSubject.close();
  }
}
