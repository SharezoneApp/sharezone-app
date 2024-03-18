import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/ical_export/shared/ical_export_analytics.dart';
import 'package:sharezone/ical_export/shared/ical_export_dto.dart';
import 'package:sharezone/ical_export/shared/ical_export_gateway.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class ICalExportDialogController extends ChangeNotifier {
  final ICalExportGateway _gateway;
  final ICalExportAnalytics _analytics;
  final UserId _userId;

  ICalExportDialogState state = const ICalExportDialogState();

  ICalExportDialogController({
    required ICalExportGateway gateway,
    required ICalExportAnalytics analytics,
    required UserId userId,
  })  : _gateway = gateway,
        _analytics = analytics,
        _userId = userId;

  void create() async {
    _gateway.createIcalExport(
      ICalExportDto(
        id: _gateway.generateId(),
        name: state.name!,
        sources: state.sources,
        status: ICalExportStatus.building,
        userId: _userId,
      ),
    );
    _analytics.logCreate(state.sources);
    _setState(
      state.copyWith(status: CreateICalExportStatus.success),
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
      _setError(const CreateICalExportNameMissingError());
      return false;
    }
    return true;
  }

  bool _isSourcesValid() {
    if (state.sources.isEmpty) {
      _setError(const CreateICalExportSourcesMissingError());
      return false;
    }
    return true;
  }

  void setName(String name) {
    _setState(state.copyWith(name: name));
    if (_isNameValid() && state.error is CreateICalExportNameMissingError) {
      _setState(state.copyWith(error: () => null));
    }
  }

  void addSource(ICalExportSource source) {
    _setState(state.copyWith(sources: [...state.sources, source]));
    if (_isSourcesValid() &&
        state.error is CreateICalExportSourcesMissingError) {
      _setState(state.copyWith(error: () => null));
    }
  }

  void removeSource(ICalExportSource source) {
    _setState(state.copyWith(
        sources: state.sources.where((s) => s != source).toList()));
    _isSourcesValid();
  }

  void clear() {
    _setState(const ICalExportDialogState());
  }

  void _setState(ICalExportDialogState state) {
    this.state = state;
    notifyListeners();
  }

  void _setError(CreateICalExportError error) {
    _setState(state.copyWith(
      status: CreateICalExportStatus.error,
      error: () => error,
    ));
  }
}

class ICalExportDialogState extends Equatable {
  final String? name;
  final List<ICalExportSource> sources;

  final CreateICalExportStatus status;
  final CreateICalExportError? error;

  const ICalExportDialogState({
    this.name,
    this.sources = const [],
    this.status = CreateICalExportStatus.initial,
    this.error,
  });

  ICalExportDialogState copyWith({
    String? name,
    List<ICalExportSource>? sources,
    CreateICalExportStatus? status,
    CreateICalExportError? Function()? error,
  }) {
    return ICalExportDialogState(
      name: name ?? this.name,
      sources: sources ?? this.sources,
      status: status ?? this.status,
      error: error == null ? this.error : error(),
    );
  }

  @override
  List<Object?> get props => [name, sources, status, error];
}

enum CreateICalExportStatus {
  initial,
  success,
  error,
}

sealed class CreateICalExportError extends Equatable {
  const CreateICalExportError();
}

class CreateICalExportNameMissingError extends CreateICalExportError {
  const CreateICalExportNameMissingError();

  @override
  List<Object?> get props => [];
}

class CreateICalExportSourcesMissingError extends CreateICalExportError {
  const CreateICalExportSourcesMissingError();

  @override
  List<Object?> get props => [];
}

class CreateICalExportUnexpectedError extends CreateICalExportError {
  final String message;

  const CreateICalExportUnexpectedError(this.message);

  @override
  List<Object?> get props => [message];
}
