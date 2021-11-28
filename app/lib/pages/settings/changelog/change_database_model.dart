import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';
import 'package:sharezone_common/helper_functions.dart';

class ChangeDatabaseModel {
  final String id;
  final String version;
  final DateTime releaseDate;

  final List<String> newFeatures;
  final List<String> improvements;
  final List<String> fixes;

  const ChangeDatabaseModel._({
    @required this.id,
    @required this.version,
    @required this.releaseDate,
    @required this.newFeatures,
    @required this.improvements,
    @required this.fixes,
  });

  factory ChangeDatabaseModel.create() {
    return ChangeDatabaseModel._(
      id: "",
      version: "",
      releaseDate: null,
      newFeatures: [],
      improvements: [],
      fixes: [],
    );
  }

  factory ChangeDatabaseModel.fromData(Map<String, dynamic> data,
      {@required String id}) {
    return ChangeDatabaseModel._(
      id: id,
      version: data['version'] as String,
      releaseDate: dateTimeFromTimestamp(data['releaseDate'] as Timestamp),
      newFeatures: decodeList(data['newFeatures'], (it) => it as String),
      improvements: decodeList(data['improvements'], (it) => it as String),
      fixes: decodeList(data['fixes'], (it) => it as String),
    );
  }

  Change toChange() => Change(
        fixes: fixes,
        releaseDate: releaseDate,
        newFeatures: newFeatures,
        improvements: improvements,
        version: Version(name: version),
      );

  ChangeDatabaseModel copyWith({
    String id,
    String version,
    DateTime releaseDate,
    List<String> newFeatures,
    List<String> improvements,
    List<String> fixes,
  }) {
    return ChangeDatabaseModel._(
      id: id ?? this.id,
      version: version ?? this.version,
      releaseDate: releaseDate ?? this.releaseDate,
      newFeatures: newFeatures ?? this.newFeatures,
      improvements: improvements ?? this.improvements,
      fixes: fixes ?? this.fixes,
    );
  }
}
