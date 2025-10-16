import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playFireAlert() async {
    await _player.play(AssetSource('sounds/fire_alert.mp3'));
  }

  Future<void> playMagnetAlert() async {
    await _player.play(AssetSource('sounds/magnetic_alert.mp3'));
  }

  void stop() => _player.stop();
}
