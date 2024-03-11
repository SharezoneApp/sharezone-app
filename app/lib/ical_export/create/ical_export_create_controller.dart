import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/ical_export/shared/ical_export_analytics.dart';
import 'package:sharezone/ical_export/shared/ical_export_dto.dart';
import 'package:sharezone/ical_export/shared/ical_export_gateway.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class CreateICalExportController extends ChangeNotifier {
  final ICalExportGateway _gateway;
  final ICalExportAnalytics _analytics;

  CreateICalExportState state = const CreateICalExportState();

  CreateICalExportController({
    required ICalExportGateway gateway,
    required ICalExportAnalytics analytics,
  })  : _gateway = gateway,
        _analytics = analytics;

  void create() async {
    _gateway.createIcalExport(
      ICalExportDto(
        id: _gateway.generateId(),
        name: state.name!,
        sources: state.sources,
        status: ICalExportStatus.building,
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
    _setState(const CreateICalExportState());
  }

  void _setState(CreateICalExportState state) {
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

class CreateICalExportState extends Equatable {
  final String? name;
  final List<ICalExportSource> sources;

  final CreateICalExportStatus status;
  final CreateICalExportError? error;

  const CreateICalExportState({
    this.name,
    this.sources = const [],
    this.status = CreateICalExportStatus.initial,
    this.error,
  });

  CreateICalExportState copyWith({
    String? name,
    List<ICalExportSource>? sources,
    CreateICalExportStatus? status,
    CreateICalExportError? Function()? error,
  }) {
    return CreateICalExportState(
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
