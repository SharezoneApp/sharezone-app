import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/ical_export/list/ical_export_view.dart';
import 'package:sharezone/ical_export/shared/ical_export_dto.dart';
import 'package:sharezone/ical_export/shared/ical_export_gateway.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class IcalExportListController extends ChangeNotifier {
  final ICalExportGateway _gateway;

  IcalExportListState state = const IcalExportListLoading(views: []);
  late StreamSubscription<List<ICalExportDto>> _icalExportsSubscription;

  IcalExportListController({
    required ICalExportGateway gateway,
    required UserId userId,
  }) : _gateway = gateway {
    _icalExportsSubscription = _gateway
        .getIcalExportsStream(userId)
        .listen(_processIcalExports, onError: _handleError);
  }

  void _processIcalExports(List<ICalExportDto> exports) {
    final views = exports.toViews();

    // For available exports, the URL will be fetched in the background and set
    // once it's available.
    for (var view in views) {
      if (view.status == ICalExportStatus.available && !view.hasUrl) {
        unawaited(_fetchAndSetUrl(view.id));
      }
    }

    // However, we immediately set the views to the state, so the user can see
    // the exports.
    _setViews(views);
  }

  Future<void> _fetchAndSetUrl(ICalExportId id) async {
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
      // It could be that the export was deleted while we were fetching the
      // URL. In that case, we don't want to set the URL.
      return;
    }

    final updatedList = state.views.map((e) {
      if (e.id == id) return view.copyWith(url: url, error: error);
      return e;
    }).toList();

    _setViews(updatedList);
  }

  void _setViews(List<ICalExportView> views) {
    views.sortByName();
    state = IcalExportListLoaded(views: views);
    notifyListeners();
  }

  void _handleError(error) {
    state = IcalExportListError(
      message: error.toString(),
      views: state.views,
    );
    notifyListeners();
  }

  void deleteExport(ICalExportId id) {
    _gateway.deleteIcalExport(id);
  }

  @override
  void dispose() {
    _icalExportsSubscription.cancel();
    super.dispose();
  }
}

extension on List<ICalExportDto> {
  List<ICalExportView> toViews() {
    return map((dto) => ICalExportView.fromDto(dto)).toList();
  }
}

extension on List<ICalExportView> {
  void sortByName() {
    sort((a, b) => a.name.compareTo(b.name));
  }
}

sealed class IcalExportListState {
  final List<ICalExportView> views;

  const IcalExportListState({
    required this.views,
  });
}

class IcalExportListLoading extends IcalExportListState {
  const IcalExportListLoading({
    required super.views,
  });
}

class IcalExportListLoaded extends IcalExportListState {
  const IcalExportListLoaded({
    required super.views,
  });
}

class IcalExportListError extends IcalExportListState {
  final String message;

  const IcalExportListError({
    required this.message,
    required super.views,
  });
}
