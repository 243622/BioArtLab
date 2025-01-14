import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class CowInfoPage extends StatefulWidget {
  const CowInfoPage({Key? key}) : super(key: key);

  @override
  State<CowInfoPage> createState() => _CowInfoPageState();
}

class _CowInfoPageState extends State<CowInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context.read<GlobalProvider>().usersLanguage;
      final textsToTranslate = [
        "Cow Details",
        "Cow Info",
        "Overview",
        "Cows are domesticated animals raised for their milk and meat.",
        "Notes",
        "Red colored cow, inflamed udder.",
        "Check:",
        "Green light for the electricity, make sure it’s always on",
        "Make sure people never touch the electricity",
        "Check if mineral stone is available",
        "Clean:",
        "Every day: Poop, shed, water source, feeding buckets",
        "Every Monday: Big clean day, clean out the whole shed and refresh straw",
        "On warm days only: Clean the cows.",
        "Feeding:",
        "2 scoops of pellets every day, Morning: 1.5 bales of hay",
        "Signs that there may be something wrong:",
        "The cow develops hollow eyes and an absent gaze. Floppy ears drooping backward or downward.",
        "Common sicknesses:",
        "Foot Rot",
        "Symptoms: Lameness, foul odor, swelling between the toes.",
        "Causes: Bacteria from damp, muddy ground.",
        "Prevention: Regular hoof trimming, dry bedding, and foot baths with zinc or copper sulfate.",
        "Mastitis",
        "Symptoms: Swollen, hard, or hot udder; abnormal milk (clotted or watery).",
        "Causes: Bacterial infection (e.g., Staphylococcus, Streptococcus).",
        "Prevention: Keep bedding clean, ensure calves nurse from both teats.",
        "Bloat",
        "Symptoms: Distended left side, discomfort, reluctance to move.",
        "Causes: Overconsumption of fresh legumes or grains.",
        "Prevention: Avoid sudden diet changes, feed dry hay before grazing legumes.",
        "Ketosis",
        "Symptoms: Decreased appetite, weight loss, sweet-smelling breath.",
        "Causes: Energy imbalance during early lactation.",
        "Prevention: Provide adequate energy-rich feed, avoid obesity before calving.",
        "Milk Fever",
        "Symptoms: Weakness, inability to stand, cold ears.",
        "Causes: Calcium deficiency during early lactation.",
        "Prevention: Provide calcium supplements before and after calving.",
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
            title: Text(translations["Cow Details"] ?? "Cow Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '🐄 ${translations["Cow Info"]}',
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
                  translations["Cows are domesticated animals raised for their milk and meat."] ?? "Overview text",
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
                      translations["Red colored cow, inflamed udder."] ?? "",
                      translations["Check if mineral stone is available"] ?? "",
                      translations["Every Monday: Big clean day, clean out the whole shed and refresh straw"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Check Section
                    buildSectionTitle(
                      "${translations["Check:"]}",
                    ),
                    buildList([
                      translations["Green light for the electricity, make sure it’s always on"] ?? "",
                      translations["Make sure people never touch the electricity"] ?? "",
                      translations["Check if mineral stone is available"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Clean Section
                    buildSectionTitle(
                      "${translations["Clean:"]}",
                    ),
                    buildList([
                      translations["Every day: Poop, shed, water source, feeding buckets"] ?? "",
                      translations["Every Monday: Big clean day, clean out the whole shed and refresh straw"] ?? "",
                      translations["On warm days only: Clean the cows."] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Feeding Section
                    buildSectionTitle(
                      "${translations["Feeding:"]}",
                    ),
                    buildList([
                      translations["2 scoops of pellets every day, Morning: 1.5 bales of hay"] ?? ""
                    ]),
                    const SizedBox(height: 16), // Spacing between sections

                    // Signs Section
                    buildSectionTitle(
                      "${translations["Signs that there may be something wrong:"]}",
                    ),
                    buildList([
                      translations["The cow develops hollow eyes and an absent gaze. Floppy ears drooping backward or downward."] ?? ""
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
                  translations["Foot Rot"] ?? "Foot Rot",
                  '${translations["Symptoms: Lameness, foul odor, swelling between the toes."]}\n'
                      '${translations["Causes: Bacteria from damp, muddy ground."]}\n'
                      '${translations["Prevention: Regular hoof trimming, dry bedding, and foot baths with zinc or copper sulfate."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Mastitis"] ?? "Mastitis",
                  '${translations["Symptoms: Swollen, hard, or hot udder; abnormal milk (clotted or watery)."]}\n'
                      '${translations["Causes: Bacterial infection (e.g., Staphylococcus, Streptococcus)."]}\n'
                      '${translations["Prevention: Keep bedding clean, ensure calves nurse from both teats."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Bloat"] ?? "Bloat",
                  '${translations["Symptoms: Distended left side, discomfort, reluctance to move."]}\n'
                      '${translations["Causes: Overconsumption of fresh legumes or grains."]}\n'
                      '${translations["Prevention: Avoid sudden diet changes, feed dry hay before grazing legumes."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Ketosis"] ?? "Ketosis",
                  '${translations["Symptoms: Decreased appetite, weight loss, sweet-smelling breath."]}\n'
                      '${translations["Causes: Energy imbalance during early lactation."]}\n'
                      '${translations["Prevention: Provide adequate energy-rich feed, avoid obesity before calving."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Milk Fever"] ?? "Milk Fever",
                  '${translations["Symptoms: Weakness, inability to stand, cold ears."]}\n'
                      '${translations["Causes: Calcium deficiency during early lactation."]}\n'
                      '${translations["Prevention: Provide calcium supplements before and after calving."]}',
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
