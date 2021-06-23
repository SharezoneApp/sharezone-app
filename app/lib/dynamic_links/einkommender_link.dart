import 'package:dynamic_links/dynamic_links.dart';
import 'package:sharezone_common/helper_functions.dart';

enum EinkommensZeitpunkt { appstart, laufzeit, unbekannt }

class EinkommenderLink {
  final String typ;
  final Map<String, String> zusatzinformationen;
  final EinkommensZeitpunkt einkommensZeitpunkt;
  bool get empty =>
      isEmptyOrNull(typ) && zusatzinformationen == null ||
      zusatzinformationen.isEmpty;

  EinkommenderLink(
      {this.typ = "",
      this.zusatzinformationen = const {},
      this.einkommensZeitpunkt = EinkommensZeitpunkt.unbekannt})
      : assert(typ != null),
        assert(zusatzinformationen != null),
        assert(einkommensZeitpunkt != null);

  factory EinkommenderLink.fromDynamicLink(
      DynamicLinkData pendingDynamicLinkData,
      EinkommensZeitpunkt einkommensZeitpunkt) {
    if (pendingDynamicLinkData == null) {
      return EinkommenderLink();
    }
    final copiedQueryParameters = Map<String, String>.from(
        pendingDynamicLinkData?.link?.queryParameters ?? {});
    final type = copiedQueryParameters.remove("type") ?? "";

    return EinkommenderLink(
        typ: type,
        zusatzinformationen: copiedQueryParameters,
        einkommensZeitpunkt: einkommensZeitpunkt);
  }

  @override
  String toString() {
    return "EinkommenderLink(typ: $typ, zusatzinformationen: $zusatzinformationen, einkommensZeitpunkt: $einkommensZeitpunkt, empty: $empty)";
  }
}
