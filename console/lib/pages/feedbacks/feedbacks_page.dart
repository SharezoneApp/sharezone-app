// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

/// The user ID of the support team.
///
/// We use a shared user ID so that multiple Sharezone members can work on the
/// feedbacks. For example the status of unread messages is grouped by user ID.
/// This way, all members of the support team see the same unread messages.
final supportTeamUserId = UserId('support-team');

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({super.key});

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  var _items = <FeedbackView>[];
  DateTime? _lastCreatedAt;
  var _isLoading = false;
  var _hasReachedMax = false;
  final queryLimit = 10;
  var _selectedFilter = SupportFeedbackFilter.all;

  Future<void> _fetchData() async {
    if (_isLoading || _hasReachedMax) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final api = context.read<FeedbackApi>();
    final filter = _selectedFilter;
    final newFeedbacks = await api.getFeedbacksForSupportTeam(
      startAfter: _lastCreatedAt,
      limit: queryLimit,
      filter: filter,
    );

    if (!mounted) {
      return;
    }

    if (filter != _selectedFilter) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final hasReachedMax = newFeedbacks.length < queryLimit;

    setState(() {
      _isLoading = false;
      _hasReachedMax = hasReachedMax;
      if (newFeedbacks.isNotEmpty) {
        _lastCreatedAt = newFeedbacks.last.createdOn;
        _items = [
          ..._items,
          ...newFeedbacks.map(
            (f) => FeedbackView.fromUserFeedback(f, supportTeamUserId),
          ),
        ];
      } else if (_items.isEmpty) {
        _lastCreatedAt = null;
      }
    });
  }

  void _onFilterChanged(SupportFeedbackFilter filter) {
    if (filter == _selectedFilter) {
      return;
    }

    setState(() {
      _selectedFilter = filter;
      _items = [];
      _lastCreatedAt = null;
      _hasReachedMax = false;
      _isLoading = false;
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedbacks')),
      body: Column(
        children: [
          _FeedbackFilterBar(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
          const Divider(height: 1),
          Expanded(
            child: InfiniteList(
              itemCount: _items.length,
              isLoading: _isLoading,
              onFetchData: _fetchData,
              hasReachedMax: _hasReachedMax,
              loadingBuilder: (context) => const _Loading(),
              errorBuilder: (context) => const _Error(),
              emptyBuilder: (context) => const _Empty(),
              itemBuilder: (context, index) {
                final feedback = _items[index];
                return FeedbackCard(
                  view: feedback,
                  isLoading: false,
                  pushDetailsPage: (feedbackId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FeedbackDetailsPage(
                              feedbackId: feedbackId,
                              onContactSupportPressed: null,
                              showDeviceInformation: true,
                            ),
                        settings: const RouteSettings(
                          name: FeedbackDetailsPage.tag,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackFilterBar extends StatelessWidget {
  const _FeedbackFilterBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final SupportFeedbackFilter selectedFilter;
  final ValueChanged<SupportFeedbackFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children:
            SupportFeedbackFilter.values.map((filter) {
              final isSelected = filter == selectedFilter;
              return ChoiceChip(
                label: _FeedbackFilterChipLabel(
                  filter: filter,
                  isSelected: isSelected,
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onFilterChanged(filter);
                  }
                },
              );
            }).toList(),
      ),
    );
  }
}

class _FeedbackFilterChipLabel extends StatelessWidget {
  const _FeedbackFilterChipLabel({
    required this.filter,
    required this.isSelected,
  });

  final SupportFeedbackFilter filter;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(filter.icon, size: 18, color: isSelected ? Colors.white : null),
        const SizedBox(width: 8),
        Text(filter.label),
      ],
    );
  }
}

extension SupportFeedbackFilterX on SupportFeedbackFilter {
  String get label {
    return switch (this) {
      SupportFeedbackFilter.all => 'All feedbacks',
      SupportFeedbackFilter.unreadMessages => 'Unread comments',
      SupportFeedbackFilter.noMessages => 'No comments yet',
    };
  }

  IconData get icon {
    return switch (this) {
      SupportFeedbackFilter.all => Icons.forum_outlined,
      SupportFeedbackFilter.unreadMessages => Icons.mark_chat_unread_outlined,
      SupportFeedbackFilter.noMessages => Icons.mark_chat_read_outlined,
    };
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return ErrorCard(message: Text('Error loading feedbacks :('));
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return FeedbackCard(
      view: FeedbackView(
        id: FeedbackId('1'),
        createdOn: '2022-01-01',
        rating: '5',
        likes: '10',
        dislikes: '2',
        missing: 'Great app!',
        heardFrom: 'Friend',
        hasUnreadMessages: false,
        lastMessage: null,
      ),
      pushDetailsPage: null,
      isLoading: true,
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: const Center(child: Text('No feedbacks found')),
    );
  }
}
