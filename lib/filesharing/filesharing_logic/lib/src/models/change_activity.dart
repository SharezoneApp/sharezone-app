import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

class ChangeActivity {
  final String authorID;
  final String authorName;
  final DateTime changedOn;

  ChangeActivity({
    @required this.authorID,
    @required this.authorName,
    @required this.changedOn,
  });

  factory ChangeActivity.fromData(Map<String, dynamic> data) {
    return ChangeActivity(
        authorID: data['authorID'],
        authorName: data['authorName'],
        changedOn: dateTimeFromTimestamp(data['changedOn']));
  }

  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'authorName': authorName,
      'changedOn': timestampFromDateTime(changedOn),
    };
  }

  ChangeActivity copyWith({
    String authorID,
    String authorName,
    DateTime changedOn,
  }) {
    return ChangeActivity(
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      changedOn: changedOn ?? this.changedOn,
    );
  }
}
