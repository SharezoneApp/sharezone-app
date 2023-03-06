// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

typedef ObjectBuilder<T> = T Function(Map<String, dynamic> data);
typedef KeyObjectBuilder<T> = T Function(String key, Map<String, dynamic> data);
typedef ItemFilter<T> = bool Function(T item);
typedef GetKey<T> = String Function(T item);
typedef DataCreator<T, T2> = T Function(T item, T2 secondary);
typedef VoidData<T> = void Function(T item);
typedef Sorter<T> = int Function(T item1, T item2);

enum ChangeType { added, modified, removed }

class DataDocumentPackage<T> {
  DocumentReference reference;
  final bool directlyLoad, lockedOnStart, loadNullData;
  final ObjectBuilder<T> objectBuilder;
  bool _isInitiated = false;
  bool _isLocked = false;
  bool _loadedData = false;
  List<StreamController<T>> _listStreamController;
  List<StreamController<T>> _listStreamControllerOnce;
  StreamSubscription<DocumentSnapshot> _listener;
  DataDocumentPackage(
      {@required this.reference,
      @required this.objectBuilder,
      this.directlyLoad = false,
      this.lockedOnStart = false,
      this.loadNullData = false}) {
    _listStreamController = [];
    _listStreamControllerOnce = [];
    if (lockedOnStart) _isLocked = true;
    if (directlyLoad) {
      _initiate();
    }
  }

  T data;

  Stream<T> get stream {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    StreamController<T> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<T> get once {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    if (_loadedData) {
      return Future.value(data);
    } else {
      StreamController<T> newcontroller = StreamController();
      _listStreamControllerOnce.add(newcontroller);
      return newcontroller.stream.first;
    }
  }

  void _initiate() {
    _isInitiated = true;
    _listener = reference.snapshots().listen((event) {
      if (_loadedData == false) _loadedData = true;
      if (event.exists) {
        data = objectBuilder(event.data());
        for (StreamController<T> controller in _listStreamController)
          controller.add(data);
        for (StreamController<T> controller in _listStreamControllerOnce)
          controller.add(data);
        _listStreamControllerOnce.clear();
      } else {
        if (loadNullData)
          data = objectBuilder(event.data());
        else
          data = null;
        for (StreamController<T> controller in _listStreamController)
          controller.add(data);
        for (StreamController<T> controller in _listStreamControllerOnce)
          controller.add(data);
        _listStreamControllerOnce.clear();
      }
    });
  }

  Future<void> close() async {
    _listener?.cancel();
  }

  void unlock({DocumentReference newReference}) {
    _isLocked = false;
    if (newReference != null) reference = newReference;
    if (_listStreamController.isNotEmpty) if (_isInitiated == false)
      _initiate();
  }

  void forceUpdate() {
    for (StreamController<T> controller in _listStreamController)
      controller.add(data);
  }
}

class DataCollectionPackage<T> {
  Query reference;
  final bool directlyLoad, lockedOnStart;
  final KeyObjectBuilder<T> objectBuilder;
  final GetKey<T> getKey;
  final Sorter<T> sorter;
  bool _isInitiated = false;
  bool _isLocked = false;
  bool _loadedData = false;

  List<StreamController<List<T>>> _listStreamController;
  List<StreamController<List<T>>> _listStreamControllerOnce;
  StreamSubscription<QuerySnapshot> _listener;
  DataCollectionPackage(
      {@required this.reference,
      @required this.objectBuilder,
      this.getKey,
      this.directlyLoad = false,
      this.lockedOnStart = false,
      this.sorter}) {
    _listStreamController = [];
    _listStreamControllerOnce = [];
    if (lockedOnStart) _isLocked = true;
    if (directlyLoad) {
      _initiate();
    }
  }

  List<T> data = [];

  T getItem(String id) {
    if (id == null) return null;
    if (getKey == null) {
      throw Exception("Missing Implementation for getKey");
    } else
      return getItemByFilter((item) => getKey(item) == id);
  }

  T getItemByFilter(ItemFilter<T> filter) {
    Iterable<T> iterable = data?.where(filter);
    if (iterable != null && iterable.isNotEmpty)
      return iterable.first;
    else
      return null;
  }

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception("Missing Implementation for getKey");
    } else
      return getItemFilteredStream((item) => getKey(item) == id);
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream.map((data) => data.firstWhere(filter));
  }

  Stream<List<T>> getFilteredStream(ItemFilter<T> filter) {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream.map((data) => data.where(filter).toList());
  }

  Stream<List<T>> get stream {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    StreamController<List<T>> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<List<T>> get once {
    if (_isLocked == false) if (_isInitiated == false) _initiate();
    if (_loadedData) {
      return Future.value(data);
    } else {
      StreamController<List<T>> newcontroller = StreamController();
      _listStreamControllerOnce.add(newcontroller);
      return newcontroller.stream.first;
    }
  }

  void _initiate() {
    _isInitiated = true;
    _listener = reference.snapshots().listen((event) {
      if (_loadedData == false) _loadedData = true;
      var preData = event.docs
          .map((docSnap) => objectBuilder(docSnap.id, docSnap.data()))
          .toList();
      if (sorter != null) preData.sort(sorter);
      data = preData;
      for (StreamController<List<T>> controller in _listStreamController)
        controller.add(data);
      for (StreamController<List<T>> controller in _listStreamControllerOnce)
        controller.add(data);
      _listStreamControllerOnce.clear();
    });
  }

  Future<void> close() async {
    await _listener?.cancel();
  }

  void unlock({Query newReference}) {
    _isLocked = false;
    if (newReference != null) reference = newReference;
    if (_listStreamController.isNotEmpty) if (_isInitiated == false)
      _initiate();
  }
}
