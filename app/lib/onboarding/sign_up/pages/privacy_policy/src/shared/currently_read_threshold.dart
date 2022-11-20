import '../privacy_policy_src.dart';

/// The threshold at which a [DocumentSection] is marked as "currently read"
/// when the [DocumentSectionHeadingPosition] intersects with [position].
///
/// For the exact behavior for when a section is marked as active see
/// [CurrentlyReadingController] (and the tests).
///
/// This is encapsulated as a class for documentation purposes.
class CurrentlyReadThreshold {
  final double position;

  const CurrentlyReadThreshold(this.position)
      : assert(position >= 0.0 && position <= 1.0);

  bool intersectsOrIsPast(DocumentSectionHeadingPosition headingPosition) {
    return headingPosition.itemLeadingEdge <= position;
  }
}
