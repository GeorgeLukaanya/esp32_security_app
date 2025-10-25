import 'package:flutter/foundation.dart';
import '../utils/storage_service.dart';

class AlertStats {
  final int total;
  final int fireAlerts;
  final int magnetAlerts;
  final String? peakHour;
  final double averageGapMinutes;
  final double trendPercentage; // positive = increasing, negative = decreasing
  final String riskLevel; // "LOW", "MEDIUM", "HIGH"

  AlertStats({
    required this.total,
    required this.fireAlerts,
    required this.magnetAlerts,
    required this.peakHour,
    required this.averageGapMinutes,
    required this.trendPercentage,
    required this.riskLevel,
  });
}

class HourlyData {
  final int hour;
  final int count;
  final int fireCount;
  final int magnetCount;

  HourlyData({
    required this.hour,
    required this.count,
    required this.fireCount,
    required this.magnetCount,
  });
}

class AnalyticsService {
  /// Get statistics for a specific date
  static Future<AlertStats> getStatisticsForDate(DateTime date) async {
    try {
      final logs = await StorageService.getLogsForDate(date);

      if (logs.isEmpty) {
        return AlertStats(
          total: 0,
          fireAlerts: 0,
          magnetAlerts: 0,
          peakHour: null,
          averageGapMinutes: 0,
          trendPercentage: 0,
          riskLevel: 'LOW',
        );
      }

      final fireCount = logs.where((l) => l.alertType == 'FIRE').length;
      final magnetCount = logs.where((l) => l.alertType == 'MAGNET').length;

      // Calculate peak hour
      final peakHour = _calculatePeakHour(logs);

      // Calculate average gap between alerts
      final averageGap = _calculateAverageGap(logs);

      // Calculate trend (compare with previous day)
      final trend = await _calculateTrend(date, logs.length);

      // Determine risk level based on count and type
      final riskLevel = _calculateRiskLevel(logs.length, fireCount);

      return AlertStats(
        total: logs.length,
        fireAlerts: fireCount,
        magnetAlerts: magnetCount,
        peakHour: peakHour,
        averageGapMinutes: averageGap,
        trendPercentage: trend,
        riskLevel: riskLevel,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating statistics: $e');
      }
      return AlertStats(
        total: 0,
        fireAlerts: 0,
        magnetAlerts: 0,
        peakHour: null,
        averageGapMinutes: 0,
        trendPercentage: 0,
        riskLevel: 'LOW',
      );
    }
  }

  /// Get hourly breakdown for timeline graph
  static Future<List<HourlyData>> getHourlyBreakdown(DateTime date) async {
    try {
      final logs = await StorageService.getLogsForDate(date);

      // Create 24-hour buckets
      final hourlyData = List<HourlyData>.generate(24, (hour) {
        final hourLogs = logs.where((log) {
          final logHour = _parseHour(log.timestamp);
          return logHour == hour;
        }).toList();

        return HourlyData(
          hour: hour,
          count: hourLogs.length,
          fireCount: hourLogs.where((l) => l.alertType == 'FIRE').length,
          magnetCount: hourLogs.where((l) => l.alertType == 'MAGNET').length,
        );
      });

      return hourlyData;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating hourly breakdown: $e');
      }
      return [];
    }
  }

  /// Get statistics for this week
  static Future<AlertStats> getStatisticsForWeek() async {
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final logs = await StorageService.getLogsForDateRange(weekStart, now);

      if (logs.isEmpty) {
        return AlertStats(
          total: 0,
          fireAlerts: 0,
          magnetAlerts: 0,
          peakHour: null,
          averageGapMinutes: 0,
          trendPercentage: 0,
          riskLevel: 'LOW',
        );
      }

      final fireCount = logs.where((l) => l.alertType == 'FIRE').length;
      final magnetCount = logs.where((l) => l.alertType == 'MAGNET').length;
      final peakHour = _calculatePeakHour(logs);
      final averageGap = _calculateAverageGap(logs);
      final riskLevel = _calculateRiskLevel(logs.length, fireCount);

      return AlertStats(
        total: logs.length,
        fireAlerts: fireCount,
        magnetAlerts: magnetCount,
        peakHour: peakHour,
        averageGapMinutes: averageGap,
        trendPercentage: 0, // Not calculated for week view
        riskLevel: riskLevel,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating weekly statistics: $e');
      }
      return AlertStats(
        total: 0,
        fireAlerts: 0,
        magnetAlerts: 0,
        peakHour: null,
        averageGapMinutes: 0,
        trendPercentage: 0,
        riskLevel: 'LOW',
      );
    }
  }

  /// Get statistics for this month
  static Future<AlertStats> getStatisticsForMonth() async {
    try {
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final logs = await StorageService.getLogsForDateRange(monthStart, now);

      if (logs.isEmpty) {
        return AlertStats(
          total: 0,
          fireAlerts: 0,
          magnetAlerts: 0,
          peakHour: null,
          averageGapMinutes: 0,
          trendPercentage: 0,
          riskLevel: 'LOW',
        );
      }

      final fireCount = logs.where((l) => l.alertType == 'FIRE').length;
      final magnetCount = logs.where((l) => l.alertType == 'MAGNET').length;
      final peakHour = _calculatePeakHour(logs);
      final averageGap = _calculateAverageGap(logs);
      final riskLevel = _calculateRiskLevel(logs.length, fireCount);

      return AlertStats(
        total: logs.length,
        fireAlerts: fireCount,
        magnetAlerts: magnetCount,
        peakHour: peakHour,
        averageGapMinutes: averageGap,
        trendPercentage: 0,
        riskLevel: riskLevel,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating monthly statistics: $e');
      }
      return AlertStats(
        total: 0,
        fireAlerts: 0,
        magnetAlerts: 0,
        peakHour: null,
        averageGapMinutes: 0,
        trendPercentage: 0,
        riskLevel: 'LOW',
      );
    }
  }

  // ============ PRIVATE HELPER METHODS ============

  /// Find peak alert hour from logs
  static String? _calculatePeakHour(List<EmergencyLog> logs) {
    if (logs.isEmpty) return null;

    final hourCounts = <int, int>{};
    for (var log in logs) {
      final hour = _parseHour(log.timestamp);
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    final peakHour = hourCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    return '${peakHour.toString().padLeft(2, '0')}:00';
  }

  /// Calculate average minutes between alerts
  static double _calculateAverageGap(List<EmergencyLog> logs) {
    if (logs.length < 2) return 0;

    // Sort by timestamp
    final sorted = List<EmergencyLog>.from(logs);
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Calculate gaps
    double totalGapMinutes = 0;
    for (int i = 1; i < sorted.length; i++) {
      final time1 = DateTime.parse(sorted[i - 1].timestamp);
      final time2 = DateTime.parse(sorted[i].timestamp);
      final gap = time2.difference(time1).inMinutes;
      totalGapMinutes += gap;
    }

    return totalGapMinutes / (sorted.length - 1);
  }

  /// Calculate trend: percentage change from previous day
  static Future<double> _calculateTrend(DateTime date, int todayCount) async {
    try {
      final previousDay = date.subtract(const Duration(days: 1));
      final previousLogs = await StorageService.getLogsForDate(previousDay);

      if (previousLogs.isEmpty) return 0;

      final previousCount = previousLogs.length;
      final change = ((todayCount - previousCount) / previousCount) * 100;
      return change;
    } catch (e) {
      return 0;
    }
  }

  /// Determine risk level based on alert count and fire alert ratio
  static String _calculateRiskLevel(int totalAlerts, int fireAlerts) {
    // High risk: Many fire alerts OR many total alerts
    if (fireAlerts > 5 || totalAlerts > 20) {
      return 'HIGH';
    }

    // Medium risk: Some fire alerts OR moderate total
    if (fireAlerts > 2 || totalAlerts > 10) {
      return 'MEDIUM';
    }

    // Low risk: Few or no alerts
    return 'LOW';
  }

  /// Parse hour from timestamp string (expects "yyyy-MM-dd HH:mm:ss")
  static int _parseHour(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return dateTime.hour;
    } catch (e) {
      return 0;
    }
  }
}
