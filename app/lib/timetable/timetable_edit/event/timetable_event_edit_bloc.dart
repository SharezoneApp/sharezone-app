// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_base/bloc_base.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';
import 'package:time/time.dart';

class TimetableEditEventBloc extends BlocBase {
  final _courseSegmentSubject = BehaviorSubject<Course>();
  final _startTimeSubject = BehaviorSubject<Time>();
  final _endTimeSubject = BehaviorSubject<Time>();
  final _roomSubject = BehaviorSubject<String>();
  final _titleSubject = BehaviorSubject<String>();
  final _detailSubject = BehaviorSubject<String>();
  final _dateSubject = BehaviorSubject<Date>();
  final _sendNotificationSubject = BehaviorSubject<bool>();
  final _localFilesSubject = BehaviorSubject.seeded(<LocalFile>[]);
  final _cloudFilesSubject = BehaviorSubject.seeded(<CloudFile>[]);
  final List<CloudFile> _initialCloudFiles = [];

  final CalendricalEvent initialEvent;
  final TimetableGateway gateway;
  final ConnectionsGateway connectionsGateway;
  final MarkdownAnalytics markdownAnalytics;
  final FileSharingGateway fileSharingGateway;
  final UserGateway userGateway;

  TimetableEditEventBloc({
    required this.gateway,
    required this.initialEvent,
    required this.connectionsGateway,
    required this.markdownAnalytics,
    required this.fileSharingGateway,
    required this.userGateway,
  }) {
    Course course =
        connectionsGateway.current()!.courses[initialEvent.groupID]!;
    _changeCourse(course);
    changeStartTime(initialEvent.startTime);
    changeEndTime(initialEvent.endTime);
    if (initialEvent.place != null) {
      changeRoom(initialEvent.place!);
    }
    changeDate(initialEvent.date);
    changeTitle(initialEvent.title);
    if (initialEvent.detail != null) {
      changeDetail(initialEvent.detail!);
    }
    changeSendNotification(initialEvent.sendNotification);
    loadInitialCloudFiles();
  }

  Stream<Course> get course => _courseSegmentSubject;
  Stream<Time> get startTime => _startTimeSubject;
  Stream<Time> get endTime => _endTimeSubject;
  Stream<String> get room => _roomSubject;
  Stream<String> get title => _titleSubject;
  Stream<String> get detail => _detailSubject;
  Stream<Date> get date => _dateSubject;
  Stream<bool> get sendNotification => _sendNotificationSubject;
  Stream<List<LocalFile>> get localFiles => _localFilesSubject;
  Stream<List<CloudFile>> get cloudFiles => _cloudFilesSubject;

  Function(Course) get _changeCourse => _courseSegmentSubject.sink.add;
  Function(Date) get changeDate => _dateSubject.sink.add;
  Function(Time) get changeStartTime => _startTimeSubject.sink.add;
  Function(Time) get changeEndTime => _endTimeSubject.sink.add;
  Function(String) get changeRoom => _roomSubject.sink.add;
  Function(String) get changeTitle => _titleSubject.sink.add;
  Function(String) get changeDetail => _detailSubject.sink.add;
  Function(bool) get changeSendNotification =>
      _sendNotificationSubject.sink.add;
  Function(List<LocalFile>) get addLocalFiles => (localFiles) {
    final list = <LocalFile>[];
    list.addAll(_localFilesSubject.value);
    list.addAll(localFiles);
    _localFilesSubject.sink.add(list);
  };
  Function(LocalFile) get removeLocalFile => (localFile) {
    final list = <LocalFile>[];
    list.addAll(_localFilesSubject.value);
    list.remove(localFile);
    _localFilesSubject.sink.add(list);
  };
  Function(CloudFile) get removeCloudFile => (cloudFile) {
    final list = <CloudFile>[];
    list.addAll(_cloudFilesSubject.value);
    list.remove(cloudFile);
    _cloudFilesSubject.sink.add(list);
  };

  Future<void> loadInitialCloudFiles() async {
    final cloudFiles =
        await fileSharingGateway.cloudFilesGateway
            .filesStreamAttachment(initialEvent.groupID, initialEvent.eventID)
            .first;
    _cloudFilesSubject.sink.add(cloudFiles);
    _initialCloudFiles.addAll(cloudFiles);
  }

  bool _isValid() {
    if (_isCourseValid() &&
        _isStartTimeValid() &&
        _isEndTimeValid() &&
        _isDateValid() &&
        _isTitleValid() &&
        isStartBeforeEnd()) {
      return true;
    }
    return false;
  }

  Future<void> submit() async {
    if (_isValid()) {
      final course = _courseSegmentSubject.valueOrNull;
      final startTime = _startTimeSubject.valueOrNull;
      final endTime = _endTimeSubject.valueOrNull;
      final room = _roomSubject.valueOrNull;
      final date = _dateSubject.valueOrNull;
      final title = _titleSubject.valueOrNull;
      final detail = _detailSubject.valueOrNull;
      final sendNotification = _sendNotificationSubject.valueOrNull;
      final localFiles = _localFilesSubject.valueOrNull ?? const <LocalFile>[];
      final cloudFiles = _cloudFilesSubject.valueOrNull ?? const <CloudFile>[];

      log(
        "isValid: true; ${course.toString()}; $startTime; $endTime; $room $title $date $detail",
      );

      final removedCloudFiles = matchRemovedCloudFilesFromTwoList(
        _initialCloudFiles,
        cloudFiles,
      );
      for (final removedFile in removedCloudFiles) {
        await fileSharingGateway.removeReferenceData(
          removedFile.id!,
          ReferenceData(type: ReferenceType.event, id: initialEvent.eventID),
        );
      }

      final editorName = (await userGateway.userStream.first)?.name ?? "-";
      final editorID = userGateway.authUser?.uid ?? gateway.memberID;
      final newAttachments = await fileSharingGateway.uploadAttachments(
        IList(localFiles),
        course!.id,
        editorID,
        editorName,
      );
      for (final attachment in newAttachments) {
        await fileSharingGateway.addReferenceData(
          attachment,
          ReferenceData(type: ReferenceType.event, id: initialEvent.eventID),
        );
      }

      final attachments = [
        for (final file in cloudFiles) if (file.id != null) file.id!,
        ...newAttachments,
      ];

      final event = initialEvent.copyWith(
        groupID: course?.id,
        place: room,
        startTime: startTime,
        endTime: endTime,
        date: date,
        title: title,
        detail: detail,
        attachments: attachments,
        sendNotification: sendNotification,
        latestEditor: gateway.memberID,
      );

      await gateway.editEvent(event);

      if (markdownAnalytics.containsMarkdown(detail)) {
        markdownAnalytics.logMarkdownUsedEvent();
      }
    }
  }

  bool isStartTimeEmpty() => _startTimeSubject.valueOrNull == null;
  bool isEndTimeEmpty() => _endTimeSubject.valueOrNull == null;

  bool _isCourseValid() {
    final validatorCourse = NotNullValidator(_courseSegmentSubject.valueOrNull);
    if (!validatorCourse.isValid()) {
      throw InvalidCourseException();
    }
    return true;
  }

  bool _isStartTimeValid() {
    final validatorStartTime = NotNullValidator(_startTimeSubject.valueOrNull);
    if (!validatorStartTime.isValid()) {
      throw InvalidStartTimeException();
    }
    return true;
  }

  bool _isEndTimeValid() {
    final validatorEndTime = NotNullValidator(_endTimeSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      throw InvalidEndTimeException();
    }
    return true;
  }

  bool _isDateValid() {
    final validatorEndTime = NotNullValidator(_dateSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      throw InvalidDateException();
    }
    return true;
  }

  bool _isTitleValid() {
    final validatorEndTime = NotNullValidator(_titleSubject.valueOrNull);
    if (!validatorEndTime.isValid()) {
      throw InvalidTitleException();
    }
    return true;
  }

  bool isStartBeforeEnd() {
    final startTime = _startTimeSubject.valueOrNull;
    final endTime = _endTimeSubject.valueOrNull;
    if (startTime != null && endTime != null) {
      return startTime.isBefore(endTime);
    }
    return false;
  }

  @override
  void dispose() {
    _courseSegmentSubject.close();
    _startTimeSubject.close();
    _endTimeSubject.close();
    _roomSubject.close();
    _titleSubject.close();
    _detailSubject.close();
    _dateSubject.close();
    _sendNotificationSubject.close();
    _localFilesSubject.close();
    _cloudFilesSubject.close();
  }
}
