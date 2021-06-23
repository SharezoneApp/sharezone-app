import 'package:app_functions/app_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:app_functions/sharezone_app_functions.dart';
import 'firebase_dependencies.dart';

class References {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final SharezoneAppFunctions functions;
  final CollectionReference schools, schoolClasses, courses, users;
  final CollectionReference members, lessons, events;

  References._({
    @required this.firestore,
    @required this.firebaseAuth,
    @required this.functions,
    @required this.schools,
    @required this.schoolClasses,
    @required this.courses,
    @required this.users,
    @required this.members,
    @required this.lessons,
    @required this.events,
  });

  factory References.init({
    @required FirebaseDependencies firebaseDependencies,
    @required AppFunctions appFunctions,
  }) {
    final firestore = firebaseDependencies.firestore;
    return References._(
      firestore: firestore,
      firebaseAuth: firebaseDependencies.auth,
      functions: SharezoneAppFunctions(appFunctions),
      schools: firestore.collection(CollectionNames.schools),
      schoolClasses: firestore.collection(CollectionNames.schoolClasses),
      courses: firestore.collection(CollectionNames.courses),
      users: firestore.collection(CollectionNames.user),
      lessons: firestore.collection(CollectionNames.lessons),
      events: firestore.collection(CollectionNames.events),
      members: firestore.collection(
          CollectionNames.members), // NEEDS TO BE CHANGED TO COLLECTIONGROUP!
    );
  }

  DocumentReference getConnectionsReference(String memberID) {
    return users
        .doc(MemberIDUtils.getUIDFromMemberID(memberID))
        .collection(CollectionNames.planners)
        .doc(MemberIDUtils.getPlannerIDFromMemberID(memberID));
  }

  DocumentReference getCourseReference(String courseID) {
    return courses.doc(courseID);
  }
}

class MemberIDUtils {
  static String getMemberID({@required String uid}) {
    return uid;
    // ALTERNATIVE: return "$uid::default"
  }

  static String getUIDFromMemberID(String memberID) {
    return memberID;
    // ALTERNATIVE: return memberID.split("::")[0];
  }

  /*THE PLANNERID GIVES THE USER THE ABILITY TO HAVE MULTIPLE PLANNERS AT ONCE,
  WHILE NOT IMPLEMENTED CURRENTLY, THIS IS FOR POSSIBILE FEATURES IN THE FUTURE
  */
  static String getPlannerIDFromMemberID(String memberID) {
    return "default";
    // ALTERNATIVE: return memberID.split("::")[1];
  }
}

class CollectionNames {
  static const homework = 'Homework';
  static const members = 'Members';
  static const courses = 'Courses';
  static const schoolClasses = 'SchoolClasses';
  static const schools = 'Schools';
  static const user = 'User';
  static const planners = 'Planners';
  static const lessons = 'Lessons';
  static const events = 'Events';
  static const reports = 'Reports';
  static const files = 'Files';
  static const fileSharing = 'FileSharing';
  static const blackboard = 'Blackboard';
  static const referrals = 'Referrals';
  static const publicKey = 'PublicKeys';
  static const qrSignIn = 'QrSignIn';
  static const comments = 'comments';
}
