import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioFeedbackService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  Future<void> speakTimeDifference(int seconds) async {
    final msg = seconds == 0
        ? 'You are neck and neck with the bot!'
        : seconds > 0
            ? 'You are ahead of the bot by $seconds seconds.'
            : 'The bot is ahead by ${-seconds} seconds.';
    await _tts.speak(msg);
  }

  /// Plays a beep with frequency/intensity based on proximity (closer = faster beeps)
  Future<void> playProximityBeep(double userDist, double botDist) async {
    final diff = (userDist - botDist).abs();
    // Beep every 2s if far, down to 0.2s if very close
    final interval = diff < 3 ? 0.2 : diff < 10 ? 0.5 : 2.0;
    await _player.play(AssetSource('beep.mp3'));
    await Future.delayed(Duration(milliseconds: (interval * 1000).toInt()));
  }
}
