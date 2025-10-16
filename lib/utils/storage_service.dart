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
}
