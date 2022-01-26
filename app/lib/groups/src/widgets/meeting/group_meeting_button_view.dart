// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

class GroupMeetingView {
  final String meetingId;

  /// `true` if the meetingId has not yet been created by the backend.
  final bool isLoading;

  /// Whether meetings are enabled in group settings.
  final bool isEnabled;

  GroupMeetingView({
    @required this.meetingId,
    @required this.isLoading,
    @required this.isEnabled,
  });
}

extension SchoolClassToGroupMeetingView on SchoolClass {
  GroupMeetingView toGroupMeetingView() {
    return GroupMeetingView(
      isLoading: isEmptyOrNull(meetingID),
      isEnabled: settings.isMeetingEnabled,
      meetingId: meetingID,
    );
  }
}

extension CourseToGroupMeetingView on Course {
  GroupMeetingView toGroupMeetingView() {
    return GroupMeetingView(
      isLoading: isEmptyOrNull(meetingID),
      isEnabled: settings.isMeetingEnabled,
      meetingId: meetingID,
    );
  }
}
