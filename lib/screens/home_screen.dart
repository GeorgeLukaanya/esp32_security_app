import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../services/bluetooth_service.dart';
import '../utils/sound_player.dart';

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
      setState(() => _status = "Connected to ${device.name}");

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

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 Security")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            Text(_status, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text("Connect"),
              onPressed: _showDeviceSelectionDialog,
            ),
            const SizedBox(height: 30),
            Text(_alert, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
