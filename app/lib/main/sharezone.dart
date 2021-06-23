import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/blocs/bloc_dependencies.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/dynamic_link_bloc.dart';
import 'package:sharezone/main/auth_app.dart';
import 'package:sharezone/main/sharezone_app.dart';
import 'package:authentification_base/authentification_base.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';

/// StreamBuilder "above" the Auth and SharezoneApp.
/// Reasoning is that if the user logged out,
/// he will always be in the log in screen.
class Sharezone extends StatefulWidget {
  final BlocDependencies blocDependencies;
  final DynamicLinkBloc dynamicLinkBloc;
  final Stream<Beitrittsversuch> beitrittsversuche;

  const Sharezone(
      {Key key,
      @required this.blocDependencies,
      @required this.dynamicLinkBloc,
      @required this.beitrittsversuche})
      : super(key: key);

  static Analytics analytics = Analytics(getBackend());

  @override
  _SharezoneState createState() => _SharezoneState();
}

class _SharezoneState extends State<Sharezone> with WidgetsBindingObserver {
  SignUpBloc signUpBloc;

  @override
  void initState() {
    super.initState();

    signUpBloc = SignUpBloc();

    // You have to wait a little moment (1000 milliseconds), to
    // catch a dynmaic link from cold apps start on ios.
    // widget.dynamicLinkBloc.initialisere();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      widget.dynamicLinkBloc.initialisere();
    });

    logAppOpen();
  }

  void logAppOpen() {
    Sharezone.analytics.log(NamedAnalyticsEvent(name: 'app_open'));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: signUpBloc,
      child: StreamBuilder<AuthUser>(
        stream: listenToAuthStateChanged(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.blocDependencies.authUser = snapshot.data;
            return SharezoneApp(widget.blocDependencies, Sharezone.analytics,
                widget.beitrittsversuche);
          }
          return AuthApp(
            blocDependencies: widget.blocDependencies,
            analytics: Sharezone.analytics,
          );
        },
      ),
    );
  }
}
