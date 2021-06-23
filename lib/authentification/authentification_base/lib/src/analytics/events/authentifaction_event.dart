import 'package:meta/meta.dart';
import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

class AuthentifactionEvent extends AnalyticsEvent {
  AuthentifactionEvent({@required this.provider, @required String name})
      : assert(isNotEmptyOrNull(provider)),
        super(name);

  final String provider;

  @override
  Map<String, dynamic> get data => {"${name}With": provider};
}
