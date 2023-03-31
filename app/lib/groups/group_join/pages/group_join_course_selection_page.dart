// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/auth/type_of_user_bloc.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_bloc.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_select_courses_bloc.dart';
import 'package:sharezone/groups/group_join/models/group_info_with_selection_state.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:user/user.dart';

/// Auf dieser Seite wählt der Nutzer nach einem Beitrittsversuch einer Schulklasse
/// Kurse aus. Dies dient dazu, damit er zu Beginn auch nur wirlich den Kursen beitritt, welche für ihn
/// relevant sind.
Future<dynamic> openGroupJoinCourseSelectionPage(
    BuildContext context, RequireCourseSelectionsJoinResult joinResult) {
  final groupJoinBloc = BlocProvider.of<GroupJoinBloc>(context);
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        bloc: GroupJoinSelectCoursesBloc(
          groupJoinBloc: groupJoinBloc,
          joinResult: joinResult,
        ),
        child: _GroupJoinCourseSelectionPage(),
      ),
      settings: RouteSettings(name: _GroupJoinCourseSelectionPage.tag),
    ),
  );
}

class _GroupJoinCourseSelectionPage extends StatelessWidget {
  static const tag = 'group-join-course-selection-page';

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupJoinSelectCoursesBloc>(context);
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Beizutretene Kurse der ${bloc.groupName}')),
        body: const SingleChildScrollView(
          child: SafeArea(child: _OptionalCoursesList()),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Divider(),
              _BottomSheet(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const _CallToAction(),
            const SizedBox(height: 12),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  _SkipButton(),
                  SizedBox(width: 12),
                  _FinishButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CallToAction extends StatelessWidget {
  const _CallToAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TypeOfUser>(
      stream: BlocProvider.of<TypeOfUserBloc>(context).typeOfUserStream,
      builder: (context, snapshot) {
        final typeOfUser = snapshot.data ?? TypeOfUser.student;
        return Text(
          _matchingTypeOfUserText(typeOfUser),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        );
      },
    );
  }

  String _matchingTypeOfUserText(TypeOfUser typeOfUser) {
    if (typeOfUser.isTeacher) {
      return 'Wähle die Kurse aus, in denen du unterrichtest.';
    }

    if (typeOfUser.isParent) {
      return 'Falls dein Kind in Wahlfächern (z.B. Französisch) ist, solltest du diese Kurse aus der Auswahl aufheben.';
    }

    return 'Falls du in Wahlfächern (z.B. Französisch) bist, solltest du diese Kurse aus der Auswahl aufheben.';
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupJoinSelectCoursesBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: MaterialButton(
        onPressed: () {
          bloc.submit();
          Navigator.pop(context);
        },
        color: context.primaryColor,
        textColor: Colors.white,
        child: Text("Fertig".toUpperCase()),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupJoinSelectCoursesBloc>(context);
    return TextButton(
      onPressed: () {
        bloc.skip();
        Navigator.pop(context);
      },
      child: Text("Überspringen".toUpperCase()),
      style: TextButton.styleFrom(
        foregroundColor: context.primaryColor,
      ),
    );
  }
}

class _OptionalCoursesList extends StatelessWidget {
  const _OptionalCoursesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupJoinSelectCoursesBloc>(context);
    return StreamBuilder<List<GroupInfoWithSelectionState>>(
      stream: bloc.coursesList,
      builder: (context, snapshot) {
        final items = snapshot.data;
        if (items == null) {
          return Center(child: AccentColorCircularProgressIndicator());
        }
        return AlternatingColoredList(
          itemCount: items.length,
          itemBuilder: (context, i) => _CourseCheckboxTile(groupInfo: items[i]),
        );
      },
    );
  }
}

/// Das Item, bei welcher der Nutzer dann die Auswahl macht, ob dieser Kurs hinzugefügt werden soll.
class _CourseCheckboxTile extends StatelessWidget {
  const _CourseCheckboxTile({
    Key key,
    @required this.groupInfo,
  })  : assert(groupInfo != null),
        super(key: key);

  final GroupInfoWithSelectionState groupInfo;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 600,
      child: CheckboxListTile(
        title: Text(groupInfo.name),
        value: groupInfo.isSelected,
        onChanged: (newSelectionValue) {
          final bloc = BlocProvider.of<GroupJoinSelectCoursesBloc>(context);
          bloc.setSelectionState(groupInfo.groupKey, newSelectionValue);
        },
      ),
    );
  }
}
