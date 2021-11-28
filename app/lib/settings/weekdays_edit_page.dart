import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/settings/src/bloc/enabled_weekdays_edit_bloc.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone/timetable/src/edit_weekday.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:user/user.dart';

void _showConfirmSnackBarOfSavingEnabledWeekDays(BuildContext context) {
  showSnackSec(
    context: context,
    text: "Die Angabe der aktivierten Wochentage wurden erfolgreich geändert.",
  );
}

Future<void> openWeekDaysEditPage(BuildContext context) async {
  final _userSettingsBloc = BlocProvider.of<UserSettingsBloc>(context);
  final result = await pushWithDefault<bool>(
    context,
    _WeekDaysEditPage(userSettingsBloc: _userSettingsBloc),
    defaultValue: false,
    name: _WeekDaysEditPage.tag,
  );
  if (result) _showConfirmSnackBarOfSavingEnabledWeekDays(context);
}

Future<void> _submit(BuildContext context,
    {EnabledWeekDaysEditBloc bloc,
    GlobalKey<ScaffoldMessengerState> scaffoldKey}) async {
  bloc ??= BlocProvider.of<EnabledWeekDaysEditBloc>(context);
  try {
    await bloc.submit();
    Navigator.pop(context, true);
  } on Exception catch (e, s) {
    showSnackSec(
      context: context,
      key: scaffoldKey,
      text: handleErrorMessage(e.toString(), s),
      seconds: 4,
    );
  }
}

class _WeekDaysEditPage extends StatefulWidget {
  const _WeekDaysEditPage({
    Key key,
    @required this.userSettingsBloc,
  }) : super(key: key);

  static const tag = "week-days-edit-page";
  final UserSettingsBloc userSettingsBloc;

  @override
  _WeekDaysEditPageState createState() => _WeekDaysEditPageState();
}

class _WeekDaysEditPageState extends State<_WeekDaysEditPage> {
  EnabledWeekDaysEditBloc bloc;
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    bloc = EnabledWeekDaysEditBloc(widget.userSettingsBloc);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => warnUserAboutLeavingOrSavingForm(context,
          () => _submit(context, scaffoldKey: scaffoldKey, bloc: bloc)),
      child: BlocProvider(
        bloc: bloc,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
          appBar: AppBar(title: const Text("Schultage"), centerTitle: true),
          body: StreamBuilder<EnabledWeekDays>(
            stream: bloc.weekDays,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final enabledWeekDays = snapshot.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      for (final weekDay in WeekDay.values)
                        _WeekDayTile(
                          weekDay: weekDay,
                          isEnabled: enabledWeekDays.getValue(weekDay),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: _EnabledWeekDaysEditFAB(),
        ),
      ),
    );
  }
}

class _EnabledWeekDaysEditFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.done),
      tooltip: 'Speichern',
      onPressed: () => _submit(context),
    );
  }
}

class _WeekDayTile extends StatelessWidget {
  const _WeekDayTile({Key key, this.weekDay, this.isEnabled}) : super(key: key);

  final bool isEnabled;
  final WeekDay weekDay;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EnabledWeekDaysEditBloc>(context);
    return CheckboxListTile(
      value: isEnabled,
      title: Text(getWeekDayText(weekDay)),
      onChanged: (newValue) {
        bloc.changeWeekDay(weekDay, newValue);
      },
    );
  }
}
