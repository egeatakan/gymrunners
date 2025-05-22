import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final String currentLanguage;
  final void Function(String lang) onLanguageChanged;
  const SettingsScreen({Key? key, required this.currentLanguage, required this.onLanguageChanged}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLang;

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text(AppLocalizations.of(context)!.selectLanguage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedLang,
              items: [
                DropdownMenuItem(value: 'en', child: Text(AppLocalizations.of(context)!.english)),
                DropdownMenuItem(value: 'tr', child: Text(AppLocalizations.of(context)!.turkish)),
                DropdownMenuItem(value: 'it', child: Text(AppLocalizations.of(context)!.italian)),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLang = val);
                  widget.onLanguageChanged(val);
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.featureSoon),
              ],
            ),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context)!.featureSoonDesc, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
