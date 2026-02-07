// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SharezonePlusAdvantages extends StatelessWidget {
  const SharezonePlusAdvantages({
    super.key,
    required this.isHomeworkReminderFeatureVisible,
    this.isRemoveAdsFeatureVisible = false,
    this.onOpenedAdvantage,
    this.onGitHubOpen,
  });

  final bool isHomeworkReminderFeatureVisible;
  final bool isRemoveAdsFeatureVisible;
  final ValueChanged<String>? onOpenedAdvantage;
  final VoidCallback? onGitHubOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isRemoveAdsFeatureVisible) _RemoveAds(onOpen: onOpenedAdvantage),
        _Grades(onOpen: onOpenedAdvantage),
        _MoreColors(onOpen: onOpenedAdvantage),
        _QuickHomeworkDueDate(onOpen: onOpenedAdvantage),
        if (isHomeworkReminderFeatureVisible)
          _HomeworkReminder(onOpen: onOpenedAdvantage),
        _Substitutions(onOpen: onOpenedAdvantage),
        _TeachersTimetable(onOpen: onOpenedAdvantage),
        _PastEvents(onOpen: onOpenedAdvantage),
        _AddEventsToLocalCalendar(onOpen: onOpenedAdvantage),
        _IcalFeature(onOpen: onOpenedAdvantage),
        _ReadByInformationSheets(onOpen: onOpenedAdvantage),
        _SelectTimetableBySchoolClass(onOpen: onOpenedAdvantage),
        _MoreStorage(onOpen: onOpenedAdvantage),
        _PlusSupport(onOpen: onOpenedAdvantage),
        _DiscordPlusRang(onOpen: onOpenedAdvantage),
        _SupportOpenSource(
          onOpen: onOpenedAdvantage,
          onGitHubOpen: onGitHubOpen,
        ),
      ],
    );
  }
}

class _RemoveAds extends StatelessWidget {
  const _RemoveAds({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('remove_ads');
      },
      icon: const Icon(Icons.block),
      title: Text(context.l10n.sharezonePlusAdvantageRemoveAdsTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageRemoveAdsDescription,
      ),
    );
  }
}

class _Grades extends StatelessWidget {
  const _Grades({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('grades');
      },
      icon: const Icon(Icons.emoji_events),
      title: Text(context.l10n.sharezonePlusAdvantageGradesTitle),
      description: Text(context.l10n.sharezonePlusAdvantageGradesDescription),
    );
  }
}

class _MoreColors extends StatelessWidget {
  const _MoreColors({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('more_colors');
      },
      icon: const Icon(Icons.color_lens),
      title: Text(context.l10n.sharezonePlusAdvantageMoreColorsTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageMoreColorsDescription,
      ),
    );
  }
}

class _SelectTimetableBySchoolClass extends StatelessWidget {
  const _SelectTimetableBySchoolClass({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('select_timetable_by_school_class');
      },
      icon: const Icon(Icons.calendar_month),
      title: Text(context.l10n.sharezonePlusAdvantageTimetableByClassTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageTimetableByClassDescription,
      ),
    );
  }
}

class _Substitutions extends StatelessWidget {
  const _Substitutions({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('substitutions');
      },
      icon: const Icon(Icons.cancel),
      title: Text(context.l10n.sharezonePlusAdvantageSubstitutionsTitle),
      description: MarkdownBody(
        data: context.l10n.sharezonePlusAdvantageSubstitutionsDescription,
      ),
    );
  }
}

class _TeachersTimetable extends StatelessWidget {
  const _TeachersTimetable({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('teachers_timetable');
      },
      icon: const Icon(Icons.person),
      title: Text(context.l10n.sharezonePlusAdvantageTeacherTimetableTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageTeacherTimetableDescription,
      ),
    );
  }
}

class _PastEvents extends StatelessWidget {
  const _PastEvents({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('past_events');
      },
      icon: const Icon(Icons.history),
      title: Text(context.l10n.sharezonePlusAdvantagePastEventsTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantagePastEventsDescription,
      ),
    );
  }
}

class _AddEventsToLocalCalendar extends StatelessWidget {
  const _AddEventsToLocalCalendar({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('add_events_to_calendar');
      },
      icon: const Icon(Icons.calendar_today),
      title: Text(context.l10n.sharezonePlusAdvantageAddToCalendarTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageAddToCalendarDescription,
      ),
    );
  }
}

class _IcalFeature extends StatelessWidget {
  const _IcalFeature({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('ical_links');
      },
      icon: const Icon(Icons.link),
      title: Text(context.l10n.sharezonePlusAdvantageIcalTitle),
      description: Text(context.l10n.sharezonePlusAdvantageIcalDescription),
    );
  }
}

class _MoreStorage extends StatelessWidget {
  const _MoreStorage({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('more_storage');
      },
      icon: const Icon(Icons.storage),
      title: Text(context.l10n.sharezonePlusAdvantageStorageTitle),
      description: Text(context.l10n.sharezonePlusAdvantageStorageDescription),
    );
  }
}

class _PlusSupport extends StatelessWidget {
  const _PlusSupport({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('support');
      },
      icon: const Icon(Icons.support_agent),
      title: Text(context.l10n.sharezonePlusAdvantagePremiumSupportTitle),
      description: MarkdownBody(
        data: context.l10n.sharezonePlusAdvantagePremiumSupportDescription,
      ),
    );
  }
}

class _HomeworkReminder extends StatelessWidget {
  const _HomeworkReminder({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('homework_reminder');
      },
      icon: const Icon(Icons.notifications),
      title: Text(context.l10n.sharezonePlusAdvantageHomeworkReminderTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageHomeworkReminderDescription,
      ),
    );
  }
}

class _ReadByInformationSheets extends StatelessWidget {
  const _ReadByInformationSheets({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('read_by_information_sheets');
      },
      icon: const Icon(Icons.format_list_bulleted),
      title: Text(context.l10n.sharezonePlusAdvantageReadByTitle),
      description: Text(context.l10n.sharezonePlusAdvantageReadByDescription),
    );
  }
}

class _DiscordPlusRang extends StatelessWidget {
  const _DiscordPlusRang({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('discord_plus_rang');
      },
      icon: const Icon(Icons.discord),
      title: Text(context.l10n.sharezonePlusAdvantageDiscordTitle),
      description: MarkdownBody(
        data: context.l10n.sharezonePlusAdvantageDiscordDescription,
        styleSheet: MarkdownStyleSheet(
          a: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;
          await launchUrl(Uri.parse(href));
        },
      ),
    );
  }
}

class _SupportOpenSource extends StatelessWidget {
  const _SupportOpenSource({required this.onOpen, required this.onGitHubOpen});

  final ValueChanged<String>? onOpen;
  final VoidCallback? onGitHubOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('open_source');
      },
      icon: const Icon(Icons.favorite),
      title: Text(context.l10n.sharezonePlusAdvantageOpenSourceTitle),
      description: MarkdownBody(
        data: context.l10n.sharezonePlusAdvantageOpenSourceDescription,
        styleSheet: MarkdownStyleSheet(
          a: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
        onTapLink: (text, href, title) async {
          if (href == null) return;
          if (onGitHubOpen != null) {
            onGitHubOpen!();
          }
          await launchUrl(Uri.parse(href));
        },
      ),
    );
  }
}

class _QuickHomeworkDueDate extends StatelessWidget {
  const _QuickHomeworkDueDate({required this.onOpen});

  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    return _AdvantageTile(
      onOpen: () {
        if (onOpen != null) onOpen!('smart_homework_due_date');
      },
      icon: const Icon(Icons.check_box),
      title: Text(context.l10n.sharezonePlusAdvantageQuickDueDateTitle),
      description: Text(
        context.l10n.sharezonePlusAdvantageQuickDueDateDescription,
      ),
    );
  }
}

class _AdvantageTile extends StatelessWidget {
  const _AdvantageTile({
    required this.icon,
    required this.title,
    // Can be removed when the subtitle is used.
    //
    // ignore: unused_element_parameter
    this.subtitle,
    required this.description,
    required this.onOpen,
  });

  final Icon icon;
  final Widget title;
  final Widget? subtitle;
  final Widget description;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF6FCF97);
    return ExpansionCard(
      onOpen: onOpen,
      header: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconTheme(
                data: const IconThemeData(color: green),
                child: icon,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (subtitle != null)
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    child: subtitle!,
                  ),
              ],
            ),
          ),
        ],
      ),
      body: description,
      backgroundColor: Colors.transparent,
    );
  }
}
