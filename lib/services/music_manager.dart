import 'package:audioplayers/audioplayers.dart';

//handle music
class MusicManager {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static final AudioPlayer _effectPlayer = AudioPlayer();

  static bool _isPlaying = false;

  // Play background music (don't reset on sound effect trigger)
  static Future<void> playMusic() async {
    if (!_isPlaying) {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.play(AssetSource('audio/background_music.mp3'));
      await _bgPlayer.setVolume(0.8);
      _isPlaying = true;
    }
  }

  // Pause background music
  static Future<void> pauseMusic() async {
    await _bgPlayer.pause();
    _isPlaying = false;
  }

  // Stop background music
  static Future<void> stopMusic() async {
    await _bgPlayer.stop();
    _isPlaying = false;
  }

  // Resume background music
  static Future<void> resumeMusic() async {
    if (!_isPlaying) {
      await _bgPlayer.resume();
      _isPlaying = true;
    }
  }

  // handle sfx
  static Future<void> playSoundEffect(String soundPath) async {
    // Stop the effect player before playing a new effect
    await _effectPlayer.stop();

    // ensures that effect and bg music is not occupying the same channel for synchronous playing
    await _effectPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ),
    );
    await _effectPlayer.play(AssetSource(soundPath));
    await _effectPlayer.setVolume(1.0);
  }

  // Stop current sound effect
  static Future<void> stopSoundEffect() async {
    await _effectPlayer.stop();
  }
}
