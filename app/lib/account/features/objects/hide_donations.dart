import 'package:sharezone/account/features/objects/feature.dart';

/// Wie kann der Donate-Button aus dem Drawer ausgeblendet werden? Im
/// User-Dokument muss das Attribut 'features' als Map hinzugefügt werden.
/// Danach muss zu dieser Map der Schlüssel "hideDonations" mit dem Wert "true"
/// hinzugefügt werden.
class HideDonations extends Feature {
  HideDonations() : super("hideDonations");
}
