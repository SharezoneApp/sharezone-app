// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({super.key});

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  var _items = <Map<String, dynamic>>[];
  var _isLoading = false;
  var _hasReachedMax = false;

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    log('Fetching data...');

    // Load 10 more feedbacks from Firestore
    Query<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection('Feedback')
        .orderBy('createdOn', descending: true)
        .limit(20);

    if (_items.isNotEmpty) {
      query = query.startAfter([
        _items.last['createdOn'] as Timestamp,
      ]);
    }

    final snapshot = await query.get();

    if (!mounted) {
      return;
    }

    if (snapshot.docs.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasReachedMax = true;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _items = [
        ..._items,
        ...snapshot.docs.map((doc) => doc.data()).toList(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks'),
      ),
      body: InfiniteList(
        itemCount: _items.length,
        isLoading: _isLoading,
        onFetchData: _fetchData,
        hasReachedMax: _hasReachedMax,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            title: Text(_items[index].toString()),
          );
        },
      ),
    );
  }
}
