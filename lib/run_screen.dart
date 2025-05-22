import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/run_tracker.dart';

class RunScreen extends StatelessWidget {
  const RunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runTracker = Provider.of<RunTracker>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Tracker'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Big Start/Stop Button
            SizedBox(
              width: 180,
              height: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: runTracker.isRunning ? Colors.red : Colors.green,
                  elevation: 8,
                ),
                onPressed: runTracker.isRunning ? runTracker.stopRun : runTracker.startRun,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      runTracker.isRunning ? Icons.stop : Icons.play_arrow,
                      size: 70,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      runTracker.isRunning ? 'Stop Run' : 'Start Run',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  icon: Icons.directions_run,
                  label: 'Distance',
                  value: '${runTracker.distance.toStringAsFixed(1)} m',
                  color: Colors.blue,
                ),
                _StatCard(
                  icon: Icons.timer,
                  label: 'Duration',
                  value: '${runTracker.duration.inSeconds} s',
                  color: Colors.deepPurple,
                ),
                _StatCard(
                  icon: Icons.speed,
                  label: 'Speed',
                  value: '${runTracker.speed.toStringAsFixed(2)} m/s',
                  color: Colors.green,
                ),
                _StatCard(
                  icon: Icons.speed,
                  label: 'Avg Speed',
                  value: '${runTracker.averageSpeed.toStringAsFixed(2)} m/s',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  icon: Icons.android,
                  label: 'Bot Dist.',
                  value: '${runTracker.botDistance.toStringAsFixed(1)} m',
                  color: Colors.teal,
                ),
                _StatCard(
                  icon: Icons.flash_on,
                  label: 'Bot Speed',
                  value: '${runTracker.botSpeed.toStringAsFixed(2)} m/s',
                  color: Colors.amber,
                ),
                _StatCard(
                  icon: Icons.directions_walk,
                  label: 'Steps',
                  value: '${runTracker.totalSteps}',
                  color: Colors.blueGrey,
                ),
                _StatCard(
                  icon: Icons.compare_arrows,
                  label: 'Time Diff',
                  value: '${runTracker.timeDifferenceFromBot} s',
                  color: Colors.pink,
                ),
              ],
            ),
            const Spacer(),
            // Difficulty Selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Difficulty:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  DropdownButton<String>(
                    value: runTracker.difficulty,
                    onChanged: (val) {
                      if (val != null) runTracker.setDifficulty(val);
                    },
                    items: const [
                      DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                      DropdownMenuItem(value: 'Dynamic', child: Text('Dynamic')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
