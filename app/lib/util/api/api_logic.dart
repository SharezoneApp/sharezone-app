/// Class for shared operations between different *_api.dart files
class APILogic {
  /// Used to transform the [DocumentReference.lokalerPfad] into the [CollectionReference.lokalerPfad]
  /// of the overlying Collection.
  ///
  /// Example:
  /// [documentRefPath] = "Homework/-LI30tSDzhwrCR4fwqxw"
  /// Output: "Homework"
  ///
  /// -> "Homework" is the Collection of the Database.
  /// -> "-LI30tSDzhwrCR4fwqxw" is a Document in the Database.
  static String parentOfPath(String documentRefPath) {
    int lastIndex = documentRefPath.lastIndexOf("/");
    assert(lastIndex != -1,
        "documentReferencePath of DocumentReference should have a '/' in it. - documentReferencePath: $documentRefPath");
    String collectionRefPath = documentRefPath.substring(0, lastIndex);
    return collectionRefPath;
  }
}
