import 'package:app_functions/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/groups/src/pages/course/course_details/course_details_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_details/write_permission_options.dart';
import 'package:sharezone/groups/src/widgets/meeting/is_group_meeting_enabled_switch.dart';
import 'package:sharezone_widgets/state_sheet.dart';
import 'package:sharezone_widgets/widgets.dart';

void showExplanation(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => InformationDialog(text: text),
  );
}

class CourseSettingsCard extends StatelessWidget {
  const CourseSettingsCard({Key key, @required this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    final courseSettings = course.settings;
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _IsPublic(isPublic: courseSettings.isPublic),
          _IsGroupMeetingEnabledSwitch(
              isMeetingEnabled: courseSettings.isMeetingEnabled),
          WritePermissions(
            initalWritePermission: course.settings.writePermission,
            onChange: (newWP) => bloc.setWritePermission(newWP),
            writePermissionStream: bloc.writePermissionStream,
          ),
        ],
      ),
    );
  }
}

class _IsGroupMeetingEnabledSwitch extends StatelessWidget {
  const _IsGroupMeetingEnabledSwitch({Key key, @required this.isMeetingEnabled})
      : super(key: key);

  final bool isMeetingEnabled;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return IsGroupMeetingEnbaldedSwitch(
      isMeetingEnabled: isMeetingEnabled,
      onChanged: (newValue) {
        final setFuture = bloc.setIsGroupMeetingEnabled(newValue);
        showAppFunctionStateDialog(context, setFuture);
      },
    );
  }
}

class _IsPublic extends StatelessWidget {
  const _IsPublic({Key key, @required this.isPublic}) : super(key: key);

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return ListTile(
      title: const Text("Beitreten erlauben"),
      leading: Icon(Icons.lock),
      onTap: () {
        Future<AppFunctionsResult<bool>> setFuture =
            bloc.setIsPublic(!isPublic);
        showAppFunctionStateDialog(context, setFuture);
      },
      onLongPress: () => showExplanation(context,
          "Über diese Einstellungen kannst du regulieren, ob neue Mitglieder dem Kurs beitreten dürfen."),
      trailing: Switch.adaptive(
        value: isPublic,
        onChanged: (newValue) {
          Future<AppFunctionsResult<bool>> setFuture =
              bloc.setIsPublic(newValue);
          showAppFunctionStateDialog(context, setFuture);
        },
      ),
    );
  }
}
