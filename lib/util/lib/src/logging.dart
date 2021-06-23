import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

void printLogRecord(LogRecord log, {void Function(String) printMethod}) {
  String msg = "[${log.level}] ${log.loggerName} ${log.message}\n";
  if (log.error != null) {
    msg += "Error: ${log.error}\n";
  }
  if (log.stackTrace != null) {
    msg += "Stacktrace: ${log.stackTrace}\n";
  }
  printMethod != null ? printMethod(msg) : print(msg);
}

class SlackLogPublisher {
  final String webhookUrl;

  /// E.g. "#ci-cd"
  final String slackChannelName;

  final Level logLevelToSend;

  final Logger logger;

  SlackLogPublisher(this.webhookUrl, this.slackChannelName, this.logLevelToSend,
      this.logger) {
    tryPublishLogs(logger.onRecord);
  }

  void tryPublishLogs(Stream<LogRecord> logs) {
    logs?.listen((log) {
      if (log.level >= logLevelToSend) {
        tryPublishLog(log);
      }
    });
  }

  Future<void> tryPublishLog(LogRecord log) async {
    try {
      await _publishLog(log);
    } catch (e, s) {
      print("Could not publish log $log to Slack: $e");
      print("$s");
    }
  }

  Future _publishLog(LogRecord log) async {
    final other =
        "${log.time} - ${log.sequenceNumber}: Error: ${log.error} Stacktrace: ${log.stackTrace}";
    var msg = "${log.level.name}: ${log.message}. \n $other";
    final payload = {
      "text": msg,
      "username": log.loggerName,
      "channel": slackChannelName,
    };
    final res = await http.post(webhookUrl,
        body: jsonEncode(payload),
        headers: {"Content-Type": "application/json"});
    logger
        .fine("Slack response: [${res.statusCode}] ${res.body} ${res.headers}");
  }
}
