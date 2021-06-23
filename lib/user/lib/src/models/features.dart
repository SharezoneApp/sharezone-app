import 'package:meta/meta.dart';

class Features {
  final bool allColors;
  final bool hideDonations;

  Features({
    @required this.allColors,
    @required this.hideDonations,
  });

  Map<String, dynamic> toJson() {
    return {
      'allColors': allColors,
      'hide-donations': hideDonations,
    };
  }

  factory Features.fromJson(Map<String, dynamic> map) {
    return Features(
      allColors: map == null ? true : map['allColors'] ?? true,
      hideDonations: map == null ? false : map['hideDonations'] ?? false,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Features &&
      o.allColors == allColors &&
      o.hideDonations == hideDonations;
  }

  @override
  int get hashCode => allColors.hashCode ^ hideDonations.hashCode;

  @override
  String toString() => 'Features(allColors: $allColors, hideDonations: $hideDonations)';
}
