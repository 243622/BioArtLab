import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class BirdInfoPage extends StatefulWidget {
  const BirdInfoPage({Key? key}) : super(key: key);

  @override
  State<BirdInfoPage> createState() => _BirdInfoPageState();
}

class _BirdInfoPageState extends State<BirdInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final textsToTranslate = [
        "Bird Details",
        "Bird Info",
        "Overview",
        "Birds are domesticated animals raised for their labor, companionship, and sometimes for meat.",
        "Notes",
        "Make sure electricity works",
        "Check all birds, if there’s something off, notify the team",
        "Check:",
        "If there are eggs or baby’s before cleaning nests",
        "Place stones properly outside the entrance to keep martens and rodents out",
        "If there are eggs or babies before cleaning nests",
        "If there are eggs leave it alone / if dirty and no eggs, clean it",
        "If doors properly close",
        "Check for holes around fence",
        "Check for hidden nests in cabin",
        "Check for pigeon eggs, take these away",
        "Clean:",
        "Clean water sources",
        "Clean all abandoned nests",
        "Put new straw or nesting material",
        "Clean cabin floor if muddy/wet or dirty with poop",
        "Feeding:",
        "Vitaminwater in green standing waterbowl",
        "Water always available, make sure it’s not too full so birds don’t drown",
        "Always fresh water",
        "Specific seed per group:",
        "Aviary seed: Fill bottles with finch seed 1 scoop, brush old seed away onto the floor. Fine white grit for finches, if low add more",
        "Pigeon seed: Fill flying plateau with 1 scoop. Fill grit with red clay for pigeons, if low add more",
        "Aviary quail seed: Kuikenmeel 1 scoop",
        "Dome quail seed: Kuikenmeel 1 scoop",
        "Signs that something may be wrong:",
        "Moves less, sits on the floor, doesn't feel like playing and sleeps more, eats less or becomes more picky.",
        "Common sicknesses:",
        "Marek's Disease",
        "Symptoms: Paralysis, lameness, and loss of muscle control.",
        "Causes: Viral infection affecting the nervous system.",
        "Prevention: Vaccination, biosecurity measures to prevent contact with infected birds.",
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
              backgroundColor: Colors.deepPurple,
            ),
            body: const Center(
              child: Text("Failed to load translations. Please try again."),
            ),
          );
        }

        final translations = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(translations["Bird Details"] ?? "Bird Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🐦 ${translations["Bird Info"]} ',
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
                  translations["Birds are domesticated animals raised for their labor, companionship, and sometimes for meat."] ?? "Overview text",
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
                      translations["Make sure electricity works"] ?? "",
                      translations["Check all birds, if there’s something off, notify the team"] ?? "",

                    ]),

                    const SizedBox(height: 16), // Spacing between sections

                    // Check Section
                    buildSectionTitle(
                      "${translations["Check:"]}",
                    ),
                    buildList([
                      translations["If there are eggs or baby’s before cleaning nests"] ?? "",
                      translations["If there are eggs leave it alone / if dirty and no eggs, clean it"] ?? "",
                      translations["If doors properly close"] ?? "",
                      translations["Check for holes around fence"] ?? "",
                      translations["Check for hidden nests in cabin"] ?? "",
                      translations["Check for pigeon eggs, take these away"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Clean Section
                    buildSectionTitle(
                      "${translations["Clean:"]}",
                    ),
                    buildList([
                      translations["Clean all abandoned nests"] ?? "",
                      translations["Put new straw or nesting material"] ?? "",
                      translations["Clean cabin floor if muddy/wet or dirty with poop"] ?? "",
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Feeding Section
                    buildSectionTitle(
                      "${translations["Feeding:"]}",
                    ),
                    buildList([
                      translations["Vitaminwater in green standing waterbowl"] ?? "",
                      translations["Water always available, make sure it’s not too full so birds don’t drown"] ?? "",
                      translations["Always fresh water"] ?? "",
                      translations["Aviary seed: Fill bottles with finch seed 1 scoop, brush old seed away onto the floor. Fine white grit for finches, if low add more"] ?? "",
                      translations["Pigeon seed: Fill flying plateau with 1 scoop. Fill grit with red clay for pigeons, if low add more"] ?? "",
                      translations["Aviary quail seed: Kuikenmeel 1 scoop"] ?? "",
                      translations["Dome quail seed: Kuikenmeel 1 scoop"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Signs Section
                    buildSectionTitle(
                      "${translations["Signs that something may be wrong:"]}",
                    ),
                    buildList([
                      translations["Moves less, sits on the floor, doesn't feel like playing and sleeps more, eats less or becomes more picky."] ?? ""
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
                      '${translations["Prevention: Vaccination, biosecurity measures to prevent contact with infected birds."]}',
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
