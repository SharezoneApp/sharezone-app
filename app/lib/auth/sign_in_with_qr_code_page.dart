import 'package:analytics/analytics.dart';
import 'package:app_functions/app_functions.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_qrcode/authentification_qrcode.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart' hide VerticalDivider;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_utils/dimensions.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

import 'email_and_password_link_page.dart';

class SignInWithQrCodePage extends StatelessWidget {
  static const tag = 'sign-in-with-qr-code-page';
  const SignInWithQrCodePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return BlocProvider(
            bloc: QrSignInWebBloc(
                firestore: FirebaseFirestore.instance,
                appFunctions: SharezoneAppFunctions(AppFunctions(
                    FirebaseFunctions.instanceFor(region: 'europe-west1'))),
                loginAnalytics: LoginAnalytics(Analytics(getBackend())),
                crashAnalytics: getCrashAnalytics()),
            child: _InnerSignInWithQrCodePage(),
          );
        },
      ),
      bottomNavigationBar: ContactSupport(),
    );
  }
}

class _InnerSignInWithQrCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: SafeArea(
              child: MaxWidthConstraintBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SharezoneLogo(
                      logoColor: LogoColor.blue_long,
                      height: 60,
                      width: 200,
                    ),
                    const SizedBox(height: 90),
                    if (Dimensions.fromMediaQuery(context).isDesktopModus)
                      Row(
                        children: <Widget>[
                          Expanded(child: _QrCodeSteps()),
                          const SizedBox(width: 64),
                          SizedBox(height: 350, child: VerticalDivider()),
                          const SizedBox(width: 64),
                          _QrCode(),
                        ],
                      )
                    else
                      Column(
                        children: <Widget>[
                          _QrCode(),
                          Divider(height: 64),
                          _QrCodeSteps(),
                        ],
                      ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ),
        BackIcon(),
      ],
    );
  }
}

class _QrCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<QrSignInWebBloc>(context);
    return SizedBox(
      height: 250,
      width: 250,
      child: StreamBuilder<QrSignInState>(
        initialData: QrCodeIsGenerating(),
        stream: bloc.qrSignInState,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is QrSignInIdle)
            return QrImage(
              backgroundColor: Colors.white,
              data: state.qrId,
              version: 3,
            );
          return _LoadingCircular();
        },
      ),
    );
  }
}

class _LoadingCircular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AccentColorCircularProgressIndicator(),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 175),
            child: const Text(
                "Die Erstellung des QR-Codes kann einige Sekunden dauern..."),
          )
        ],
      ),
    );
  }
}

class _QrCodeSteps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "So meldest du dich über einen QR-Code an:",
          style: TextStyle(fontSize: 30),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              _Step(
                step: 1,
                text: 'Öffne Sharezone auf deinem Handy / Tablet',
              ),
              _Step(
                step: 2,
                text: 'Öffne die Einstellungen über die seitliche Navigation',
              ),
              _Step(
                step: 3,
                text: 'Tippe auf "Web-App"',
              ),
              _Step(
                step: 4,
                text:
                    'Tippe auf "QR-Code scannen" und richte die Kamera auf deinen Bildschirm',
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Text(
          "Mithilfe der Anmeldung über einen QR-Code kannst du dich in der Web-App anmelden, ohne ein Passwort einzugeben. Besonders hilfreich ist das bei der Nutzung eines öffentlichen PCs.",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({Key key, this.step, this.text}) : super(key: key);

  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    const fontSize = 20.0;
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
            child: Text(
              "$step.",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: fontSize,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }
}
