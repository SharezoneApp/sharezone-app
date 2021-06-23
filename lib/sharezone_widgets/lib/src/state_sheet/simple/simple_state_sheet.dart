import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_widgets/state_sheet.dart';

Future<bool> showSimpleStateSheet(
    BuildContext context, Future<bool> future) async {
  final stateContentStream = _mapFutureToStateContent(future);
  final stateDialog = StateSheet(stateContentStream);
  stateDialog.showSheet(context);

  return future.then((value) {
    return Future.delayed(Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateSheetContent> _mapFutureToStateContent(Future<bool> future) {
  final _stateContent =
      BehaviorSubject<StateSheetContent>.seeded(stateSheetContentLoading);
  future.then((result) {
    if (result == true)
      _stateContent.add(stateSheetContentSuccessfull);
    else
      _stateContent.add(stateSheetContentFailed);
  });
  return _stateContent;
}
