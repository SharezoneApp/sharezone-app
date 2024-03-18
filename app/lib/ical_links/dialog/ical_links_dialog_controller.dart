import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/ical_links/shared/ical_link_analytics.dart';
import 'package:sharezone/ical_links/shared/ical_link_dto.dart';
import 'package:sharezone/ical_links/shared/ical_links_gateway.dart';
import 'package:sharezone/ical_links/shared/ical_link_source.dart';
import 'package:sharezone/ical_links/shared/ical_link_status.dart';

class ICalLinksDialogController extends ChangeNotifier {
  final ICalLinksGateway _gateway;
  final ICalLinksAnalytics _analytics;
  final UserId _userId;

  ICalDialogState state = const ICalDialogState();

  ICalLinksDialogController({
    required ICalLinksGateway gateway,
    required ICalLinksAnalytics analytics,
    required UserId userId,
  })  : _gateway = gateway,
        _analytics = analytics,
        _userId = userId;

  void create() async {
    _gateway.createICalLink(
      ICalLinkDto(
        id: _gateway.generateId(),
        name: state.name!,
        sources: state.sources,
        status: ICalLinkStatus.building,
        userId: _userId,
      ),
    );
    _analytics.logCreate(state.sources);
    _setState(
      state.copyWith(status: ICalDialogStatus.success),
    );
  }

  bool validate() {
    if (!_isNameValid()) {
      return false;
    }

    if (!_isSourcesValid()) {
      return false;
    }

    return true;
  }

  bool _isNameValid() {
    if (state.name == null || state.name!.isEmpty) {
      _setError(const ICalDialogNameMissingError());
      return false;
    }
    return true;
  }

  bool _isSourcesValid() {
    if (state.sources.isEmpty) {
      _setError(const ICalDialogSourcesMissingError());
      return false;
    }
    return true;
  }

  void setName(String name) {
    _setState(state.copyWith(name: name));
    if (_isNameValid() && state.error is ICalDialogNameMissingError) {
      _setState(state.copyWith(error: () => null));
    }
  }

  void addSource(ICalLinkSource source) {
    _setState(state.copyWith(sources: [...state.sources, source]));
    if (_isSourcesValid() && state.error is ICalDialogSourcesMissingError) {
      _setState(state.copyWith(error: () => null));
    }
  }

  void removeSource(ICalLinkSource source) {
    _setState(state.copyWith(
        sources: state.sources.where((s) => s != source).toList()));
    _isSourcesValid();
  }

  void clear() {
    _setState(const ICalDialogState());
  }

  void _setState(ICalDialogState state) {
    this.state = state;
    notifyListeners();
  }

  void _setError(ICalDialogError error) {
    _setState(state.copyWith(
      status: ICalDialogStatus.error,
      error: () => error,
    ));
  }
}

class ICalDialogState extends Equatable {
  final String? name;
  final List<ICalLinkSource> sources;

  final ICalDialogStatus status;
  final ICalDialogError? error;

  const ICalDialogState({
    this.name,
    this.sources = const [],
    this.status = ICalDialogStatus.initial,
    this.error,
  });

  ICalDialogState copyWith({
    String? name,
    List<ICalLinkSource>? sources,
    ICalDialogStatus? status,
    ICalDialogError? Function()? error,
  }) {
    return ICalDialogState(
      name: name ?? this.name,
      sources: sources ?? this.sources,
      status: status ?? this.status,
      error: error == null ? this.error : error(),
    );
  }

  @override
  List<Object?> get props => [name, sources, status, error];
}

enum ICalDialogStatus {
  initial,
  success,
  error,
}

sealed class ICalDialogError extends Equatable {
  const ICalDialogError();
}

class ICalDialogNameMissingError extends ICalDialogError {
  const ICalDialogNameMissingError() : super();

  @override
  List<Object?> get props => [];
}

class ICalDialogSourcesMissingError extends ICalDialogError {
  const ICalDialogSourcesMissingError() : super();

  @override
  List<Object?> get props => [];
}

class ICalDialogUnexpectedError extends ICalDialogError {
  final String message;

  const ICalDialogUnexpectedError(this.message) : super();

  @override
  List<Object?> get props => [message];
}
