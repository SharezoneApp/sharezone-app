import 'package:sharezone/feedback/src/models/user_feedback.dart';
import 'package:test/test.dart';

void main() {
  group('Feedback', () {
    test('equality', () {
      UserFeedback a = UserFeedback.create().copyWith(
          rating: 5.0,
          dislikes: "d",
          heardFrom: "h",
          likes: "l",
          missing: "m",
          uid: "u",
          userContactInformation: "uci");

      UserFeedback b = UserFeedback.create().copyWith(
          rating: 5.0,
          dislikes: "d",
          heardFrom: "h",
          likes: "l",
          missing: "m",
          uid: "u",
          userContactInformation: "uci");

      UserFeedback c = UserFeedback.create().copyWith(dislikes: "d");
      expect(a, equals(b));
      expect(a.copyWith(dislikes: "dd"), isNot(equals(c)));
    });
  });
}
