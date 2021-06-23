import 'package:group_domain_models/group_domain_models.dart';

class SplittedMemberList {
  final List<MemberData> admins, creator, reader;

  SplittedMemberList({
    this.admins = const [],
    this.creator = const [],
    this.reader = const [],
  });
}
