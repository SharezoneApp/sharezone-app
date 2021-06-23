import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/helper_functions.dart';

class JitsiAuth {
  final FirebaseFunctions _functions;

  JitsiAuth(this._functions);

  Future<String> getToken(GroupId groupId, GroupType groupType) async {
    final result =
        await _functions.httpsCallable('GenerateJwtGroupMeeting').call(
      {
        'groupId': groupId.id,
        'groupType': enumToString<GroupType>(groupType),
      },
    );

    final json = Map<String, dynamic>.from(result.data);
    return json['jwt'];
  }
}
