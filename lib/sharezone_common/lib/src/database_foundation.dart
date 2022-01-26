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
ChangeType fromDocumentChange(DocumentChangeType type) {
  switch (type) {
    case DocumentChangeType.added:
      return ChangeType.added;
    case DocumentChangeType.modified:
      return ChangeType.modified;
    case DocumentChangeType.removed:
      return ChangeType.removed;
  }
  return null;
}

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

  void close() {
    if (_isInitiated) {
      _listener.cancel();
    }
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

class DataCombinedPackage<T> {
  List<StreamController<Map<String, T>>> _listStreamController;
  List<StreamController<Map<String, T>>> _listStreamControllerOnce;
  final GetKey<T> getKey;
  DataCombinedPackage({@required this.getKey}) {
    _listStreamController = [];
    _listStreamControllerOnce = [];
    data = {};
  }

  Map<String, T> data;

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception("Missing Implementation for getKey");
    } else
      return getItemFilteredStream((item) => getKey(item) == id);
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream.map((data) {
      Iterable<T> iterable = data?.values?.where(filter);
      if ((iterable?.length ?? 0) > 0)
        return iterable.first;
      else
        return null;
    });
  }

  Stream<Map<String, T>> get stream {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _listStreamController.add(newcontroller);
    newcontroller.add(data);
    newcontroller.onCancel = () {
      _listStreamController.remove(newcontroller);
    };
    return newcontroller.stream;
  }

  Future<Map<String, T>> get once {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _listStreamControllerOnce.add(newcontroller);
    return newcontroller.stream.first;
  }

  T getItem(String key) {
    return data[key];
  }

  void close() {}

  void updateData(T item, ChangeType type) {
    switch (type) {
      case ChangeType.added:
        {
          if (item != null) {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
          }
          break;
        }
      case ChangeType.modified:
        {
          if (item != null) {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
          }
          break;
        }
      case ChangeType.removed:
        {
          if (item != null) {
            String key = getKey(item);
            data.remove(key);
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
          }
          break;
        }
    }
  }

  void removeWhere(ItemFilter<T> filter) {
    data.removeWhere((key, item) => filter(item));
    for (StreamController<Map<String, T>> controller in _listStreamController)
      controller.add(data);
    for (StreamController<Map<String, T>> controller
        in _listStreamControllerOnce) controller.add(data);
    _listStreamControllerOnce.clear();
  }
}

class DataCombinedPackageSpecial<T, T2> {
  List<StreamController<Map<String, T>>> _listStreamController;
  List<StreamController<Map<String, T>>> _listStreamControllerOnce;
  final GetKey<T> getKey;
  final GetKey<T2> getKeySecondary;
  final DataCreator<T, T2> dataCreator;
  DataCombinedPackageSpecial(
      {@required this.getKey,
      @required this.getKeySecondary,
      @required this.dataCreator}) {
    _listStreamController = [];
    _listStreamControllerOnce = [];
    data = {};
    secondaryData = {};
  }

  Map<String, T> data;
  Map<String, T2> secondaryData;

  Stream<T> getItemStream(String id) {
    if (getKey == null) {
      throw Exception("Missing Implementation for getKey");
    } else
      return getItemFilteredStream((item) => getKey(item) == id);
  }

  Stream<T> getItemFilteredStream(ItemFilter<T> filter) {
    StreamController<Map<String, T>> newController = StreamController();
    _listStreamController.add(newController);
    newController.add(data);
    newController.onCancel = () {
      _listStreamController.remove(newController);
    };
    return newController.stream.map((data) => data?.values?.firstWhere(filter));
  }

  Stream<Map<String, T>> get stream {
    StreamController<Map<String, T>> newController = StreamController();
    _listStreamController.add(newController);
    newController.add(data);
    newController.onCancel = () {
      _listStreamController.remove(newController);
    };
    return newController.stream;
  }

  Future<Map<String, T>> get once {
    StreamController<Map<String, T>> newcontroller = StreamController();
    _listStreamControllerOnce.add(newcontroller);
    return newcontroller.stream.first;
  }

  void close() {}

  void notifyDataSetChanged() {
    for (StreamController<Map<String, T>> controller in _listStreamController)
      controller.add(data);
  }

  void updateData(T preItem, ChangeType type) {
    if (preItem != null) {
      T item = dataCreator(preItem, secondaryData[getKey(preItem)]);
      switch (type) {
        case ChangeType.added:
          {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
            break;
          }
        case ChangeType.modified:
          {
            String key = getKey(item);
            data[key] = item;
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
            break;
          }
        case ChangeType.removed:
          {
            String key = getKey(item);
            data.remove(key);
            for (StreamController<Map<String, T>> controller
                in _listStreamController) controller.add(data);
            for (StreamController<Map<String, T>> controller
                in _listStreamControllerOnce) controller.add(data);
            _listStreamControllerOnce.clear();
            break;
          }
      }
    }
  }

  void updateDataSecondary(T2 itemSecondary, ChangeType type) {
    switch (type) {
      case ChangeType.added:
        {
          if (itemSecondary != null) {
            String key = getKeySecondary(itemSecondary);
            secondaryData[key] = itemSecondary;
          }
          break;
        }
      case ChangeType.modified:
        {
          if (itemSecondary != null) {
            String key = getKeySecondary(itemSecondary);
            secondaryData[key] = itemSecondary;
          }
          break;
        }
      case ChangeType.removed:
        {
          if (itemSecondary != null) {
            String key = getKeySecondary(itemSecondary);
            secondaryData.remove(key);
          }
          break;
        }
    }
    if (itemSecondary != null) {
      String key = getKeySecondary(itemSecondary);
      T newdata = dataCreator(data[key], secondaryData[key]);
      if (newdata != null) {
        data[key] = newdata;
      }
      for (StreamController<Map<String, T>> controller in _listStreamController)
        controller.add(data);
      for (StreamController<Map<String, T>> controller
          in _listStreamControllerOnce) controller.add(data);
      _listStreamControllerOnce.clear();
    }
  }

  void removeWhere(ItemFilter<T> filter) {
    data.removeWhere((key, item) => filter(item));
    for (StreamController<Map<String, T>> controller in _listStreamController)
      controller.add(data);
    for (StreamController<Map<String, T>> controller
        in _listStreamControllerOnce) controller.add(data);
    _listStreamControllerOnce.clear();
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

  void close() {
    if (_isInitiated) {
      _listener.cancel();
    }
  }

  void unlock({Query newReference}) {
    _isLocked = false;
    if (newReference != null) reference = newReference;
    if (_listStreamController.isNotEmpty) if (_isInitiated == false)
      _initiate();
  }
}
