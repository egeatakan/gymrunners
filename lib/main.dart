import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'run_screen.dart';
import 'difficulty_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'src/run_tracker.dart';
import 'src/gesture_detector_service.dart';
import 'src/audio_feedback_service.dart';

void main() {
  runApp(const GymRunnersApp());
}

class GymRunnersApp extends StatefulWidget {
  const GymRunnersApp({super.key});

  @override
  State<GymRunnersApp> createState() => _GymRunnersAppState();
}

class _GymRunnersAppState extends State<GymRunnersApp> {
  Locale _locale = const Locale('en');

  void _updateLocale(String langCode) {
    setState(() {
      _locale = Locale(langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RunTracker()),
      ],
      child: MaterialApp(
        locale: _locale,
        title: 'GymRunners',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('tr'),
          Locale('it'),
        ],
        home: HomeScreen(
          onLocaleChanged: _updateLocale,
          currentLocale: _locale.languageCode,
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final void Function(String lang)? onLocaleChanged;
  final String? currentLocale;
  const HomeScreen({super.key, this.onLocaleChanged, this.currentLocale});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { // removed unused _selectedLang
  GestureDetectorService? _gestureService;
  AudioFeedbackService? _audioService;
  Timer? _proximityBeepTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final runTracker = Provider.of<RunTracker>(context);
    _gestureService?.stop();
    _audioService ??= AudioFeedbackService();
    _proximityBeepTimer?.cancel();
    if (runTracker.isRunning) {
      _gestureService = GestureDetectorService(
        onTripleSwing: _onTripleSwing,
        onStep: (timestamp) => runTracker.onStepDetected(timestamp),
      );
      _gestureService!.start();
      // Start periodic proximity beeping
      _proximityBeepTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
        _audioService!.playProximityBeep(runTracker.distance, runTracker.botDistance);
      });
    }
  }

  @override
  void dispose() {
    _gestureService?.stop();
    _proximityBeepTimer?.cancel();
    super.dispose();
  }

  void _onTripleSwing() {
    final runTracker = Provider.of<RunTracker>(context, listen: false);
    final diff = runTracker.timeDifferenceFromBot;
    _audioService?.speakTimeDifference(diff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymRunners'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Icon(Icons.directions_run, size: 72, color: Colors.blueGrey[700]),
          const SizedBox(height: 18),
          const Text('GymRunners', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 6),
          const Text('Welcome,', style: TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 32),
          _MenuButton(
            color: const Color(0xFF39627D),
            icon: Icons.play_arrow,
            label: AppLocalizations.of(context)!.play,
            onTap: () async {
              final runTracker = Provider.of<RunTracker>(context, listen: false);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DifficultyScreen(
                    initialDifficulty: runTracker.difficulty,
                    dynamicHistoryLength: runTracker.dynamicHistoryLength,
                    onConfirm: (difficulty, dynLen) {
                      Navigator.pop(context, {'difficulty': difficulty, 'dynamicLen': dynLen});
                    },
                  ),
                ),
              );
              if (result != null) {
                runTracker.setDifficulty(result['difficulty']);
                if (result['dynamicLen'] != null) {
                  runTracker.dynamicHistoryLength = result['dynamicLen'];
                }
                runTracker.resetRace();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RunScreen()),
                );
              }
            },
          ),
          _MenuButton(
            color: const Color(0xFF2A9D8F),
            icon: Icons.person,
            label: AppLocalizations.of(context)!.profile,
            onTap: () {},
          ),
          _MenuButton(
            color: const Color(0xFF6A4C93),
            icon: Icons.bar_chart,
            label: AppLocalizations.of(context)!.statistics,
            onTap: () {},
          ),
          _MenuButton(
            color: const Color(0xFFE6863A),
            icon: Icons.settings,
            label: AppLocalizations.of(context)!.settings,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    currentLanguage: widget.currentLocale ?? 'en',
                    onLanguageChanged: (lang) {
                      if (widget.onLocaleChanged != null) {
                        widget.onLocaleChanged!(lang);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          _MenuButton(
            color: const Color(0xFFD44E44),
            icon: Icons.exit_to_app,
            label: AppLocalizations.of(context)!.exit,
            onTap: () {},
          ),
        ],
      ),
    );
  }

}

class _MenuButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuButton({required this.color, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
