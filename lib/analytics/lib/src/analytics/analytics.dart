import 'package:sharezone_common/helper_functions.dart';
import 'package:meta/meta.dart';

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> data;

  const AnalyticsEvent(this.name, {this.data});

  @override
  String toString() {
    return "$runtimeType(name:$name, data: $data)";
  }
}

// ignore: one_member_abstracts
abstract class AnalyticsBackend {
  const AnalyticsBackend();

  void log(String name, [Map<String, dynamic> data]);

  Future<void> setAnalyticsCollectionEnabled(bool value);
  Future<void> logSignUp({
    @required String signUpMethod,
  });
  Future<void> setCurrentScreen({
    @required String screenName,
  });
  Future<void> setUserProperty({@required String name, @required String value});
}

class Analytics {
  final AnalyticsBackend _backend;

  const Analytics(this._backend);

  void log(AnalyticsEvent event) {
    if (!isEmptyOrNull(event.name)) {
      _backend.log(event.name, event.data ?? {});
    }
  }

  void setAnalyticsCollectionEnabled(bool value) {
    _backend.setAnalyticsCollectionEnabled(value);
  }

  Future<void> logSignUp({
    @required String signUpMethod,
  }) {
    return _backend.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> setCurrentScreen({
    @required String screenName,
  }) {
    return _backend.setCurrentScreen(screenName: screenName);
  }

  Future<void> setUserProperty(
          {@required String name, @required String value}) =>
      _backend.setUserProperty(name: name, value: value);
}
