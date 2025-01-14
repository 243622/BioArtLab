
import 'package:bio_art_planner_v2/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:provider/provider.dart';
import 'package:language_picker/language_picker.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = true; // Tracks the theme mode
  late Language _selectedDialogLanguage = Languages.english;
  late String selectedLanguage;

  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      SizedBox(width: 8.0),
      Flexible(child: Text("(${language.isoCode})"))
    ],
  );

  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your language'),
            onValuePicked: (Language language) => setState(() {
              _selectedDialogLanguage = language;
              context.read<GlobalProvider>().setUsersLanguage(_selectedDialogLanguage.isoCode);

              print(_selectedDialogLanguage.name);
              print(_selectedDialogLanguage.isoCode);
            }),
            itemBuilder: _buildDialogItem)),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask((){
      selectedLanguage = context.read<GlobalProvider>().usersLanguage;
      _selectedDialogLanguage = Language.fromIsoCode(selectedLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Language:",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: _openLanguagePickerDialog,
                  child: Text(
                    "Current language: ${_selectedDialogLanguage.isoCode}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add spacing
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20), // Info icon
                const SizedBox(width: 8), // Space between icon and text
                Expanded(
                  child: Text(
                    "Tip: Refresh the dashboard page after changing the language to see the text translated.",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }


}
