// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/homework/homework_page_bloc.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:sharezone/widgets/homework/homework_card.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class HomeworkArchivedPage extends StatefulWidget {
  static const String tag = "homework-archived-page";

  @override
  _HomeworkArchivedPageState createState() => _HomeworkArchivedPageState();
}

class _HomeworkArchivedPageState extends State<HomeworkArchivedPage> {
  SortBy sortBy = SortBy.date;

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return Builder(builder: (context) {
      final bloc = BlocProvider.of<HomeworkPageBloc>(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text("Archiviert"),
          centerTitle: true,
          actions: <Widget>[
            _PopupMenu(
              onChangedSortBy: (SortBy changedSortBy) =>
                  setState(() => sortBy = changedSortBy),
            )
          ],
        ),
        body: StreamBuilder<AppUser>(
          stream: api.user.userStream,
          builder: (context, userSnapshot) {
            final typeOfUser =
                userSnapshot.data?.typeOfUser ?? TypeOfUser.student;
            return StreamBuilder<List<HomeworkDto>>(
              stream: typeOfUser == TypeOfUser.student
                  ? bloc.homeworkDone
                  : bloc.homeworkList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                if (snapshot.hasError) {
                  return ShowCenteredError(error: snapshot.error.toString());
                }

                DateTime today = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
                List<HomeworkDto> homeworkList =
                    snapshot.data.where((HomeworkDto homework) {
                  DateTime todoUntil = DateTime(homework.todoUntil.year,
                      homework.todoUntil.month, homework.todoUntil.day);
                  return todoUntil.difference(today).inDays < 0;
                }).toList();
                log("length: ${homeworkList.length}");

                if (homeworkList.isEmpty)
                  return const Center(
                      child: Text("Es gibt keine archivierten Hausaufgaben."));

                // Sort the Homeworks;
                if (sortBy == SortBy.subject)
                  homeworkList.sort((HomeworkDto a, HomeworkDto b) {
                    var r = a.subject.compareTo(b.subject);
                    if (r != 0) return r;
                    return b.todoUntil.compareTo(a.todoUntil);
                  });
                else
                  homeworkList.sort((HomeworkDto a, HomeworkDto b) {
                    var r = b.todoUntil.compareTo(a.todoUntil);
                    if (r != 0) return r;
                    return a.subject.compareTo(b.subject);
                  });

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: homeworkList
                        .map((HomeworkDto h) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: HomeworkCard(
                                markedDate: false,
                                homework: h,
                                typeOfUser: typeOfUser,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({Key key, this.onChangedSortBy}) : super(key: key);

  final ValueChanged<SortBy> onChangedSortBy;

  void onPopupSortTap({BuildContext context, SortBy sortBy}) {
    onChangedSortBy(sortBy);
    showSnackSec(
      text: "Hausaufgaben werden nach dem ${sortByAsString[sortBy]} sortiert.",
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (String value) {
        switch (value) {
          case "SortByDate":
            onPopupSortTap(context: context, sortBy: SortBy.date);
            break;
          case "SortBySubject":
            onPopupSortTap(context: context, sortBy: SortBy.subject);
            break;
          default:
            log("Fehler! $value wurde beim PopupMenuButton nicht gefunden!");
        }
      },
      itemBuilder: (BuildContext context) => const <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'SortByDate',
          child: Text("Sortiere nach Datum"),
        ),
        PopupMenuItem<String>(
          value: 'SortBySubject',
          child: Text("Sortiere nach Fach"),
        ),
      ],
    );
  }
}
