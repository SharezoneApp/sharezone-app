import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

class BlackboardItem {
  final String id;

  final DocumentReference courseReference;
  final String courseName;
  final String subject;
  final String subjectAbbreviation;
  final String latestEditor;

  final DocumentReference authorReference; // OLD
  final String authorID;
  final String authorName;
  final DateTime createdOn;

  final String title;
  final String text;
  final String pictureURL;
  final List<String> attachments;
  final bool sendNotification;

  // final List<String> unreadUsers; // NEW
  // final List<String> readUsers; // NEW
  // final List<String> archivedUsers; // NEW
  final Map<String, bool> forUsers; // OLD

  const BlackboardItem._({
    @required this.id,
    @required this.courseReference,
    @required this.courseName,
    @required this.subject,
    @required this.subjectAbbreviation,
    @required this.latestEditor,
    @required this.authorReference,
    @required this.authorID,
    @required this.authorName,
    @required this.title,
    @required this.text,
    @required this.pictureURL,
    @required this.createdOn,
    @required this.attachments,
    @required this.sendNotification,
    // @required this.unreadUsers, // NEW
    // @required this.readUsers, // NEW
    // @required this.archivedUsers, // NEW
    @required this.forUsers,
  });

  factory BlackboardItem.create({
    @required DocumentReference courseReference,
    @required DocumentReference authorReference,
    String authorID,
  }) {
    return BlackboardItem._(
      id: "",
      courseReference: courseReference,
      courseName: "",
      subject: "",
      subjectAbbreviation: "",
      latestEditor: "",
      authorReference: authorReference,
      authorID: authorID ?? authorReference?.id,
      authorName: "",
      title: "",
      text: null,
      pictureURL: "",
      createdOn: DateTime.now(),
      attachments: [],
      // unreadUsers: [], // NEW
      // readUsers: [], // NEW
      // archivedUsers: [], // NEW
      sendNotification: true,
      forUsers: {},
    );
  }

  factory BlackboardItem.fromData(Map<String, dynamic> data,
      {@required String id}) {
    return BlackboardItem._(
      id: id,
      courseReference: data['courseReference'] as DocumentReference,
      courseName: data['courseName'] as String,
      subject: data['subject'] as String,
      subjectAbbreviation: data['subjectAbbreviation'] as String,
      latestEditor: data['latestEditor'] as String,
      authorReference: data['authorReference'] as DocumentReference,
      authorID: data['authorID'] as String,
      authorName: data['authorName'] as String,
      title: data['title'] as String,
      text: data['text'] as String,
      pictureURL: data['pictureURL'] as String,
      createdOn: ((data['createdOn'] ?? Timestamp.now()) as Timestamp).toDate(),
      attachments: decodeList(data['attachments'], (it) => it as String),
      // unreadUsers: decodeList(data['unreadUsers'], (it) => it), // NEW
      // readUsers: decodeList(data['readUsers'], (it) => it), // NEW
      // archivedUsers: decodeList(data['archivedUsers'], (it) => it), // NEW
      sendNotification: data['sendNotification'] as bool,
      forUsers: decodeMap(data['forUsers'], (key, value) => value as bool),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseReference': courseReference,
      'courseName': courseName,
      'subject': subject,
      'subjectAbbreviation': subjectAbbreviation,
      'latestEditor': latestEditor,
      'authorReference': authorReference,
      'authorID': authorID,
      'authorName': authorName,
      'title': title,
      'text': text,
      'pictureURL':
          pictureURL == null || pictureURL.isEmpty ? "null" : pictureURL,
      'createdOn': Timestamp.fromDate(createdOn),
      'attachments': attachments,
      // 'unreadUsers': unreadUsers, // NEW
      // 'readUsers': readUsers, // NEW
      // 'archivedUsers': archivedUsers, // NEW
      'sendNotification': sendNotification,
      'forUsers': forUsers
    };
  }

  BlackboardItem copyWith({
    String id,
    DocumentReference courseReference,
    String courseName,
    String subject,
    String subjectAbbreviation,
    String latestEditor,
    DocumentReference authorReference,
    String authorID,
    String authorName,
    String title,
    String text,
    String pictureURL,
    DateTime createdOn,
    List<String> attachments,
    // List<String> unreadUsers, // NEW
    // List<String> readUsers, // NEW
    // List<String> archivedUsers, // NEW
    bool sendNotification,
    Map<String, bool> forUsers,
  }) {
    return BlackboardItem._(
      id: id ?? this.id,
      courseReference: courseReference ?? this.courseReference,
      courseName: courseName ?? this.courseName,
      subject: subject ?? this.subject,
      subjectAbbreviation: subjectAbbreviation ?? this.subjectAbbreviation,
      latestEditor: latestEditor ?? this.latestEditor,
      authorReference: authorReference ?? this.authorReference,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      text: text ?? this.text,
      pictureURL: pictureURL ?? this.pictureURL,
      createdOn: createdOn ?? this.createdOn,
      attachments: attachments ?? this.attachments,
      // unreadUsers: unreadUsers ?? this.unreadUsers, // NEW
      // readUsers: readUsers ?? this.readUsers, // NEW
      // archivedUsers: archivedUsers ?? this.archivedUsers, // NEW
      sendNotification: sendNotification ?? this.sendNotification,
      forUsers: forUsers ?? this.forUsers,
    );
  }
}
