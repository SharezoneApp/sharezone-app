import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:sharezone/donate/donation_service/donation_item.dart';

class DonationItemView {
  final DonationItemId id;
  final Optional<String> iconPath;
  final String title;
  final String price;

  DonationItemView({
    @required this.id,
    @required this.iconPath,
    @required this.title,
    @required this.price,
  });

  @override
  // ignore: avoid_renaming_method_parameters
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DonationItemView &&
        o.id == id &&
        o.iconPath == iconPath &&
        o.title == title &&
        o.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ iconPath.hashCode ^ title.hashCode ^ price.hashCode;
  }
}
