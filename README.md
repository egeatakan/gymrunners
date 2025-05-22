# GymRunners

A Flutter app where users race against a virtual AI bot while tracking their run. Features include:

- Real-time tracking of distance, duration, and average speed
- Race against a virtual bot with four difficulty levels (Easy, Medium, Hard, Dynamic)
- Dynamic bot speed based on your past runs (via Windsurf AI)
- Sensor-based gesture detection for hands-free interaction
- Audio feedback for time difference and proximity alerts
- Robust background tracking

## Dependencies
- geolocator
- sensors_plus
- flutter_tts
- audioplayers
- background_fetch
- provider

## Getting Started
1. Install dependencies:
   ```sh
   flutter pub get
   ```
2. Run the app:
   ```sh
   flutter run
   ```

## Notes
- Windsurf AI integration is a placeholder; connect to your Windsurf AI backend for dynamic bot logic.
- Ensure location and motion permissions are granted for full functionality.
