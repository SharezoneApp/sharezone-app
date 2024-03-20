// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller.dart';

class TermDetailsPageControllerFactory {
  const TermDetailsPageControllerFactory();

  TermDetailsPageController create(TermId termId) {
    return TermDetailsPageController(termId: termId);
  }
}
