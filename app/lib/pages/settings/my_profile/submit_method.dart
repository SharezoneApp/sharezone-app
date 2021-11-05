import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/settings/change_data_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';

enum ChangeType {
  email,
  password,
}

Future<void> submit(
    BuildContext context, String snackBarText, ChangeType changeType) async {
  final bloc = BlocProvider.of<ChangeDataBloc>(context);
  showSnackSec(
    context: context,
    withLoadingCircle: true,
    seconds: 10,
    text: snackBarText,
    behavior: SnackBarBehavior.fixed,
  );

  try {
    if (changeType == ChangeType.email) {
      await bloc.submitEmail();
    } else {
      await bloc.submitPassword();
      Navigator.pop(context, true);
    }
  } on IdenticalEmailException catch (e) {
    showSnackSec(
      text: e.message,
      context: context,
      behavior: SnackBarBehavior.fixed,
    );
  } on Exception catch (e, s) {
    showSnackSec(
      text: handleErrorMessage(e.toString(), s),
      behavior: SnackBarBehavior.fixed,
      context: context,
    );
  }
}
