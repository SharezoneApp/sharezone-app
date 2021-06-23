import 'action.dart';

abstract class DashboardTip {
  final String title;
  final String text;
  final Action action;

  DashboardTip(this.title, this.text, this.action);

  Stream<bool> shouldShown();
  void markAsShown();
}