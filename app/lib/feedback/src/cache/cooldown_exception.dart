class CooldownException implements Exception {
  final String message;
  final Duration cooldown;

  CooldownException([this.message, this.cooldown]);

  @override
  String toString() {
    String report = "CooldownException";
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    if (cooldown != null) {
      report += " Cooldown: $cooldown";
    }
    return report;
  }
}