import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharezoneContext extends BlocBase {
  SharezoneContext(this.api, this.streamingSharedPreferences,
      this.sharedPreferences, this.navigationService, this.analytics);

  final SharezoneGateway api;

  final Analytics analytics;

  final StreamingSharedPreferences streamingSharedPreferences;

  final SharedPreferences sharedPreferences;

  final NavigationService navigationService;

  @override
  void dispose() {}
}
