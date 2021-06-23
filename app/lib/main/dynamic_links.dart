import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/dynamic_links/einkommender_link.dart';

class DynamicLinksTest extends StatelessWidget {
  final Stream<EinkommenderLink> einkommendeLinks;

  const DynamicLinksTest({Key key, this.einkommendeLinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<EinkommenderLink>(
              stream: einkommendeLinks,
              builder: (context, snapshot) {
                return Text("${snapshot?.data?.toString() ?? ''}");
              }),
        ),
      ),
    );
  }
}

class DynamicLinkOverlay extends StatelessWidget {
  final Stream<EinkommenderLink> einkommendeLinks;
  final bool activated;
  final Widget child;

  const DynamicLinkOverlay(
      {Key key, this.einkommendeLinks, this.activated, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EinkommenderLink>(
      stream: einkommendeLinks,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.data.empty && activated) {
          final einkommenderLink = snapshot.data;
          // If Notification is shown directly an Error as thrown, as it can't be displayed while this is still bulding (marked as dirty)
          Future.delayed(Duration(seconds: 1)).then((_) =>
              showSimpleNotification(
                  Text("Neuer dynamic Link: \n$einkommenderLink"),
                  autoDismiss: false,
                  slideDismiss: true,
                  leading: Icon(Icons.link)));
        }
        return child;
      },
    );
  }
}

class DynamicLinkOverlay2 extends StatefulWidget {
  final Stream<EinkommenderLink> einkommendeLinks;
  final bool activated;
  final Widget child;

  const DynamicLinkOverlay2(
      {Key key, this.einkommendeLinks, this.child, this.activated = false})
      : super(key: key);

  @override
  _DynamicLinkOverlay2State createState() => _DynamicLinkOverlay2State();
}

class _DynamicLinkOverlay2State extends State<DynamicLinkOverlay2> {
  bool showLink = true;
  EinkommenderLink letzerEinkommenderLink;
  final int duration = 10;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EinkommenderLink>(
        stream: widget.einkommendeLinks,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != letzerEinkommenderLink) {
            showLink = true;
            Future.delayed(Duration(seconds: duration))
                .then((_) => setState(() => showLink = false));
            letzerEinkommenderLink = snapshot.data;
          }
          return Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                children: <Widget>[
                  widget.child,
                  if (snapshot.hasData && showLink && widget.activated)
                    IgnorePointer(
                      child: Align(
                        alignment: Alignment(0, -.9),
                        child: Container(
                          child: Text(
                            "[$duration Sek.] Neuer dynamic Link: \n \n ${snapshot.data.toString() ?? ''}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          color: Colors.grey.withOpacity(.7),
                        ),
                      ),
                    ),
                ],
              ));
        });
  }
}
