import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RunTracker extends ChangeNotifier {
  // ...
  void resetRace() {
    distance = 0.0;
    botDistance = 0.0;
    duration = Duration.zero;
    botDuration = Duration.zero;
    speed = 0.0;
    averageSpeed = 0.0;
    totalSteps = 0;
    _lastStepTime = null;
    notifyListeners();
  }

  // ... existing fields ...
  int totalSteps = 0;
  bool treadmillMode = false;

  // ... existing fields ...
  double speed = 0.0; // m/s, instantaneous
  static const double strideLength = 0.8; // meters per step/swing (customizable)
  DateTime? _lastStepTime;
  int _stepCount = 0;

  // Bot configuration
  static const double easyPace = 2.0; // m/s
  static const double mediumPace = 3.0; // m/s
  static const double hardPace = 4.0; // m/s
  int dynamicHistoryLength = 5; // configurable, for dynamic bot

  // Bot state
  double botDistance = 0.0;
  double botSpeed = easyPace;
  Duration botDuration = Duration.zero;
  List<double> previousRunSpeeds = [];

  bool isRunning = false;
  double distance = 0.0; // meters
  Duration duration = Duration.zero;
  double averageSpeed = 0.0; // m/s
  String difficulty = 'Easy';
  Timer? _timer;
  DateTime? _startTime;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  Future<void> startRun() async {
    isRunning = true;
    distance = 0.0;
    duration = Duration.zero;
    averageSpeed = 0.0;
    botDistance = 0.0;
    botDuration = Duration.zero;
    _startTime = DateTime.now();
    _lastPosition = null;
    _setBotSpeed();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    await _startPositionStream();
    notifyListeners();
  }

  void stopRun() {
    isRunning = false;
    _timer?.cancel();
    _positionStream?.cancel();
    // Save this run speed for dynamic bot
    if (duration.inSeconds > 0 && averageSpeed > 0.5) {
      previousRunSpeeds.add(averageSpeed);
      if (previousRunSpeeds.length > dynamicHistoryLength) {
        previousRunSpeeds.removeAt(0);
      }
    }
    notifyListeners();
  }

  void setDifficulty(String diff) {
    difficulty = diff;
    _setBotSpeed();
    notifyListeners();
  }

  void _setBotSpeed() {
    switch (difficulty) {
      case 'Easy':
        botSpeed = easyPace;
        break;
      case 'Medium':
        botSpeed = mediumPace;
        break;
      case 'Hard':
        botSpeed = hardPace;
        break;
      case 'Dynamic':
        botSpeed = _getDynamicBotSpeed();
        break;
      default:
        botSpeed = easyPace;
    }
  }

  double _getDynamicBotSpeed() {
    if (previousRunSpeeds.isEmpty) return mediumPace;
    final count = previousRunSpeeds.length < dynamicHistoryLength
        ? previousRunSpeeds.length
        : dynamicHistoryLength;
    final recent = previousRunSpeeds.sublist(previousRunSpeeds.length - count);
    return recent.reduce((a, b) => a + b) / count;
  }


  void _onTick() {
    if (!isRunning || _startTime == null) return;
    duration = DateTime.now().difference(_startTime!);
    averageSpeed = distance > 0 && duration.inSeconds > 0
        ? distance / duration.inSeconds
        : 0.0;
    // Optionally: every 15s, use GPS to correct distance
    if (duration.inSeconds % 15 == 0) {
      // GPS correction will happen in _startPositionStream if enabled
    }
    // Update bot
    botDuration = duration;
    botDistance = botSpeed * duration.inSeconds;
    notifyListeners();
  }

  // Called by GestureDetectorService on each step/swing
  void onStepDetected(DateTime timestamp) {
    totalSteps++;

    _stepCount++;
    distance += strideLength;
    if (_lastStepTime != null) {
      final dt = timestamp.difference(_lastStepTime!).inMilliseconds / 1000.0;
      if (dt > 0.15 && dt < 2.5) {
        speed = strideLength / dt;
      }
    }
    _lastStepTime = timestamp;
    notifyListeners();
  }

  // Time difference in seconds (positive: user ahead, negative: bot ahead)
  int get timeDifferenceFromBot {
    final userTime = duration.inSeconds;
    final botTime = botDistance > 0 ? (botDistance / (averageSpeed > 0 ? averageSpeed : 1)).round() : 0;
    return userTime - botTime;
  }


  Future<void> _startPositionStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Optionally, prompt user to enable location
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position pos) {
      print('[GPS] New position: lat=${pos.latitude}, lon=${pos.longitude}, acc=${pos.accuracy}');
      if (_lastPosition != null) {
        double d = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          pos.latitude,
          pos.longitude,
        );
        print('[GPS] Distance delta: $d');
        distance += d;
      }
      _lastPosition = pos;
      // averageSpeed is updated in _onTick
    });
  }

}
