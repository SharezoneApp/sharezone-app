// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// Sorts the [listToSort] sequentially with the [comparisions].
/// If a comparision does treat the objects as equal, the next comparision will be executed on those.
/// The result of the last comparision will be used either way.
///
/// Example:
/// h1 - Englisch: “AB”- (01.01.19)
/// h2 - Englisch: “CD hören” - (01.01.19)
/// h3 - Informatik: “Buch S. 33” - (01.01.19)
/// h4 - Informatik: “Vortrag” (01.01.19)
/// h5 - Mathematik: “Buch S. 33” (01.01.19)
/// h6 - Informatik: “Buch S. 33” (06.10.19)
/// h7 - Mathematik: “Buch S. 37” (06.10.20)
///
/// `sortWithOperations(homeworks, [subjectComparer, dateComparer, titleComparer]);`
///
/// Leads to:
/// h1 - Englisch: “AB” (01.01.19)
/// h2 - Englisch: “CD hören” (01.01.19)
/// h3 - Informatik: “Buch S. 33” (01.01.19)
/// h4 - Informatik: “Vortrag” (01.01.19)
/// h6 - Informatik: “Buch S. 33” (06.10.19)
/// h5 - Mathematik: “Buch S. 33” (01.01.19)
/// h7 - Mathematik: “Buch S. 37” (06.10.20)
void sortWithOperations<T>(
    List<T> listToSort, List<Comparision<T>> comparisions) {
  final last = comparisions.last;
  listToSort.sort((ha1, ha2) {
    for (final comparision in comparisions) {
      final result = comparision(ha1, ha2);
      if (result.objectsAreNotEqual || comparision == last) {
        return result.compareToResult;
      }
    }
    return 0;
  });
}

typedef Comparision<T> = ComparisonResult Function(T obj1, T obj2);

/// The result of a compareTo function.
/// Made for better readilbility.
class ComparisonResult {
  bool get objectsAreEqual => compareToResult == 0;
  bool get objectsAreNotEqual => !objectsAreEqual;
  final int compareToResult;

  ComparisonResult(this.compareToResult);
}
