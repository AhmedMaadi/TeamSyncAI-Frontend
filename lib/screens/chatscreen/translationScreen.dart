import 'package:flutter/material.dart';
import 'package:teamsyncai/services/translation_service.dart';

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  TextEditingController _inputController = TextEditingController();
  String _outputText = '';
  String _selectedInputLanguage = 'en';
  String _selectedOutputLanguage = 'fr';

  List<String> languages = ['en', 'fr', 'es', 'de']; // Update with your languages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedInputLanguage,
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInputLanguage = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Select input language'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(labelText: 'Enter text to translate'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedOutputLanguage,
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOutputLanguage = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Select output language'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String inputText = _inputController.text;
                try {
                  String translated = await TranslationService.translateText(
                    inputText,
                    _selectedInputLanguage,
                    _selectedOutputLanguage,
                    'user@example.com', // Replace with actual user email
                  );
                  setState(() {
                    _outputText = translated;
                  });
                } catch (error) {
                  setState(() {
                    _outputText = 'Translation failed: $error';
                  });
                }
              },
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text('Translated Text:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(_outputText),
          ],
        ),
      ),
    );
  }
}