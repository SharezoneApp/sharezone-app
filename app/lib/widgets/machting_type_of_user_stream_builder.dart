import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:user/user.dart';

/// If the current user matches [expectedTypeOfUser] [matchesTypeOfUserWidget] is build
/// else [notMatchingWidget] is build
class MatchingTypeOfUserStreamBuilder extends StatelessWidget {
  final TypeOfUser expectedTypeOfUser;
  final Widget matchesTypeOfUserWidget;
  final Widget notMatchtingWidget;

  const MatchingTypeOfUserStreamBuilder({
    Key key,
    @required this.expectedTypeOfUser,
    @required this.matchesTypeOfUserWidget,
    @required this.notMatchtingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<AppUser>(
      stream: api.user.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.typeOfUser == expectedTypeOfUser)
          return matchesTypeOfUserWidget;
        return notMatchtingWidget;
      },
    );
  }
}
