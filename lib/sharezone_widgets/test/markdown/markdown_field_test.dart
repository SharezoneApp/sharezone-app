import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(MarkdownField, () {
    testWidgets('should not display markdown helper text when not focused',
        (tester) async {
      await tester.pumpWidgetBuilder(MarkdownField(onChanged: (_) {}));

      expect(find.byType(MarkdownSupport), findsNothing);
    });

    testWidgets('should display markdown helper text when focused',
        (tester) async {
      await tester.pumpWidgetBuilder(MarkdownField(onChanged: (_) {}));

      await tester.tap(find.byType(PrefilledTextField));
      await tester.pump();

      expect(find.byType(MarkdownSupport), findsOneWidget);
    });
  });
}
