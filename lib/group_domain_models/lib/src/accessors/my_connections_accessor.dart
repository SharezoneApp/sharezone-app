import 'package:group_domain_models/group_domain_models.dart';

abstract class MyConnectionsAccesor {
  Stream<ConnectionsData> streamConnectionsData();
}
