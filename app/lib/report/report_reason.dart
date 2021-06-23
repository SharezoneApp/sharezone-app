enum ReportReason {
  spam,
  bullying,
  pornographicContent,
  violentContent,
  illegalContnet,
  other
}

String getReportReasonUiText(ReportReason reason) {
  switch (reason) {
    case ReportReason.bullying:
      return 'Mobbing';
    case ReportReason.other:
      return 'Sonstiges';
    case ReportReason.pornographicContent:
      return 'Pornografische Inhalte';
    case ReportReason.illegalContnet:
      return 'Rechtswidrige Inhalte';
    case ReportReason.violentContent:
      return 'Gewaltsame oder abstoßende Inhalte';
    case ReportReason.spam:
      return 'Spam';
  }
  return null;
}
