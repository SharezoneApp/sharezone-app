import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/util/API.dart';

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
