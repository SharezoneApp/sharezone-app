// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_hausaufgabenheft_logik.dart';

FirestoreHomeworkDataSource createDefaultFirestoreRepository(
    CollectionReference homeworkCollection,
    String uid,
    CourseColorRetriever getCourseColorFromCourseId) {
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
