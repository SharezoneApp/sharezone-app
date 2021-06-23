import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

class DonationItemId extends Id {
  DonationItemId(String id) : super(id, 'DonationItemId');
}

class DonationItem {
  final DonationItemId id;
  final String title;
  final String formattedPrice;

  DonationItem({
    @required this.id,
    @required this.title,
    @required this.formattedPrice,
  });
}
