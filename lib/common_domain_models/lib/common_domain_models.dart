// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

/// Das ist ein Ort für alle Domain-Models, die zwischen allen Package die gleiche Definition haben.
/// Beispielsweise ist ein Sharecode oder eine User-Id überall gleich.
///
/// Ein Beispiel für etwas, was nicht da rein sollte ist eine Hausaufgabe:
/// Es gibt Beispielsweise eine Hausaufgabe in dem Kurs-Sinne (mehrere Mitglieder mit verschiedenen Erledigt-Status)
/// und eine Hausaufgabe im Nutzer-Sinne (hab ich die erledigt, ist die für mich privat?, etc).
library common_domain_models;

export 'src/sharecode.dart';
export 'src/ids/ids.dart';
