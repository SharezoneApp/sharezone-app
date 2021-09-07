import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/notifications/setup_push_notification_action_handler.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

/// Shows a dialog showing the contents of the [notification] and an explanation
/// that the action of the [notification] could not be handled because of
/// [errorReason].
void showNotificationHandlingErrorDialog(
    PushNotification notification, NotificationHandlerErrorReason errorReason,
    {@required BuildContext context}) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    showLeftRightAdaptiveDialog<bool>(
      context: context,
      title: notification.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          notification.hasNonEmptyBody ? Text(notification.body) : null,
          SizedBox(
            height: 20,
          ),
          _ErrorBanner(errorReason: errorReason),
        ],
      ),
      defaultValue: false,
      left: AdaptiveDialogAction<bool>(
        isDefaultAction: true,
        title: "Ok",
      ),
    );
  });
}

class _ErrorBanner extends StatefulWidget {
  const _ErrorBanner({Key key, @required this.errorReason}) : super(key: key);

  final NotificationHandlerErrorReason errorReason;

  @override
  __ErrorBannerState createState() => __ErrorBannerState();
}

class __ErrorBannerState extends State<_ErrorBanner> {
  static String getLongErrorDescription(
      NotificationHandlerErrorReason errorReason) {
    assert(errorReason != null);
    String _errorReason;

    switch (errorReason) {
      case NotificationHandlerErrorReason.fatalParsingError:
        _errorReason = 'Fatal-Parsing-Error';
        break;
      case NotificationHandlerErrorReason.unknownActionType:
        _errorReason = 'Unknown-Action-Type';
        break;
    }

    return '''
Es konnte nicht verarbeitet werden, was beim Tippen auf die Benachrichtigung eigentlich hätte passieren sollen. Der Fehler wurde automatisch an uns übermittelt. 
Fehler: $_errorReason

Möglicherweise ist der Fehler durch eine veraltete Version von Sharezone enstanden.
Überprüfe bitte, ob du Sharezone updaten kannst.''';
  }

  Widget getLongDescription() => Text(
        getLongErrorDescription(widget.errorReason),
        style: TextStyle(fontSize: 13),
      );

  Widget getShortDescription(BuildContext context) {
    return Text.rich(
      TextSpan(children: const [
        TextSpan(
            text:
                'Beim tippen auf die Benachrichtigung hätte jetzt etwas anderes passieren sollen.',
            style: TextStyle(fontSize: 13)),
        TextSpan(text: ' '),
        TextSpan(
          text: 'Mehr Infos.',
          style: TextStyle(
            color: Colors.blue,
            // When the text is underlined it looks bigger than the rest so we
            // choose a font sizer smaller than the other text.
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ]),
    );
  }

  bool showLongErrorDescription = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          // Has a better contrast in darkmode
          ? Colors.orangeAccent
          : Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            showLongErrorDescription = !showLongErrorDescription;
          });
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 30),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Icon(
                    Icons.error_outline_outlined,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.black),
                      child: showLongErrorDescription
                          ? getLongDescription()
                          : getShortDescription(context),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
