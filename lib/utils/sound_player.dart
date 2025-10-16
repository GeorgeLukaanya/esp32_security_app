import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'storage_service.dart';
import 'package:intl/intl.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SoundPlayer() {
    _initializeNotifications();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      // Set the audio context for proper playback
      await _player.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.duckOthers,
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
          android: AudioContextAndroid(
            audioFocus: AndroidAudioFocus.gainTransient,
          ),
        ),
      );
      if (kDebugMode) {
        debugPrint('Audio player initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing audio player: $e');
      }
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosInitSettings =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      await _notificationsPlugin.initialize(initSettings);

      if (kDebugMode) {
        debugPrint('Notifications initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing notifications: $e');
      }
    }
  }

  Future<void> playFireAlert() async {
    try {
      // Stop any currently playing sound
      await _player.stop();

      // Set volume to maximum
      await _player.setVolume(1.0);

      // Set release mode to stop (prevents overlapping sounds)
      await _player.setReleaseMode(ReleaseMode.stop);

      // Play the sound file with proper error handling
      final source = AssetSource('sounds/fire_alert.mp3');
      await _player
          .play(source)
          .then((_) {
            if (kDebugMode) {
              debugPrint('Fire alert sound playback started');
            }
          })
          .catchError((error) {
            if (kDebugMode) {
              debugPrint('Error starting fire alert playback: $error');
            }
            throw error;
          });

      // Show notification
      await _showNotification(
        title: '🔥 Fire Alert',
        body: 'Fire detected! Immediate action required!',
        tag: 'fire_alert',
      );

      // Log the emergency event
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      await StorageService.saveEmergencyLog(
        EmergencyLog(
          timestamp: timestamp,
          alertType: 'FIRE',
          description: 'Fire detected by sensor',
          sensorData: {'alert': 'FIRE'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error playing fire alert: $e');
      }
      rethrow;
    }
  }

  Future<void> playMagnetAlert() async {
    try {
      // Stop any currently playing sound
      await _player.stop();

      // Set volume to maximum
      await _player.setVolume(1.0);

      // Set release mode to stop (prevents overlapping sounds)
      await _player.setReleaseMode(ReleaseMode.stop);

      // Play the sound file with proper error handling
      final source = AssetSource('sounds/magnetic_alert.mp3');
      await _player
          .play(source)
          .then((_) {
            if (kDebugMode) {
              debugPrint('Magnetic alert sound playback started');
            }
          })
          .catchError((error) {
            if (kDebugMode) {
              debugPrint('Error starting magnetic alert playback: $error');
            }
            throw error;
          });

      // Show notification
      await _showNotification(
        title: '🧲 Magnetic Alert',
        body: 'Magnetic field detected!',
        tag: 'magnetic_alert',
      );

      // Log the emergency event
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      await StorageService.saveEmergencyLog(
        EmergencyLog(
          timestamp: timestamp,
          alertType: 'MAGNET',
          description: 'Magnetic field detected by sensor',
          sensorData: {'alert': 'MAGNET'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error playing magnetic alert: $e');
      }
      rethrow;
    }
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    required String tag,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'com.example.esp32_security_app.alerts',
            'ESP32 Security Alerts',
            channelDescription: 'Alerts from ESP32 security system',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        tag.hashCode,
        title,
        body,
        notificationDetails,
      );

      if (kDebugMode) {
        debugPrint('Notification shown: $title - $body');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error showing notification: $e');
      }
    }
  }

  void stop() => _player.stop();
}
