import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_hausaufgabenheft_logik/src/firestore_homework_data_source.dart';

import 'firestore_realtime_completed_homework_loader.dart';
import 'homework_transformation.dart';
import 'realtime_updating_lazy_loading_controller_factory.dart';

FirestoreHomeworkDataSource createDefaultFirestoreRepository(
    CollectionReference homeworkCollection,
    String uid,
    CourseColorRetreiver getCourseColorFromCourseId) {
  final homeworkLoader = FirestoreRealtimeCompletedHomeworkLoader(
    homeworkCollection,
    uid,
    HomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );

  final lazyLoadingControllerFactory =
      RealtimeUpdatingLazyLoadingControllerFactory(homeworkLoader);
  final firestoreHomeworkRepository = FirestoreHomeworkDataSource(
    homeworkCollection,
    uid,
    lazyLoadingControllerFactory.create,
    HomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );
  return firestoreHomeworkRepository;
}
