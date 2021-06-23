import 'realtime_completed_homework_loader.dart';
import 'realtime_updating_lazy_loading_controller.dart';

class RealtimeUpdatingLazyLoadingControllerFactory {
  final RealtimeCompletedHomeworkLoader _homeworkLoader;

  RealtimeUpdatingLazyLoadingControllerFactory(this._homeworkLoader);

  RealtimeUpdatingLazyLoadingController create(
      int initialNumberOfHomeworksToLoad) {
    return RealtimeUpdatingLazyLoadingController(_homeworkLoader,
        initialNumberOfHomeworksToLoad: initialNumberOfHomeworksToLoad);
  }
}
