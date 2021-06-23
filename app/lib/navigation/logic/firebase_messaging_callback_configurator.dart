part of '../navigation_controller.dart';

class FirebaseMessagingCallbackConfigurator {
  final NavigationService navigationService;
  final NavigationBloc navigationBloc;

  FirebaseMessagingCallbackConfigurator({
    this.navigationService,
    this.navigationBloc,
  });

  void configureCallbacks(BuildContext context) {
    /// Im Driver-Test kann der "willst du Notifikationen erhalten"-Dialog nicht
    /// geschlossen werden, weshalb wir diesen in einem Driver-Test auch nicht
    /// anzeigen wollen.
    if (!kIsDriverTest) _requestIOSPermission(context);

    FirebaseMessaging.onMessage.listen((message) {
      print('on message $message');

      showOverlayNotification(
          (context) => InAppNotification(
                notification: PushNotifaction.fromFirebase(message),
                navigationService: navigationService,
                navigationBloc: navigationBloc,
              ),
          duration: const Duration(milliseconds: 5500));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final actionHandler = PushNotificationActionHandler(
        navigationBloc: navigationBloc,
        navigationService: navigationService,
      );
      final pushNotifaction = PushNotifaction.fromFirebase(message);
      actionHandler.launchNotificationAction(context, pushNotifaction);
    });
  }
}

Future<void> _requestIOSPermission(BuildContext context) async {
  final signUpBloc = BlocProvider.of<SignUpBloc>(context);
  final signedUp = await signUpBloc.signedUp.first;

  // Falls der Nutzer sich nicht registriert hat, muss nach der Berechtigung
  // für die Push-Nachrichten gefragt werden, weil dies normalerweise im
  // Onboarding passiert. Meldet sich ein Nutzer mit einem Konto auf seinem
  // iPad an (zweit Gerät), würde dieser nicht die Abfrage für die Push-Nachrichten
  // erhalten und somit niemals Push-Nachricht zugeschickt bekommen.
  if (!signedUp) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }
}
