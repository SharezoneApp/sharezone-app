import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/pages/homework/homework_dialog.dart';
import 'package:sharezone/util/smart_calculation/smart_calculation.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

Future<void> openHomeworkDialogAndShowConfirmationIfSuccessful(
  BuildContext context, {
  HomeworkDto homework,
}) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final smartCalculations = SmartCalculations(
    timetableGateway: api.timetable,
    userGateway: api.user,
    holidayManager: BlocProvider.of<HolidayBloc>(context).holidayManager,
  );

  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => HomeworkDialog(
        homeworkDialogApi: HomeworkDialogApi(api, smartCalculations),
        homework: homework,
      ),
      settings: RouteSettings(name: HomeworkDialog.tag),
    ),
  );
  if (successful != null && successful) {
    await _showUserConfirmationOfHomeworkArrival(context: context);
  }
}

Future<void> _showUserConfirmationOfHomeworkArrival(
    {@required BuildContext context}) async {
  await waitingForPopAnimation();
  showDataArrivalConfirmedSnackbar(context: context);
}
