// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_card.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_details_bloc.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_member_options.dart';
import 'package:sharezone/groups/src/pages/course/course_details/course_settings.dart';
import 'package:sharezone/groups/src/pages/course/group_help.dart';
import 'package:sharezone/groups/src/widgets/group_share.dart';
import 'package:sharezone/groups/src/widgets/meeting/group_meeting_button.dart';
import 'package:sharezone/groups/src/widgets/member_section.dart';
import 'package:sharezone/groups/src/widgets/sharecode_text.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/state_sheet.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

import 'course_edit/course_edit_page.dart';
import 'course_edit/design/course_edit_design.dart';

abstract class CourseDetailsPopOption {}

class LeaveCourseDetailsPopOption implements CourseDetailsPopOption {
  final Future<AppFunctionsResult<bool>> appFunction;

  LeaveCourseDetailsPopOption(this.appFunction);
}

class DeleteCourseDetailsPopOption implements CourseDetailsPopOption {
  final Future<AppFunctionsResult<bool>> appFunction;

  DeleteCourseDetailsPopOption(this.appFunction);
}

Future<void> openCourseDetailsPageAndShowConfirmationIfSuccessful(
    BuildContext context, Course course) async {
  final popOption = await Navigator.push<CourseDetailsPopOption>(
    context,
    MaterialPageRoute(
      builder: (context) => CourseDetailsPage(course: course),
      settings: const RouteSettings(name: CourseDetailsPage.tag),
    ),
  );
  if (popOption != null) {
    if (popOption is LeaveCourseDetailsPopOption) {
      await showAppFunctionStateDialog(context, popOption.appFunction);
      await waitingForPopAnimation();
      _showCourseLeaveConformationSnackbar(context);
    }
    if (popOption is DeleteCourseDetailsPopOption) {
      await showAppFunctionStateDialog(context, popOption.appFunction);
      await waitingForPopAnimation();
      _showCourseDeleteConfirmationSnackbar(context);
    }
  }
}

void _showCourseDeleteConfirmationSnackbar(BuildContext context) {
  showSnackSec(
      text: "Du hast erfolgreich den Kurs gelöscht.",
      context: context,
      seconds: 2);
}

void _showCourseLeaveConformationSnackbar(BuildContext context) {
  showSnackSec(
      text: "Du hast erfolgreich den Kurs verlassen.",
      context: context,
      seconds: 2);
}

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({Key key, @required this.course}) : super(key: key);

  static const tag = "course-details-page";
  final Course course;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return BlocProvider<CourseDetailsBloc>(
      bloc: CourseDetailsBloc(
          CourseDetailsBlocGateway(api.course, course), api.userId),
      child: _CourseDetailsPage(),
    );
  }
}

class _CourseDetailsPage extends StatelessWidget {
  const _CourseDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    return StreamBuilder<Course>(
      initialData: bloc.initialData,
      stream: bloc.course,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Icon(
                      Icons.warning,
                      color: Colors.deepOrange,
                      size: 84,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Es gab einen Fehler beim Laden des Kurses.\n\nMöglicherweise bist du nicht mehr ein Teilnehmer dieses Kurses.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
          );
        }
        final course = snapshot
            .data; // So that attributes are null, but the courseDetailsView is not. null attributes are handeld individually in the widgets.
        final isAdmin = bloc.isAdmin(course.myRole) ?? false;
        return Scaffold(
          appBar: AppBar(
            title: Text(course.name),
            actions: <Widget>[
              _ChangeColorIcon(courseID: course.id),
              ReportIcon(item: ReportItemReference.course(course.id)),
              if (isAdmin) _EditIcon(course: course),
            ],
          ),
          body: StreamBuilder<List<MemberData>>(
            stream: bloc.members,
            builder: (context, snapshot) {
              final members = snapshot.data ?? <MemberData>[];
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: MaxWidthConstraintBox(
                  child: Column(
                    children: <Widget>[
                      _CourseAvatarCard(
                          course: course, memberCount: members.length),
                      GroupMeetingButton(),
                      _SettingsCard(course: course),
                      MemberSection(
                        splittedMemberList: createSplittedMemberList(members),
                        groupInfo: course.toGroupInfo(),
                        allMembers: members,
                        onTap: (member) {
                          showCourseMemberOptionsSheet(
                            context: context,
                            memberData: member,
                            courseID: bloc.courseID,
                            membersDataList: members,
                          );
                        },
                      ),
                      SafeArea(
                        bottom: !isAdmin,
                        child: _LeaveCourseButton(
                          onDialogClose: (appFunction) => Navigator.pop(
                            context,
                            LeaveCourseDetailsPopOption(appFunction),
                          ),
                        ),
                      ),
                      if (isAdmin)
                        _DeleteCourseButton(
                          onDialogClose: (appFunction) => Navigator.pop(context,
                              DeleteCourseDetailsPopOption(appFunction)),
                          courseName: course.name,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ChangeColorIcon extends StatelessWidget {
  const _ChangeColorIcon({Key key, @required this.courseID}) : super(key: key);

  final String courseID;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Farben auswählen',
      icon: const Icon(Icons.color_lens),
      onPressed: () => editCourseDesign(context, courseID),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({Key key, @required this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return IconButton(
      tooltip: 'Kurs bearbeiten',
      icon: const Icon(Icons.edit),
      onPressed: () {
        _logCourseEditViaAppBar(analytics);
        openCourseEditPage(context, course);
      },
    );
  }

  void _logCourseEditViaAppBar(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "course_edit_via_app_bar"));
  }
}

class _LeaveCourseButton extends StatelessWidget {
  const _LeaveCourseButton({Key key, this.onDialogClose}) : super(key: key);

  final Function(Future<AppFunctionsResult<bool>>) onDialogClose;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DestroyButton(
        title: const Text("KURS VERLASSEN"),
        color: const Color(0xFFff7d7d),
        onTap: () async {
          _logCourseLeaveButtonViaCourseDetailsPage(analytics);
          final isLastMember = (await bloc.members.first).length <= 1;
          final result = await showCourseLeaveDialog(context, isLastMember);
          if (result) {
            onDialogClose(bloc.leaveCourse());
          }
        },
      ),
    );
  }

  void _logCourseLeaveButtonViaCourseDetailsPage(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(
        name: "course_leave_button_via_course_details_page"));
  }
}

class _DeleteCourseButton extends StatelessWidget {
  const _DeleteCourseButton({Key key, this.onDialogClose, this.courseName})
      : super(key: key);

  final Function(Future<AppFunctionsResult<bool>>) onDialogClose;
  final String courseName;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DestroyButton(
          title: const Text("KURS LÖSCHEN"),
          onTap: () async {
            _logCourseDeleteButtonViaCourseDetailsPage(analytics);
            final result = await showDeleteCourseDialog(context, courseName);
            if (result == true) {
              final deleteCourseFunction = bloc.deleteCourse();
              onDialogClose(deleteCourseFunction);
            }
          },
        ),
      ),
    );
  }

  void _logCourseDeleteButtonViaCourseDetailsPage(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(
        name: "course_delete_button_via_course_details_page"));
  }
}

class HelpCoursePageIconButton extends StatelessWidget {
  const HelpCoursePageIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help),
      tooltip: "Hilfe",
      onPressed: () => Navigator.pushNamed(context, CourseHelpPage.tag),
    );
  }
}

class _CourseAvatarCard extends StatelessWidget {
  const _CourseAvatarCard({@required this.course, this.memberCount = 0});

  final Course course;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AvatarCard(
          crossAxisAlignment: CrossAxisAlignment.center,
          avatarBackgroundColor: course.getDesign().color.withOpacity(0.2),
          fontColor: course.getDesign().color,
          withShadow: false,
          kuerzel: course.abbreviation,
          paddingBottom: 0,
          children: <Widget>[
            Text(
              course.subject,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            MemberCountText(memberCount: memberCount),
            const SizedBox(height: 16),
            SharecodeText(course.toGroupInfo().sharecode),
            const Divider(height: 40),
            ShareGroupSection(groupInfo: course.toGroupInfo()),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({Key key, @required this.course}) : super(key: key);

  final Course course;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CourseDetailsBloc>(context);
    if (!bloc.isAdmin(course.myRole)) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CourseSettingsCard(course: course),
        const SizedBox(height: 16),
      ],
    );
  }
}
