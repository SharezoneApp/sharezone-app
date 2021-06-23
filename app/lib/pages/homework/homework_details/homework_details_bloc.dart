import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details_view_factory.dart';
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

            if (view.hasAttachments)
              return view.copyWith(
                  attachmentStream: detailsViewFactory
                      .fileSharingGateway.cloudFilesGateway
                      .filesStreamAttachment(courseID, view.id));
            return view;
          },
        );

  void changeIsHomeworkDoneTo(bool newValue) =>
      gateway.changeIsHomeworkDoneTo(homeworkID, newValue);

  @override
  void dispose() {}
}
