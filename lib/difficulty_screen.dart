import 'package:flutter/material.dart';

class DifficultyScreen extends StatefulWidget {
  final String initialDifficulty;
  final int dynamicHistoryLength;
  final void Function(String difficulty, int? dynamicLen) onConfirm;
  const DifficultyScreen({Key? key, required this.initialDifficulty, required this.dynamicHistoryLength, required this.onConfirm}) : super(key: key);

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  late String _difficulty;
  late TextEditingController _dynController;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.initialDifficulty;
    _dynController = TextEditingController(text: widget.dynamicHistoryLength.toString());
  }

  @override
  void dispose() {
    _dynController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Settings'),
        backgroundColor: const Color(0xFFB6DBF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.auto_awesome, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 8),
            const Text('Prepare for Race', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Select Difficulty Level', style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  _radio('Easy'),
                  _radio('Medium'),
                  _radio('Hard'),
                  _radio('Dynamic'),
                ],
              ),
            ),
            if (_difficulty == 'Dynamic') ...[
              const SizedBox(height: 18),
              TextField(
                controller: _dynController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.list),
                  hintText: 'Average of last how many matches?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                int? dynLen = int.tryParse(_dynController.text);
                widget.onConfirm(_difficulty, dynLen);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('CONFIRM AND START', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _radio(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label,
      groupValue: _difficulty,
      onChanged: (val) {
        if (val != null) setState(() => _difficulty = val);
      },
    );
  }
}
