import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../utils/sound_player.dart';
import '../utils/theme_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BluetoothService _bluetoothService = BluetoothService();
  final SoundPlayer _soundPlayer = SoundPlayer();
  String _status = "Disconnected";
  String _alert = "";
  String? _connectedDeviceName;

  Future<void> _showDeviceSelectionDialog() async {
    try {
      // Enable Bluetooth first
      final bluetoothEnabled = await _bluetoothService.enableBluetooth();
      if (!bluetoothEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bluetooth is disabled')),
          );
        }
        return;
      }

      // Get available devices
      final devices = await _bluetoothService.getAvailableDevices();

      if (devices.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 4),
              content: Text(
                'No bonded Bluetooth devices found.\n'
                'Please pair your ESP32 in Android Settings → Bluetooth first.',
              ),
            ),
          );
        }
        return;
      }

      // Show device selection dialog
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Bluetooth Device'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: devices
                    .map(
                      (device) => ListTile(
                        leading: const Icon(Icons.bluetooth),
                        title: Text(device.name ?? 'Unknown'),
                        subtitle: Text(device.address),
                        onTap: () {
                          Navigator.pop(context);
                          _connectToDevice(device);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await _bluetoothService.connect(device.address);
      setState(() {
        _status = "Connected to ${device.name}";
        _connectedDeviceName = device.name;
      });

      _bluetoothService.listen((data) {
        if (data.contains("FIRE")) {
          _soundPlayer.playFireAlert();
          setState(() => _alert = "🔥 Fire Detected!");
        } else if (data.contains("MAGNET")) {
          _soundPlayer.playMagnetAlert();
          setState(() => _alert = "🧲 Magnetic Field Alert!");
        } else if (data.contains("NORMAL")) {
          _soundPlayer.stop();
          setState(() => _alert = "✅ Normal Condition");
        }
      });
    } catch (e) {
      setState(() => _status = "Connection Failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Connection failed: $e')));
      }
    }
  }

  void _disconnect() {
    _bluetoothService.dispose();
    setState(() {
      _status = "Disconnected";
      _connectedDeviceName = null;
      _alert = "";
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Disconnected from device')));
  }

  /// 🔹 Send command to ESP32 device
  /// Supported commands: "ack", "status", "cal", "reset"
  void _sendCommand(String command) {
    try {
      _bluetoothService.sendCommand(command);

      // Show feedback to user
      String feedbackMessage = '';
      switch (command) {
        case 'ack':
          feedbackMessage = 'Silencing alert...';
          break;
        case 'status':
          feedbackMessage = 'Requesting device status...';
          break;
        case 'cal':
          feedbackMessage = 'Calibrating sensors...';
          break;
        case 'reset':
          feedbackMessage = 'Resetting device...';
          break;
        default:
          feedbackMessage = 'Command sent: $command';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedbackMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending command: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 Security System"),
        centerTitle: true,
        elevation: 4,
        actions: [
          // Theme Toggle Button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                size: 24,
              ),
              tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings & Logs',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status Icon
                Icon(
                  _alert.contains("Fire")
                      ? Icons.local_fire_department
                      : _alert.contains("Magnetic")
                      ? Icons.sensors
                      : Icons.shield,
                  size: 100,
                  color: _alert.contains("Fire")
                      ? Colors.redAccent
                      : _alert.contains("Magnetic")
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
                const SizedBox(height: 24),

                // Status Display
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          _status,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _connectedDeviceName != null
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _connectedDeviceName != null
                                  ? "Connected"
                                  : "Disconnected",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Alert Display
                if (_alert.isNotEmpty)
                  Card(
                    color: _alert.contains("Fire")
                        ? Colors.red.withValues(alpha: 0.1)
                        : _alert.contains("Magnetic")
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _alert,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _alert.contains("Fire")
                              ? Colors.redAccent
                              : _alert.contains("Magnetic")
                              ? Colors.blueAccent
                              : Colors.greenAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),

                // Command Buttons Section
                Text(
                  'Commands',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Connect Button
                    if (_connectedDeviceName == null)
                      ElevatedButton.icon(
                        onPressed: _showDeviceSelectionDialog,
                        icon: const Icon(Icons.bluetooth_connected),
                        label: const Text("Connect to ESP32"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepOrangeAccent,
                          foregroundColor: Colors.black,
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _disconnect,
                        icon: const Icon(Icons.bluetooth_disabled),
                        label: const Text("Disconnect Device"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Test Sounds Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show test options
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Test Alert Sounds'),
                            content: const Text(
                              'Select an alert to test if sound is working correctly on your device.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _soundPlayer.playFireAlert();
                                  Navigator.pop(context);
                                },
                                child: const Text('🔥 Test Fire Alert'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _soundPlayer.playMagnetAlert();
                                  Navigator.pop(context);
                                },
                                child: const Text('🧲 Test Magnet Alert'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.speaker_phone),
                      label: const Text("Test Sounds"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Device Control Section (Only when connected)
                    if (_connectedDeviceName != null) ...[
                      // Title for device controls
                      Text(
                        'Device Controls',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Grid of control buttons
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: [
                          // Silence Alert Button
                          ElevatedButton.icon(
                            onPressed: () => _sendCommand('ack'),
                            icon: const Icon(Icons.volume_off, size: 20),
                            label: const Text(
                              'Silence',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),

                          // Get Status Button
                          ElevatedButton.icon(
                            onPressed: () => _sendCommand('status'),
                            icon: const Icon(Icons.info, size: 20),
                            label: const Text(
                              'Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),

                          // Calibrate Button
                          ElevatedButton.icon(
                            onPressed: () => _sendCommand('cal'),
                            icon: const Icon(Icons.tune, size: 20),
                            label: const Text(
                              'Calibrate',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),

                          // Reset Button
                          ElevatedButton.icon(
                            onPressed: () => _sendCommand('reset'),
                            icon: const Icon(Icons.restart_alt, size: 20),
                            label: const Text(
                              'Reset',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Settings Button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text("Settings & Logs"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
