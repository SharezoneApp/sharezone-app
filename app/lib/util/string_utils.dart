// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:string_similarity/string_similarity.dart';

class StringUtils {
  /// GIVES A VALUES HOW SIMILAR TWO STRINGS ARE AS A DOUBLE
  static double compareStrings(String s1, String s2) {
    return StringSimilarity.compareTwoStrings(s1, s2);
  }

  static double getHighestSimilarity(List<String> list, String s1) {
    double highest = 0;
    for (final s2 in list) {
      final value = compareStrings(s1, s2);
      if (value > highest) highest = value;
    }
    return highest;
  }
}
