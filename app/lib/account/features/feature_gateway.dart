import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/account/features/objects/all_colors.dart';
import 'package:sharezone/account/features/objects/feature.dart';
import 'package:sharezone/account/features/objects/hide_donations.dart';
import 'package:user/user.dart';

class FeatureGateway {
  final _unlockedFeaturesSubject = BehaviorSubject<Set<Feature>>();
  Stream<Set<Feature>> get unlockedFeatures => _unlockedFeaturesSubject;

  FeatureGateway(CollectionReference userCollection, String uid) {
    loadFeatures(userCollection, uid);
  }

  void loadFeatures(
      CollectionReference<Map<String, dynamic>> users, String uid) {
    final docStream = users.doc(uid).snapshots();
    docStream.listen((doc) {
      final featureSet = <Feature>{};

      final features = Features.fromJson(doc?.data()['features']);
      if (features != null) {
        if (features.allColors) featureSet.add(AllColors());
        if (features.hideDonations) featureSet.add(HideDonations());
      }

      _unlockedFeaturesSubject.sink.add(featureSet);
    });
  }

  void dispose() {
    _unlockedFeaturesSubject.close();
  }
}
