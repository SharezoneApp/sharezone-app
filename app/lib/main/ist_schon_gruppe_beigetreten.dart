// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/util/api.dart';

Future<bool> istSchonGruppeMitSharecodeBeigetreten(
    SharezoneGateway sharezoneGateway, Sharecode sharecode) async {
  final kursBereitsBeigetreten =
      await istBereitsKursMitSharecodeBeigetreten(sharezoneGateway, sharecode);
  if (kursBereitsBeigetreten) return true;
  return await istBereitsSchulklasseMitSharecodeBeigetreten(
      sharezoneGateway, sharecode);
}

Future<bool> istBereitsSchulklasseMitSharecodeBeigetreten(
    SharezoneGateway sharezoneGateway, Sharecode sharecode) async {
  final schoolClasses =
      await sharezoneGateway.schoolClassGateway.stream().first;
  final isAlreadyInClass = schoolClasses
          ?.where((schoolClass) => schoolClass?.sharecode == '$sharecode')
          ?.isNotEmpty ??
      false;
  return isAlreadyInClass;
}

Future<bool> istBereitsKursMitSharecodeBeigetreten(
    SharezoneGateway sharezoneGateway, Sharecode publicKey) async {
  final courses = await sharezoneGateway.course.getCourses();
  final isAlreadyInCourse =
      courses.where((course) => course.sharecode == '$publicKey').isNotEmpty;
  return isAlreadyInCourse;
}
