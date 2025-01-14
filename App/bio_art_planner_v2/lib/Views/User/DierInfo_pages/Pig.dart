import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class PigInfoPage extends StatefulWidget {
  const PigInfoPage({Key? key}) : super(key: key);

  @override
  State<PigInfoPage> createState() => _PigInfoPageState();
}

class _PigInfoPageState extends State<PigInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final textsToTranslate = [
        "Pig Details",
        "Pig Info",
        "Overview",
        "Pigs are domesticated animals raised for their labor, companionship, and sometimes for meat.",
        "Notes",
        "Check:",
        "Check if water source is always available",
        "Check if straw is clean for them to sleep in",
        "Remove stones that the pigs dug up",
        "Check if water is properly running",
        "Clean:",
        "Clean water sources",
        "Feeding:",
        "2 scoops of feed per day",
        "Signs something may be wrong",
        "If the pig no longer eats or no longer enjoys eating as much. Another signal is the listless pig.",
        "Common sicknesses:",
        "Colic",
        "Symptoms: Abdominal pain, bloating, rolling or kicking at the belly.",
        "Causes: Overeating, ingestion of spoiled food, or changes in diet.",
        "Prevention: Regular feeding schedule, avoid sudden changes in diet, and ensure fresh water availability.",
        "Laminitis",
        "Symptoms: Lameness, heat in the hooves, reluctance to move.",
        "Causes: Obesity, overfeeding, and underlying metabolic issues.",
        "Prevention: Regular hoof care, avoid overfeeding grains, and maintain a healthy weight.",
        "Respiratory infections",
        "Symptoms: Coughing, nasal discharge, fever.",
        "Causes: Bacterial or viral infections, poor ventilation.",
        "Prevention: Keep stables clean, ensure proper ventilation, and vaccinate regularly.",
        "Swine flu",
        "Symptoms: Fever, nasal discharge, coughing, and lethargy.",
        "Causes: Influenza virus.",
        "Prevention: Regular vaccinations and good hygiene practices.",
        "Tetanus",
        "Symptoms: Muscle stiffness, spasms, difficulty moving.",
        "Causes: Bacterial infection from deep wounds.",
        "Prevention: Vaccinate pigs against tetanus and promptly clean any injuries.",
      ];

      final translations = await Future.wait(
        textsToTranslate.map((text) => translator.translate(text, from: "en", to: usersLanguage)),
      );

      return Map.fromIterables(textsToTranslate, translations.map((translation) => translation.text));
    } catch (e) {
      return {"error": "Translation failed. Please check your internet connection."};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: translateText(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
              backgroundColor: Colors.white10,
            ),
            body: const Center(
              child: Text("Failed to load translations. Please try again."),
            ),
          );
        }

        final translations = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(translations["Pig Details"] ?? "Pig Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🐖 ${translations["Pig Info"]} ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Overview Section
                Text(
                  translations["Overview"] ?? "Overview",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  translations["Pigs are domesticated animals raised for their labor, companionship, and sometimes for meat."] ??
                      "Overview text",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Notes Section
                buildSectionTitle(
                  translations["Notes"] ?? "Notes",
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // General instructions
                    buildList([
                      translations["Check if straw is clean for them to sleep in"] ?? "",
                      translations["Remove stones that the pigs dug up"] ?? "",
                    translations["Check if water is properly running"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Check Section
                    buildSectionTitle(
                      "${translations["Check:"]}",
                    ),
                    buildList([
                      '• ${translations["Check if water source is always available"]}',
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Clean Section
                    buildSectionTitle(
                      "${translations["Clean:"]}",
                    ),
                    buildList([
                      translations["Clean water sources"] ?? "",
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Feeding Section
                    buildSectionTitle(
                      "${translations["Feeding:"]}",
                    ),
                    buildList([
                      translations["2 scoops of feed per day"] ?? "",

                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Signs Section
                    buildSectionTitle(
                      "${translations["Signs something may be wrong"]}",
                    ),
                    buildList([
                       translations["If the pig no longer eats or no longer enjoys eating as much. Another signal is the listless pig."] ?? "",
                    ]),
                  ],
                ),

                const SizedBox(height: 36),

                // Health and Common Diseases Section
                Text(
                  translations["Common sicknesses"] ?? "Common sicknesses",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Colic"] ?? "Colic",
                  '${translations["Symptoms: Abdominal pain, bloating, rolling or kicking at the belly."]}\n'
                      '${translations["Causes: Overeating, ingestion of spoiled food, or changes in diet."]}\n'
                      '${translations["Prevention: Regular feeding schedule, avoid sudden changes in diet, and ensure fresh water availability."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Laminitis"] ?? "Laminitis",
                  '${translations["Symptoms: Lameness, heat in the hooves, reluctance to move."]}\n'
                      '${translations["Causes: Obesity, overfeeding, and underlying metabolic issues."]}\n'
                      '${translations["Prevention: Regular hoof care, avoid overfeeding grains, and maintain a healthy weight."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Respiratory infections"] ?? "Respiratory infections",
                  '${translations["Symptoms: Coughing, nasal discharge, fever."]}\n'
                      '${translations["Causes: Bacterial or viral infections, poor ventilation."]}\n'
                      '${translations["Prevention: Keep stables clean, ensure proper ventilation, and vaccinate regularly."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Swine flu"] ?? "Swine flu",
                  '${translations["Symptoms: Fever, nasal discharge, coughing, and lethargy."]}\n'
                      '${translations["Causes: Influenza virus."]}\n'
                      '${translations["Prevention: Regular vaccinations and good hygiene practices."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Tetanus"] ?? "Tetanus",
                  '${translations["Symptoms: Muscle stiffness, spasms, difficulty moving."]}\n'
                      '${translations["Causes: Bacterial infection from deep wounds."]}\n'
                      '${translations["Prevention: Vaccinate pigs against tetanus and promptly clean any injuries."]}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

// Helper function to create list of items
  Widget buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) =>
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.circle, size: 10),
            title: Text(item, style: const TextStyle(fontSize: 16)),
          ))
          .toList(),
    );
  }

// Helper function to build disease section
  Widget buildDiseaseSection(String title, String content) {
    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

}

