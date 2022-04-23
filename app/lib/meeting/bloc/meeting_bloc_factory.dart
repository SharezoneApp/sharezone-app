// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/meeting/analytics/meeting_analytics.dart';
import 'package:sharezone/meeting/cache/meeting_cache.dart';
import 'package:sharezone/meeting/jitsi/jitsi_auth.dart';
import 'package:sharezone/meeting/jitsi/jitsi_launcher.dart';
import 'package:sharezone/meeting/models/meeting_id.dart';
import 'package:sharezone_utils/device_information_manager.dart';

import 'meeting_bloc.dart';

class MeetingBlocFactory extends BlocBase {
  final MeetingCache cache;
  final MeetingAnalytics analytics;
  final JitsiAuth jitsiAuth;
  final JitsiLauncher jitsiLauncher;
  final MobileDeviceInformationRetreiver mobileDeviceInformationRetreiver;

  MeetingBlocFactory({
    @required this.cache,
    @required this.analytics,
    @required this.jitsiAuth,
    @required this.jitsiLauncher,
    @required this.mobileDeviceInformationRetreiver,
  });

  MeetingBloc create({
    @required MeetingId meetingId,
    @required GroupId groupId,
    @required GroupType groupType,
    @required String groupName,
  }) {
    final params = MeetingBlocParameters(
      meetingCache: cache,
      analytics: analytics,
      jitsiAuth: jitsiAuth,
      jitsiLauncher: jitsiLauncher,
      mobileDeviceInfo: mobileDeviceInformationRetreiver,
      meetingId: meetingId,
      groupId: groupId,
      groupType: groupType,
      groupName: groupName,
    );
    return MeetingBloc(params);
  }

  @override
  void dispose() {}
}
