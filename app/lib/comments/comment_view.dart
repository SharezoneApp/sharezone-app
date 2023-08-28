// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'misc.dart';

class CommentView {
  final String id;
  final String content;
  final String avatarAbbreviation;
  final String commentAge;
  final String userName;
  final CommentStatus status;
  final String likes;
  final bool hasPermissionsToManageComments;

  CommentView({
    this.content = "",
    this.avatarAbbreviation = "",
    this.commentAge = "",
    this.userName = "",
    this.status = CommentStatus.notRated,
    this.hasPermissionsToManageComments = false,
    this.likes = "0",
    this.id = "",
  });
}
