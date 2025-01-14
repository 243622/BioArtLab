import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class ChickenInfoPage extends StatefulWidget {
  const ChickenInfoPage({Key? key}) : super(key: key);

  @override
  State<ChickenInfoPage> createState() => _ChickenInfoPageState();
}

class _ChickenInfoPageState extends State<ChickenInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final textsToTranslate = [
        "Chicken Details",
        "Chicken Info",
        "Overview",
        "Chickens are domesticated animals raised for their labor, companionship, and sometimes for meat.",
        "Notes",
        "Make sure electricity works",
        "Check all chickens, if there’s something off, notify the team",
        "Check:",
        "Outside:",
        "Place stones properly outside the entrance to keep martens and rodents out",
        "Check electricity should always be on",
        "Look for holes around the fence",
        "Check the wires and make sure they are tightly secured",
        "Remove all fallen sticks and branches from the wires",
        "End of day close and lock the door",
        "End of day count all the chickens",
        "In cabin:",
        "Check sticks and make them hang straight",
        "Check for holes",
        "Check and collect eggs, mark and count them",
        "Clean:",
        "Clean water sources",
        "Entrance in front of cabin",
        "Clean inside the cabin",
        "Clean sticks and underneath them",
        "Clean the coops and fill with straw",
        "Feeding:",
        "Fill water with vitamins",
        "Collect eggs every day and write the date on them with pencil put them in the white cabinet in building M."
        "Fill water with vitamins",
        "Keep food stocked at all times with pellets",
        "Be sure to keep grit filled in black box",
        "Signs that something may be wrong:",
        "Is one of them emaciated, is she listless, does her egg production stop or does she regularly lay abnormal eggs.",
        "Common sicknesses:",
        "Collect eggs every day and write the date on them with pencil put them in the white cabinet in building M.",
        "Marek's Disease",
        "Symptoms: Paralysis, lameness, and loss of muscle control.",
        "Causes: Viral infection affecting the nervous system.",
        "Prevention: Vaccination, biosecurity measures to prevent contact with infected chickens.",
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
            title: Text(translations["Chicken Details"] ?? "Chicken Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🐔 ${translations["Chicken Info"]} ',
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
                  translations["Chickens are domesticated animals raised for their labor, companionship, and sometimes for meat."] ?? "Overview text",
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
                    buildList([
                      translations["Collect eggs every day and write the date on them with pencil put them in the white cabinet in building M."] ?? "",
                      translations["Make sure electricity works"] ?? "",
                      translations["Check all chickens, if there’s something off, notify the team"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Check Section
                    buildSectionTitle(
                      "${translations["Check:"]}",
                    ),
                    buildList([
                      translations["Place stones properly outside the entrance to keep martens and rodents out"] ?? ""
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
                      translations["Fill water with vitamins"] ?? "",
                      translations["Keep food stocked at all times with pellets"] ?? ""
                    ]),

                    const SizedBox(height: 16), // Spacing between sections

                    // Signs Section
                    buildSectionTitle(
                      "${translations["Signs that something may be wrong:"]}",
                    ),
                    buildList([
                      translations["Is one of them emaciated, is she listless, does her egg production stop or does she regularly lay abnormal eggs."] ?? ""
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
                  translations["Marek's Disease"] ?? "Marek's Disease",
                  '${translations["Symptoms: Paralysis, lameness, and loss of muscle control."]}\n'
                      '${translations["Causes: Viral infection affecting the nervous system."]}\n'
                      '${translations["Prevention: Vaccination, biosecurity measures to prevent contact with infected chickens."]}',
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
