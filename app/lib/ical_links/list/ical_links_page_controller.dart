import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/ical_links/list/ical_link_view.dart';
import 'package:sharezone/ical_links/shared/ical_link_dto.dart';
import 'package:sharezone/ical_links/shared/ical_links_gateway.dart';
import 'package:sharezone/ical_links/shared/ical_link_status.dart';

class IcalLinksPageController extends ChangeNotifier {
  final ICalLinksGateway _gateway;

  ICalLinksPageState state = const ICalLinksPageStateLoading(views: []);
  late StreamSubscription<List<ICalLinkDto>> _iCalLinksSubscription;

  IcalLinksPageController({
    required ICalLinksGateway gateway,
    required UserId userId,
  }) : _gateway = gateway {
    _iCalLinksSubscription = _gateway
        .getICalLinksStream(userId)
        .listen(_processICalLinks, onError: _handleError);
  }

  void _processICalLinks(List<ICalLinkDto> dtos) {
    final views = dtos.toViews();

    // For available links, the URL will be fetched in the background and set
    // once it's available.
    for (var view in views) {
      if (view.status == ICalLinkStatus.available && !view.hasUrl) {
        unawaited(_fetchAndSetUrl(view.id));
      }
    }

    // However, we immediately set the views to the state, so the user can see
    // the link tile.
    _setViews(views);
  }

  Future<void> _fetchAndSetUrl(ICalLinkId id) async {
    Uri? url;
    String? error;
    try {
      url = Uri.parse(await _gateway.getFancyUrl(id));
    } on FirebaseFunctionsException catch (e) {
      error = '[${e.plugin}/${e.code}] ${e.message}';
    } on Exception catch (e) {
      error = '$e';
    }

    final view = state.views.firstWhereOrNull((element) => element.id == id);
    if (view == null) {
      // It could be that the link was deleted while we were fetching the
      // URL. In that case, we don't want to set the URL.
      return;
    }

    final updatedList = state.views.map((e) {
      if (e.id == id) return view.copyWith(url: url, error: error);
      return e;
    }).toList();

    _setViews(updatedList);
  }

  void _setViews(List<ICalLinkView> views) {
    views.sortByName();
    state = ICalLinksPageStateLoaded(views: views);
    notifyListeners();
  }

  void _handleError(error) {
    state = ICalLinksPageStateError(
      message: error.toString(),
      views: state.views,
    );
    notifyListeners();
  }

  void deleteLink(ICalLinkId id) {
    _gateway.deleteICalLink(id);
  }

  @override
  void dispose() {
    _iCalLinksSubscription.cancel();
    super.dispose();
  }
}

extension on List<ICalLinkDto> {
  List<ICalLinkView> toViews() {
    return map((dto) => ICalLinkView.fromDto(dto)).toList();
  }
}

extension on List<ICalLinkView> {
  void sortByName() {
    sort((a, b) => a.name.compareTo(b.name));
  }
}

sealed class ICalLinksPageState {
  final List<ICalLinkView> views;

  const ICalLinksPageState({
    required this.views,
  });
}

class ICalLinksPageStateLoading extends ICalLinksPageState {
  const ICalLinksPageStateLoading({
    required super.views,
  });
}

class ICalLinksPageStateLoaded extends ICalLinksPageState {
  const ICalLinksPageStateLoaded({
    required super.views,
  });
}

class ICalLinksPageStateError extends ICalLinksPageState {
  final String message;

  const ICalLinksPageStateError({
    required this.message,
    required super.views,
  });
}
