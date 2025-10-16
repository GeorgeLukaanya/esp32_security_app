import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SoundPlayer() {
    _initializeNotifications();
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
      // Set volume to maximum and enable speaker
      await _player.setVolume(1.0);
      await _player.setReleaseMode(ReleaseMode.stop);

      // Route audio to speaker
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

      // Play the sound file
      await _player.play(AssetSource('sounds/fire_alert.mp3'));

      if (kDebugMode) {
        debugPrint('Playing fire alert sound');
      }

      // Show notification
      await _showNotification(
        title: '🔥 Fire Alert',
        body: 'Fire detected! Immediate action required!',
        tag: 'fire_alert',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error playing fire alert: $e');
      }
    }
  }

  Future<void> playMagnetAlert() async {
    try {
      // Set volume to maximum and enable speaker
      await _player.setVolume(1.0);
      await _player.setReleaseMode(ReleaseMode.stop);

      // Route audio to speaker
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

      // Play the sound file
      await _player.play(AssetSource('sounds/magnetic_alert.mp3'));

      if (kDebugMode) {
        debugPrint('Playing magnetic alert sound');
      }

      // Show notification
      await _showNotification(
        title: '🧲 Magnetic Alert',
        body: 'Magnetic field detected!',
        tag: 'magnetic_alert',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error playing magnetic alert: $e');
      }
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
