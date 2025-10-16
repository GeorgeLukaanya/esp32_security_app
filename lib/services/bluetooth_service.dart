import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  BluetoothConnection? connection;

  Future<bool> requestPermissions() async {
    try {
      // Request BLUETOOTH_CONNECT and BLUETOOTH_SCAN permissions
      final connectStatus = await Permission.bluetoothConnect.request();
      final scanStatus = await Permission.bluetoothScan.request();

      if (kDebugMode) {
        debugPrint('BLUETOOTH_CONNECT: $connectStatus');
        debugPrint('BLUETOOTH_SCAN: $scanStatus');
      }

      return connectStatus.isGranted && scanStatus.isGranted;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error requesting permissions: $e');
      }
      return false;
    }
  }

  Future<List<BluetoothDevice>> getAvailableDevices() async {
    try {
      // Request permissions first
      final hasPermissions = await requestPermissions();

      if (!hasPermissions) {
        if (kDebugMode) {
          debugPrint('Bluetooth permissions not granted');
        }
        return [];
      }

      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      if (kDebugMode) {
        debugPrint('Found ${devices.length} bonded devices');
        for (var device in devices) {
          debugPrint('Device: ${device.name} (${device.address})');
        }
      }
      return devices.toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting devices: $e');
      }
      return [];
    }
  }

  Future<bool> enableBluetooth() async {
    try {
      // Request permissions first
      final hasPermissions = await requestPermissions();

      if (!hasPermissions) {
        if (kDebugMode) {
          debugPrint('Bluetooth permissions not granted');
        }
        return false;
      }

      final result = await FlutterBluetoothSerial.instance.requestEnable();
      if (kDebugMode) {
        debugPrint('Bluetooth enable requested: $result');
      }
      return result ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error enabling Bluetooth: $e');
      }
      return false;
    }
  }

  Future<void> connect(String address) async {
    try {
      // Request permissions first
      final hasPermissions = await requestPermissions();

      if (!hasPermissions) {
        throw Exception('Bluetooth permissions not granted');
      }

      connection = await BluetoothConnection.toAddress(address);
      if (kDebugMode) {
        debugPrint('Connected to $address');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Connection error: $e');
      }
      rethrow;
    }
  }

  void listen(Function(String) onData) {
    connection?.input?.listen((data) {
      final message = String.fromCharCodes(data).trim();
      onData(message);
    });
  }

  void dispose() {
    connection?.dispose();
    connection = null;
  }
}
