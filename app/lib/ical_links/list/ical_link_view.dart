// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_links/shared/ical_link_dto.dart';
import 'package:sharezone/ical_links/shared/ical_link_source.dart';
import 'package:sharezone/ical_links/shared/ical_link_status.dart';

class ICalLinkView {
  final ICalLinkId id;
  final String name;
  final ICalLinkStatus status;
  final List<ICalLinkSource> sources;
  final Uri? url;
  final String? error;

  const ICalLinkView({
    required this.id,
    required this.name,
    required this.sources,
    required this.status,
    required this.url,
    required this.error,
  });

  factory ICalLinkView.fromDto(ICalLinkDto dto) {
    return ICalLinkView(
      id: dto.id,
      name: dto.name,
      sources: dto.sources,
      status: dto.status,
      url: null,
      error: null,
    );
  }

  bool get hasUrl => url != null;
  bool get hasError => error != null;

  ICalLinkView copyWith({
    ICalLinkId? id,
    String? name,
    ICalLinkStatus? status,
    List<ICalLinkSource>? sources,
    Uri? url,
    String? error,
  }) {
    return ICalLinkView(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      sources: sources ?? this.sources,
      url: url ?? this.url,
      error: error ?? this.error,
    );
  }
}
