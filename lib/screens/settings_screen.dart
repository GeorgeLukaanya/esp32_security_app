import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/storage_service.dart';
import '../utils/theme_provider.dart';
import 'analytics_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<List<EmergencyLog>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = StorageService.getLogsSorted();
  }

  void _refreshLogs() {
    setState(() {
      _logsFuture = StorageService.getLogsSorted();
    });
  }

  void _clearLogs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🗑️ Clear Emergency Logs?'),
        content: const Text(
          'This will permanently delete all emergency logs. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearAllLogs();
              _refreshLogs();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Emergency logs cleared')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _exportLogs(BuildContext context) async {
    try {
      final jsonData = await StorageService.exportLogsAsJson();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Logs exported (check console for data)'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Copy',
              onPressed: () {
                // In a real app, you'd copy to clipboard
              },
            ),
          ),
        );
      }
      debugPrint('Exported Logs:\n$jsonData');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error exporting logs: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section - Made more prominent
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            context.watch<ThemeProvider>().isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Display Theme',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      Switch(
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                        activeThumbColor: Colors.deepOrangeAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.watch<ThemeProvider>().isDarkMode
                        ? '🌙 Dark Mode (Currently Active)'
                        : '☀️ Light Mode (Currently Active)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Analytics Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('View Analytics & Insights'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: 24),

          // Emergency Logs Section - Made prominent
          Text(
            '📋 Emergency Logs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Log Stats
          FutureBuilder<List<EmergencyLog>>(
            future: _logsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final logs = snapshot.data ?? [];
              final fireAlerts = logs
                  .where((l) => l.alertType == 'FIRE')
                  .length;
              final magnetAlerts = logs
                  .where((l) => l.alertType == 'MAGNET')
                  .length;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  logs.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text('Total Alerts'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  fireAlerts.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text('🔥'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  magnetAlerts.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text('🧲'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Logs List
                  if (logs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No emergency logs yet',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: logs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 0, indent: 16, endIndent: 16),
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final isFireAlert = log.alertType == 'FIRE';

                          return ListTile(
                            leading: Icon(
                              isFireAlert
                                  ? Icons.local_fire_department
                                  : Icons.sensors,
                              color: isFireAlert
                                  ? Colors.redAccent
                                  : Colors.blueAccent,
                            ),
                            title: Text(log.alertType),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(log.description),
                                const SizedBox(height: 4),
                                Text(
                                  log.timestamp,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Action Buttons Row
                  if (logs.isNotEmpty)
                    Column(
                      children: [
                        // Export Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('📥 Export Logs'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () => _exportLogs(context),
                        ),
                        const SizedBox(height: 12),
                        // Clear Logs Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('🗑️'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () => _clearLogs(context),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // App Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ℹ️ About',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('App Version'),
                      Text(
                        '1.0.0',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Build'),
                      Text('1', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
