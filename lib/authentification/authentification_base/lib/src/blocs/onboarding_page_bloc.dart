import 'package:bloc_base/bloc_base.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class OnboardingPageBloc extends BlocBase {
  final StreamingSharedPreferences preference;

  OnboardingPageBloc(this.preference);

  @override
  void dispose() {}
}
