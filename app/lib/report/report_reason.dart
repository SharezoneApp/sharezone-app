// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
