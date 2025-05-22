import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects three rapid forward-and-backward arm swings using accelerometer data.
class GestureDetectorService {
  final void Function() onTripleSwing;
  final void Function(DateTime timestamp)? onStep;
  StreamSubscription? _sub;

  // State
  int _swingCount = 0;
  DateTime? _lastSwingTime;

  GestureDetectorService({required this.onTripleSwing, this.onStep});

  void start() {
    _sub = accelerometerEvents.listen(_onData);
  }

  void stop() {
    _sub?.cancel();
  }

  void _onData(AccelerometerEvent event) {
    // Simple swing detection: high acceleration in X or Y axis
    final threshold = 9.0; // lower threshold for better sensitivity
    final now = DateTime.now();
    // Debug: Print sensor values
    print('Accel: x=${event.x.toStringAsFixed(2)}, y=${event.y.toStringAsFixed(2)}, z=${event.z.toStringAsFixed(2)}');
    if (event.x.abs() > threshold || event.y.abs() > threshold) {
      if (_lastSwingTime == null || now.difference(_lastSwingTime!).inMilliseconds > 250) {
        _swingCount++;
        print('Swing detected! Count: $_swingCount');
        if (onStep != null) onStep!(now);
        _lastSwingTime = now;
        if (_swingCount >= 3) {
          print('Triple swing detected!');
          _swingCount = 0;
          onTripleSwing();
        }
      }
    } else if (_lastSwingTime != null && now.difference(_lastSwingTime!).inSeconds > 2) {
      // Reset if too slow
      print('Swing reset');
      _swingCount = 0;
      _lastSwingTime = null;
    }
  }
}
