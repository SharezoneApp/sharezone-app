import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifaction {
  /// The [id] of the notifcation, f. g. "pushNamed"
  final String id;

  /// The [idContent] is the content of an id, f. g. [id] is
  /// "pushedNamed" and the [idContent] is "RecommendPage".
  final String idContent;

  final String title;
  final String body;

  final bool hasID, hasIdContent, hasTitle, hasBody;

  const PushNotifaction(this.id, this.title, this.body, this.idContent)
      : hasID = id != null,
        hasIdContent = idContent != null,
        hasTitle = title != null,
        hasBody = body != null;

  factory PushNotifaction.empty() {
    return PushNotifaction("", "", "", "");
  }

  factory PushNotifaction.fromFirebase(RemoteMessage message) {
    if (message == null) return PushNotifaction.empty();

    final id = _getID(message.data);
    final idContent = _getIdContent(message.data);
    final title = message.notification.title;
    final body = message.notification.body;

    return PushNotifaction(id, title, body, idContent);
  }

  static String _getID(Map<String, dynamic> message) {
    return message['message_id'];
  }

  static String _getIdContent(Map<String, dynamic> message) {
    return message['message_content'];
  }

  @override
  String toString() =>
      "PushNotifcation: {id: $id, idContent: $idContent, title: $title, body: $body, hasID: $hasID, hasIdContent: $hasIdContent, hasTitle: $hasTitle, hasBody: $hasBody}";
}
