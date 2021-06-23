import 'src/id.dart';

/// Id für eine Gruppe (Kurs, Klasse, etc)
/// Der Gedanke dahinter ist, dass die für Operationen, die möglichweise
/// für mehrere Arten von Gruppen gelten könnte als Parameter genutzt werden kann.
class GroupId extends Id {
  GroupId(String id, [String typeOfGroup])
      : super(id, typeOfGroup ?? 'GroupId');
}
