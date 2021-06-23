import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/hint_text.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:user/user.dart';
import '../widgets/text_button.dart';
import 'create_schoolclass.dart';
import 'is_schoolclass_teacher.dart';
import 'join_group.dart';

class GroupOnboardingIsItFirstPersonUsingSharezone extends StatelessWidget {
  static const tag = 'group-onboarding-is-it-first-person-using-sharezone';

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingPageTemplate(
      title: _getString(context),
      children: const [
        _JoinGroupButton(),
        _CreateGroupsButton(),
      ],
      bottomNavigationBar: const SafeArea(
        child: GroupOnboardingHintText(
          "Wenn ein Mitschüler schon Sharezone verwendet, kann dir dieser einen Sharecode geben, du damit seiner Klasse beitreten kannst.",
        ),
      ),
    );
  }

  String _getString(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    switch (bloc.typeOfUser) {
      case TypeOfUser.student:
        return "Haben Mitschüler oder dein Lehrer / deine Lehrerin schon einen Kurs, eine Klasse oder Stufe erstellt? 💪";
      case TypeOfUser.parent:
        return "Wurden bereits Gruppen von Schülern oder Lehrkräften erstellt?";
      case TypeOfUser.teacher:
      default:
        return "Wurden bereits Gruppen von einer anderen Person erstellt? 💪";
    }
  }
}

class _JoinGroupButton extends StatelessWidget {
  const _JoinGroupButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    return GroupOnboardingTextButton(
      icon: const Icon(Icons.vpn_key),
      text: bloc.isStudent
          ? "Ja, ich möchte dieser Gruppe beitreten"
          : "Ja, ich möchte diesen Gruppen beitreten",
      onTap: () => Navigator.push(
        context,
        FadeRoute(
          child: GroupOnboardingGroupJoinPage(),
          tag: GroupOnboardingGroupJoinPage.tag,
        ),
      ),
    );
  }
}

class _CreateGroupsButton extends StatelessWidget {
  const _CreateGroupsButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingTextButton(
      icon: const Icon(Icons.add_circle_outline),
      text: "Nein, ich möchte neue Gruppen erstellen",
      onTap: () {
        final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
        if (bloc.isTeacher) {
          Navigator.push(
            context,
            FadeRoute(
              child: GroupOnboardingIsClassTeacher(),
              tag: GroupOnboardingIsClassTeacher.tag,
            ),
          );
        } else {
          Navigator.push(
            context,
            FadeRoute(
              child: GroupOnboardingCreateSchoolClass(),
              tag: GroupOnboardingCreateSchoolClass.tag,
            ),
          );
        }
      },
    );
  }
}
