import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/dashboard/models/homework_view.dart';
import 'package:sharezone/main/application_bloc.dart';

import 'homework_card.dart';

Future<void> handleHomeworkTileLongPress(BuildContext context,
    {required HomeworkId homeworkId,
    void Function(bool)? setHomeworkStatus}) async {
  final dbModel = await getHomeworkDbModel(homeworkId);
  if (!context.mounted) return;
  final courseGateway = BlocProvider.of<SharezoneContext>(context).api.course;
  await showLongPressIfUserHasPermissions(
    context,
    setHomeworkStatus,
    HomeworkView.fromHomework(dbModel, courseGateway),
  );
}

/// Lädt das HomeworkDbModel, weil ein paar Funktionen noch dieses verlangen.
Future<HomeworkDto> getHomeworkDbModel(HomeworkId homeworkId) async {
  final CollectionReference<Map<String, dynamic>> homeworkCollection =
      FirebaseFirestore.instance.collection("Homework");

  final homeworkDocument = await homeworkCollection.doc(homeworkId.value).get();
  final homework =
      HomeworkDto.fromData(homeworkDocument.data()!, id: homeworkDocument.id);
  return homework;
}
