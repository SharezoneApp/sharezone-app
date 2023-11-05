// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/homework/homework_details/homework_details_view_factory.dart';
import 'package:sharezone/util/api/homework_api.dart';

import 'homework_details_view.dart';

class HomeworkDetailsBloc extends BlocBase {
  final HomeworkGateway gateway;
  final String homeworkID;
  final HomeworkDetailsViewFactory detailsViewFactory;

  final Stream<HomeworkDetailsView> homework;

  static String courseID = '';

  HomeworkDetailsBloc(this.gateway, this.homeworkID, this.detailsViewFactory)
      : homework = gateway.singleHomeworkStream(homeworkID).asyncMap(
          (homework) async {
            final view = await detailsViewFactory.fromHomeworkDb(homework);

            if (view.hasAttachments) {
              return view.copyWith(
                  attachmentStream: detailsViewFactory
                      .fileSharingGateway.cloudFilesGateway
                      .filesStreamAttachment(courseID, view.id));
            }
            return view;
          },
        );

  void changeIsHomeworkDoneTo(bool newValue) =>
      gateway.changeIsHomeworkDoneTo(homeworkID, newValue);

  @override
  void dispose() {}
}
