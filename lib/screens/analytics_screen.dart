import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'Today'; // Today, Week, Month
  late Future<AlertStats> _statsFuture;
  late Future<List<HourlyData>> _hourlyFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      if (_selectedPeriod == 'Today') {
        _statsFuture = AnalyticsService.getStatisticsForDate(DateTime.now());
        _hourlyFuture = AnalyticsService.getHourlyBreakdown(DateTime.now());
      } else if (_selectedPeriod == 'Week') {
        _statsFuture = AnalyticsService.getStatisticsForWeek();
        // For week view, we'll show daily data instead of hourly
        _hourlyFuture = Future.value([]);
      } else {
        _statsFuture = AnalyticsService.getStatisticsForMonth();
        _hourlyFuture = Future.value([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Analytics & Insights'),
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period Selector
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: ['Today', 'Week', 'Month'].map((period) {
                final isSelected = _selectedPeriod == period;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _selectedPeriod = period);
                        _loadData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepOrangeAccent
                            : Colors.grey[300],
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(period),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Statistics Dashboard
          FutureBuilder<AlertStats>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final stats = snapshot.data;
              if (stats == null) {
                return const Text('Error loading statistics');
              }

              return Column(
                children: [
                  // Risk Level Card
                  _buildRiskLevelCard(stats),
                  const SizedBox(height: 16),

                  // Statistics Grid
                  _buildStatisticsGrid(stats),
                  const SizedBox(height: 24),

                  // Detailed Metrics
                  _buildDetailedMetrics(stats),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),

          // Timeline Graph (only for Today)
          if (_selectedPeriod == 'Today') ...[
            Text(
              '📈 Alert Timeline (Hourly)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<HourlyData>>(
              future: _hourlyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final hourlyData = snapshot.data ?? [];
                if (hourlyData.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No data available',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 2,
                            verticalInterval: 2,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300],
                                strokeWidth: 0.5,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300],
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 2,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}:00',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            // Fire alerts line
                            LineChartBarData(
                              spots: hourlyData
                                  .map(
                                    (data) => FlSpot(
                                      data.hour.toDouble(),
                                      data.fireCount.toDouble(),
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: Colors.redAccent,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.redAccent.withValues(alpha: 0.1),
                              ),
                            ),
                            // Magnetic alerts line
                            LineChartBarData(
                              spots: hourlyData
                                  .map(
                                    (data) => FlSpot(
                                      data.hour.toDouble(),
                                      data.magnetCount.toDouble(),
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: Colors.blueAccent,
                              barWidth: 2,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blueAccent.withValues(alpha: 0.1),
                              ),
                            ),
                          ],
                          minX: 0,
                          maxX: 23,
                          minY: 0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Timeline Legend
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🔥 Fire Alerts'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🧲 Magnetic Alerts'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRiskLevelCard(AlertStats stats) {
    final riskColor = stats.riskLevel == 'HIGH'
        ? Colors.redAccent
        : stats.riskLevel == 'MEDIUM'
        ? Colors.orangeAccent
        : Colors.greenAccent;

    final riskIcon = stats.riskLevel == 'HIGH'
        ? '🔴'
        : stats.riskLevel == 'MEDIUM'
        ? '🟡'
        : '🟢';

    return Card(
      color: riskColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Risk Level',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$riskIcon ${stats.riskLevel}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getRiskDescription(stats),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(AlertStats stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        stats.total.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Alerts',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        stats.fireAlerts.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🔥 Fire',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        stats.magnetAlerts.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🧲 Magnetic',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedMetrics(AlertStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Metrics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _metricRow(
              icon: '⏰',
              label: 'Peak Alert Time',
              value: stats.peakHour ?? 'N/A',
            ),
            const Divider(),
            _metricRow(
              icon: '📊',
              label: 'Average Gap',
              value: stats.averageGapMinutes > 0
                  ? '${stats.averageGapMinutes.toStringAsFixed(1)} min'
                  : 'N/A',
            ),
            const Divider(),
            _metricRow(
              icon: '📈',
              label: 'Trend (vs previous day)',
              value: stats.trendPercentage != 0
                  ? '${stats.trendPercentage > 0 ? '+' : ''}${stats.trendPercentage.toStringAsFixed(1)}%'
                  : 'N/A',
              valueColor: stats.trendPercentage > 0
                  ? Colors.orangeAccent
                  : Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricRow({
    required String icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(label),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  String _getRiskDescription(AlertStats stats) {
    if (stats.total == 0) {
      return 'No alerts detected - system is operating normally.';
    }
    if (stats.riskLevel == 'HIGH') {
      return 'High number of alerts detected. Immediate investigation recommended.';
    } else if (stats.riskLevel == 'MEDIUM') {
      return 'Moderate alert activity detected. Review system status.';
    }
    return 'Few alerts detected - system is stable.';
  }
}
