import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional_internal.dart';

class SchoolClassFilterView {
  final List<SchoolClassView> schoolClassList;

  SchoolClassFilterView({@required this.schoolClassList}) {
    ArgumentError.checkNotNull(schoolClassList, 'schoolClassList');
    if (_moreThanOneSchoolClassSelected()) {
      throw ArgumentError(
          'SchoolClassFilterView must be not contain a selection of more than one school class');
    }
  }

  bool _moreThanOneSchoolClassSelected() {
    return schoolClassList
            .where((schoolClass) => schoolClass.isSelected == true)
            .length >
        1;
  }

  /// Gibt den Namen der ausgewählten Schulklasse zurück.
  /// Falls keine Schulklasse ausgewählt ist, wird null zurückgegeben.
  String get currentSchoolClassName =>
      hasSchoolClassSelected ? selectedSchoolClass.value.name : null;

  bool get hasMoreThanOneSchoolClass => schoolClassList.length > 1;

  bool get hasSchoolClassSelected => schoolClassList
      .where((schoolClass) => schoolClass.isSelected == true)
      .isNotEmpty;

  bool get shouldShowAllGroups => !hasSchoolClassSelected;

  Optional<SchoolClassView> get selectedSchoolClass {
    if (!hasSchoolClassSelected) return Optional.empty();

    return schoolClassList
        .singleWhere((schoolClass) => schoolClass.isSelected == true)
        .toOptional;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SchoolClassFilterView &&
        listEquals(other.schoolClassList, schoolClassList);
  }

  @override
  int get hashCode => schoolClassList.hashCode;

  @override
  String toString() =>
      'SchoolClassSelectionView(schoolClassList: $schoolClassList)';
}

class SchoolClassView {
  final GroupId id;
  final String name;
  final bool isSelected;

  const SchoolClassView({
    @required this.id,
    @required this.name,
    @required this.isSelected,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchoolClassView &&
        other.id == id &&
        other.name == name &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isSelected.hashCode;

  @override
  String toString() =>
      'SchoolClassView(id: $id, name: $name, isSelected: $isSelected)';
}
