// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:sharezone/auth/login_button.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/src/pages/school_class/my_school_class_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/create_courses.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class SchoolClassCreateBloc extends BlocBase {
  SchoolClassCreateBloc();

  final ValueNotifier<String> name = ValueNotifier("");

  @override
  void dispose() {
    name.dispose();
  }
}

class GroupOnboardingCreateSchoolClass extends StatefulWidget {
  static const tag = 'onboarding-create-school-class-page';

  @override
  _GroupOnboardingCreateSchoolClassState createState() =>
      _GroupOnboardingCreateSchoolClassState();
}

class _GroupOnboardingCreateSchoolClassState
    extends State<GroupOnboardingCreateSchoolClass> {
  MySchoolClassBloc schoolClassBloc;
  SchoolClassCreateBloc schoolClassCreateBloc;

  @override
  void initState() {
    super.initState();
    final gateway = BlocProvider.of<SharezoneContext>(context).api;
    schoolClassBloc = MySchoolClassBloc(gateway: gateway);
    schoolClassCreateBloc = SchoolClassCreateBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      blocProviders: [
        BlocProvider<MySchoolClassBloc>(bloc: schoolClassBloc),
        BlocProvider<SchoolClassCreateBloc>(bloc: schoolClassCreateBloc),
      ],
      child: (context) => GroupOnboardingPageTemplate(
        title: _getTitle(context),
        children: const [_TextFieldSubmitButton()],
        bottomNavigationBar: OnboardingNavigationBar(),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    switch (bloc.typeOfUser) {
      case TypeOfUser.teacher:
        return 'Wie heißt die Klasse?';
      case TypeOfUser.parent:
        return 'Wie heißt die Klasse deines Kindes?';
      case TypeOfUser.student:
      default:
        return 'Wie heißt deine Klasse / Stufe?';
    }
  }
}

class _TextFieldSubmitButton extends StatefulWidget {
  const _TextFieldSubmitButton({Key key}) : super(key: key);

  @override
  __TextFieldSubmitButtonState createState() => __TextFieldSubmitButtonState();
}

class __TextFieldSubmitButtonState extends State<_TextFieldSubmitButton> {
  bool isLoading = false;
  String errorTextForUser;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SchoolClassCreateBloc>(context);
    return ValueListenableBuilder<String>(
      valueListenable: bloc.name,
      builder: (context, name, _) {
        final isValid = isNotEmptyOrNull(name);
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 550),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextField(
                        autofocus: true,
                        maxLength: 32,
                        onChanged: (newText) => bloc.name.value = newText,
                        onEditingComplete: () {
                          if (isValid) onSubmit(context, name);
                        },
                        decoration: const InputDecoration(
                          hintText: 'z.B. 10A',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLoading
                          ? LoadingCircle()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ContinueRoundButton(
                                  tooltip: 'Weiter',
                                  onTap: isValid
                                      ? () => onSubmit(context, name)
                                      : null),
                            ),
                    ),
                  ),
                ],
              ),
              if (isNotEmptyOrNull(errorTextForUser))
                _ErrorText(errorTextForUser: errorTextForUser),
            ],
          ),
        );
      },
    );
  }

  void onSubmit(BuildContext context, String name) {
    final schoolClassBloc = BlocProvider.of<MySchoolClassBloc>(context);
    setState(() => isLoading = true);
    schoolClassBloc.createSchoolClass(name).then((result) async {
      if (result != null && result.hasData && result.data == true) {
        isLoading = false;
        final schoolClassID = schoolClassBloc.schoolClassId;
        Navigator.push(
          context,
          FadeRoute(
            child: GroupOnboardingCreateCourse(
                schoolClassId: Optional.ofNullable(schoolClassID)),
            tag: GroupOnboardingCreateCourse.tag,
          ),
        );
      }
    }).catchError((e, StackTrace s) {
      setState(() {
        isLoading = false;
        getCrashAnalytics().recordError(e, s);
        errorTextForUser = "$e";
      });
    });
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({Key key, @required this.errorTextForUser})
      : super(key: key);

  final String errorTextForUser;

  @override
  Widget build(BuildContext context) {
    return Text(errorTextForUser,
        style: TextStyle(
            color: Theme.of(context).colorScheme.error, fontSize: 14));
  }
}
