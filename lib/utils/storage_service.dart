import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class EmergencyLog {
  final String timestamp;
  final String alertType; // "FIRE" or "MAGNET"
  final String description;
  final Map<String, dynamic> sensorData;

  EmergencyLog({
    required this.timestamp,
    required this.alertType,
    required this.description,
    required this.sensorData,
  });

  factory EmergencyLog.fromJson(Map<String, dynamic> json) {
    return EmergencyLog(
      timestamp: json['timestamp'] as String,
      alertType: json['alertType'] as String,
      description: json['description'] as String,
      sensorData: Map<String, dynamic>.from(json['sensorData'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'alertType': alertType,
      'description': description,
      'sensorData': sensorData,
    };
  }

  @override
  String toString() {
    return '$alertType - $description at $timestamp';
  }
}

class StorageService {
  static const String _logsFileName = 'emergency_logs.json';

  /// Get the file path for emergency logs
  static Future<File> _getLogsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_logsFileName');
  }

  /// Save a new emergency log
  static Future<void> saveEmergencyLog(EmergencyLog log) async {
    try {
      final file = await _getLogsFile();
      List<EmergencyLog> logs = await getAllLogs();

      // Add new log
      logs.add(log);

      // Write to file
      await file.writeAsString(
        jsonEncode(logs.map((log) => log.toJson()).toList()),
      );

      if (kDebugMode) {
        debugPrint('Emergency log saved: $log');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error saving emergency log: $e');
      }
    }
  }

  /// Get all emergency logs
  static Future<List<EmergencyLog>> getAllLogs() async {
    try {
      final file = await _getLogsFile();

      if (!file.existsSync()) {
        return [];
      }

      final content = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);

      return jsonData
          .map((item) => EmergencyLog.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error reading emergency logs: $e');
      }
      return [];
    }
  }

  /// Clear all emergency logs
  static Future<void> clearAllLogs() async {
    try {
      final file = await _getLogsFile();

      if (file.existsSync()) {
        await file.delete();
      }

      if (kDebugMode) {
        debugPrint('All emergency logs cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing emergency logs: $e');
      }
    }
  }

  /// Get number of logs
  static Future<int> getLogCount() async {
    final logs = await getAllLogs();
    return logs.length;
  }

  /// Export logs as JSON string
  static Future<String> exportLogsAsJson() async {
    final logs = await getAllLogs();
    return jsonEncode(logs.map((log) => log.toJson()).toList());
  }

  /// Get logs sorted by timestamp (newest first)
  static Future<List<EmergencyLog>> getLogsSorted() async {
    final logs = await getAllLogs();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  /// Get fire alerts only
  static Future<List<EmergencyLog>> getFireAlerts() async {
    final logs = await getAllLogs();
    return logs.where((log) => log.alertType == 'FIRE').toList();
  }

  /// Get magnetic field alerts only
  static Future<List<EmergencyLog>> getMagnetAlerts() async {
    final logs = await getAllLogs();
    return logs.where((log) => log.alertType == 'MAGNET').toList();
  }

  /// Get logs for a specific date
  static Future<List<EmergencyLog>> getLogsForDate(DateTime date) async {
    final logs = await getAllLogs();
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return logs.where((log) => log.timestamp.startsWith(dateString)).toList();
  }

  /// Get logs within a date range (inclusive)
  static Future<List<EmergencyLog>> getLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final logs = await getAllLogs();
    final adjustedEndDate = endDate.add(const Duration(days: 1));
    return logs.where((log) {
      try {
        final logDate = DateTime.parse(log.timestamp);
        return logDate.isAfter(startDate) && logDate.isBefore(adjustedEndDate);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Get logs for today
  static Future<List<EmergencyLog>> getLogsForToday() async {
    return getLogsForDate(DateTime.now());
  }

  /// Get logs for this week (Monday to Sunday)
  static Future<List<EmergencyLog>> getLogsForThisWeek() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return getLogsForDateRange(weekStart, now);
  }

  /// Get logs for this month
  static Future<List<EmergencyLog>> getLogsForThisMonth() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return getLogsForDateRange(monthStart, now);
  }

  /// Get daily alert counts for the last N days
  static Future<Map<String, int>> getDailyAlertCounts(int days) async {
    final logs = await getAllLogs();
    final counts = <String, int>{};

    // Initialize all days with 0
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      counts[dateString] = 0;
    }

    // Count alerts per day
    for (var log in logs) {
      final dateString = log.timestamp.substring(0, 10);
      if (counts.containsKey(dateString)) {
        counts[dateString] = (counts[dateString] ?? 0) + 1;
      }
    }

    return counts;
  }
}
