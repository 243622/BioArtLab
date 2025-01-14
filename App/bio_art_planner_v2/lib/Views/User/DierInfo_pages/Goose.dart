import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class GooseInfoPage extends StatefulWidget {
  const GooseInfoPage({Key? key}) : super(key: key);

  @override
  State<GooseInfoPage> createState() => _GooseInfoPageState();
}

class _GooseInfoPageState extends State<GooseInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final textsToTranslate = [
        "Goose Details",
        "Goose Info",
        "Overview",
        "Goose are domesticated animals raised for their labor, companionship, and sometimes for meat.",
        "Notes",
        "Check:",
        "Straw is clean and dry",
        "Check if electricity is on",
        "Check if water source is always available",
        "Clean:",
        "Clean water sources",
        "Pond",
        "Straw",
        "Water buckets",
        "Feeding:",
        "Fill buckets with grain 1 scoop per bucket",
        "Fill white buckets with water",
        "Signs that something may be wrong:",
        "A deviant plumage, drooping wings, emaciation, isolation, sleeping a lot or shaking the head.",
        "Common sicknesses:",
        "Colic",
        "Symptoms: Abdominal pain, bloating, rolling or kicking at the belly.",
        "Causes: Overeating, ingestion of spoiled food, or changes in diet.",
        "Prevention: Regular feeding schedule, avoid sudden changes in diet, and ensure fresh water availability.",
        "Avian Influenza",
        "Symptoms: Coughing, nasal discharge, fever, lethargy.",
        "Causes: Viral infection.",
        "Prevention: Regular vaccinations and good hygiene practices.",
        "Respiratory infections",
        "Symptoms: Coughing, nasal discharge, fever.",
        "Causes: Bacterial or viral infections, poor ventilation.",
        "Prevention: Keep environment clean, ensure proper ventilation, and avoid overcrowding.",
        "Foot infections",
        "Symptoms: Lameness, swelling, painful movement.",
        "Causes: Wet, dirty environments, poor hygiene.",
        "Prevention: Keep areas dry and clean, inspect feet regularly.",
        "Botulism",
        "Symptoms: Paralysis, weakness, drooping wings, difficulty swallowing.",
        "Causes: Bacterial toxins from decaying organic matter.",
        "Prevention: Remove dead animals or spoiled feed from the environment.",
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
            title: Text(translations["Goose Details"] ?? "Goose Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🦢 ${translations["Goose Info"]} ',
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
                  translations["Goose are domesticated animals raised for their labor, companionship, and sometimes for meat."] ?? "Overview text",
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
                      translations["Straw is clean and dry"] ?? "",
                      translations["Check if electricity is on"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Check Section
                    buildSectionTitle(
                      "${translations["Check:"]}",
                    ),
                    buildList([
                      translations["Check if water source is always available"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Clean Section
                    buildSectionTitle(
                      "${translations["Clean:"]}",
                    ),
                    buildList([
                      translations["Clean water sources"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Feeding Section
                    buildSectionTitle(
                      "${translations["Feeding:"]}",
                    ),
                    buildList([
                      translations["Fill buckets with grain 1 scoop per bucket"] ?? "",
                      translations["Fill white buckets with water"] ?? "",

                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Signs Section
                    buildSectionTitle(
                      "${translations["Signs that something may be wrong:"]}",
                    ),
                    buildList([
                      translations["A deviant plumage, drooping wings, emaciation, isolation, sleeping a lot or shaking the head."] ?? ""
                    ]),
                  ],
                ),

                const SizedBox(height: 16),

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
                  translations["Avian Influenza"] ?? "Avian Influenza",
                  '${translations["Symptoms: Coughing, nasal discharge, fever, lethargy."]}\n'
                      '${translations["Causes: Viral infection."]}\n'
                      '${translations["Prevention: Regular vaccinations and good hygiene practices."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Respiratory infections"] ?? "Respiratory infections",
                  '${translations["Symptoms: Coughing, nasal discharge, fever."]}\n'
                      '${translations["Causes: Bacterial or viral infections, poor ventilation."]}\n'
                      '${translations["Prevention: Keep environment clean, ensure proper ventilation, and avoid overcrowding."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Foot infections"] ?? "Foot infections",
                  '${translations["Symptoms: Lameness, swelling, painful movement."]}\n'
                      '${translations["Causes: Wet, dirty environments, poor hygiene."]}\n'
                      '${translations["Prevention: Keep areas dry and clean, inspect feet regularly."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Botulism"] ?? "Botulism",
                  '${translations["Symptoms: Paralysis, weakness, drooping wings, difficulty swallowing."]}\n'
                      '${translations["Causes: Bacterial toxins from decaying organic matter."]}\n'
                      '${translations["Prevention: Remove dead animals or spoiled feed from the environment."]}',
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


