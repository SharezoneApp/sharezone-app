import 'package:app_functions/app_functions.dart';
import 'package:app_functions/exceptions.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/groups/group_join/models/group_join_exception.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone/groups/group_join/models/group_join_result_type.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';

class GroupJoinFunction {
  final ConnectionsGateway _connectionsGateway;
  final CrashAnalytics _crashAnalytics;

  GroupJoinFunction(this._connectionsGateway, this._crashAnalytics);

  Future<GroupJoinResult> runGroupJoinFunction({
    @required String enteredValue,
    List<String> coursesForSchoolClass,
    int version = 2,
  }) async {
    final appFunctionsResult = await _connectionsGateway.joinByKey(
        publicKey: enteredValue,
        coursesForSchoolClass: coursesForSchoolClass,
        version: version);
    final groupJoinResult = _mapAppFunctionsResultToGroupJoinResult(
        appFunctionsResult, enteredValue);

    // Logs Error to CrashAnalytics if it is an UnknownGroupJoinException!
    if (groupJoinResult is ErrorJoinResult &&
        groupJoinResult.groupJoinException is UnknownGroupJoinException) {
      final UnknownGroupJoinException unknownGroupJoinException =
          groupJoinResult.groupJoinException;
      _crashAnalytics.recordError(unknownGroupJoinException.exception, null);
    }
    return groupJoinResult;
  }

  GroupJoinResult _mapAppFunctionsResultToGroupJoinResult(
      AppFunctionsResult appFunctionsResult, String enteredValue) {
    try {
      if (appFunctionsResult.hasData) {
        final data = Map<String, dynamic>.from(appFunctionsResult.data);
        final resultType =
            GroupJoinResultTypeConverter.fromData(data['resultType']);
        if (resultType == GroupJoinResultType.successfull) {
          return SuccessfullJoinResult.fromData(data);
        }
        if (resultType == GroupJoinResultType.requireCourseSelections) {
          return RequireCourseSelectionsJoinResult.fromData(data);
        }
        if (resultType == GroupJoinResultType.notPublic) {
          return ErrorJoinResult(GroupNotPublicGroupJoinException());
        }
        if (resultType == GroupJoinResultType.alreadyMember) {
          return ErrorJoinResult(AlreadyMemberGroupJoinException());
        }
        if (resultType == GroupJoinResultType.notFound) {
          return ErrorJoinResult(
              SharecodeNotFoundGroupJoinException(enteredValue));
        }
        return ErrorJoinResult(UnknownGroupJoinException());
      } else {
        final exception = appFunctionsResult.exception;
        if (exception is NoInternetAppFunctionsException)
          return ErrorJoinResult(NoInternetGroupJoinException());
        return ErrorJoinResult(UnknownGroupJoinException(exception: exception));
      }
    } catch (exception) {
      return ErrorJoinResult(UnknownGroupJoinException(exception: exception));
    }
  }
}
