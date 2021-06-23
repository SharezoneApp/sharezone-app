import 'package:sharezone_common/helper_functions.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change.dart';

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

  factory ChangeDatabaseModel.fromData(Map<String, dynamic> data, {@required String id}) {
    return ChangeDatabaseModel._(
      id: id,
      version: data['version'],
      releaseDate: dateTimeFromTimestamp(data['releaseDate']),
      newFeatures: decodeList(data['newFeatures'], (it) => it),
      improvements: decodeList(data['improvements'], (it) => it),
      fixes: decodeList(data['fixes'], (it) => it),
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
