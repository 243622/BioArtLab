import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../models/globalProvider.dart';

class SheepInfoPage extends StatefulWidget {
  const SheepInfoPage({Key? key}) : super(key: key);

  @override
  State<SheepInfoPage> createState() => _SheepInfoPageState();
}

class _SheepInfoPageState extends State<SheepInfoPage> {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateText() async {
    try {
      final usersLanguage = context
          .read<GlobalProvider>()
          .usersLanguage;
      final textsToTranslate = [
        "Sheep Details",
        "Sheep Info",
        "Overview",
        "Sheep are domesticated animals raised for their wool, meat, and milk. They are social animals that thrive in flocks and require proper care for health and productivity.",
        "Notes",
        "Make a small trench to keep water from entering.",
        "Check fencing around trees. If any sticks are loose, fix them to protect the trees.",
        "Ensure the mineral stone is still available.",
        "Clean:",
        "Collect manure and spread it evenly on the ground.",
        "Replace dirty straw with clean bedding.",
        "Clean water sources.",
        "Feeding:",
        "Provide 2/3 bale of hay daily. If there is still some left, monitor usage.",
        "Ensure water sources are always full.",
        "Signs something may be wrong:",
        "A sheep that is slow or isolated from the flock might require attention.",
        "Nutrition",
        "Sheep pellets and hay.",
        "Health and Common Diseases",
        "Foot Rot",
        "Symptoms: Lameness, foul odor, swelling between the toes.",
        "Causes: Bacteria from damp, muddy ground.",
        "Prevention: Regular hoof trimming, dry bedding, and foot baths with zinc or copper sulfate.",
        "Internal Parasites (Worms)",
        "Symptoms: Weight loss, diarrhea, bottle jaw (fluid under jaw), pale gums.",
        "Causes: Grazing contaminated pastures.",
        "Prevention: Rotate grazing areas, deworm regularly, avoid overstocking.",
        "Sheep Scab",
        "Symptoms: Severe itching, wool loss, crusty skin.",
        "Cause: Mites (Psoroptes ovis).",
        "Prevention: Treat with injectable medications (e.g., ivermectin) and quarantine new animals.",
        "Coccidiosis",
        "Symptoms: Diarrhea (sometimes bloody), weight loss, dehydration.",
        "Cause: Protozoa in contaminated feed or water.",
        "Prevention: Clean feeding/drinking areas, provide coccidiostats for lambs.",
        "Mastitis",
        "Symptoms: Swollen, hard, or hot udder; abnormal milk (clotted or watery).",
        "Causes: Bacterial infection (e.g., Staphylococcus, Streptococcus).",
        "Prevention: Keep bedding clean, ensure lambs nurse from both teats.",
        "Clostridial Diseases",
        "Symptoms: Sudden death, abdominal pain, stiffness (tetanus).",
        "Prevention: Vaccinate against clostridial diseases (e.g., CDT vaccine).",
      ];

      final translations = await Future.wait(
        textsToTranslate.map((text) =>
            translator.translate(text, from: "en", to: usersLanguage)),
      );

      return Map.fromIterables(textsToTranslate,
          translations.map((translation) => translation.text));
    } catch (e) {
      return {
        "error": "Translation failed. Please check your internet connection."
      };
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
            title: Text(translations["Sheep Details"] ?? "Sheep Details"),
            backgroundColor: Colors.white10,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Overview Section
                Center(
                  child: Text(
                    '🐑 ${translations["Sheep Info"]}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                buildSectionTitle(translations["Overview"] ?? "Overview"),
                const SizedBox(height: 8),
                Text(
                  translations["Sheep are domesticated animals raised for their wool, meat, and milk. They are social animals that thrive in flocks and require proper care for health and productivity."] ??
                      "Overview text",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Notes Section
                buildSectionTitle(translations["Notes"] ?? "Notes"),
                const SizedBox(height: 8),
                buildList([
                  translations["Make a small trench to keep water from entering."] ?? "",
                  translations["Check fencing around trees. If any sticks are loose, fix them to protect the trees."] ?? "",
                  translations["Ensure the mineral stone is still available."] ?? ""
                ]),
                const SizedBox(height: 16),

                // Clean Section
                buildSectionTitle(translations["Clean:"] ?? "Clean:"),
                buildList([
                  translations["Collect manure and spread it evenly on the ground."] ?? "",
                  translations["Replace dirty straw with clean bedding."] ?? "",
                  translations["Clean water sources."] ?? ""
                ]),
                const SizedBox(height: 16),

                // Feeding Section
                buildSectionTitle(translations["Feeding:"] ?? "Feeding:"),
                buildList([
                  translations["Provide 2/3 bale of hay daily. If there is still some left, monitor usage."] ?? "",
                  translations["Ensure water sources are always full."] ?? ""
                ]),
                const SizedBox(height: 16),

                // Signs Section
                buildSectionTitle(
                    translations["Signs something may be wrong:"] ??
                        "Signs something may be wrong:"),
                buildList([
                  translations["A sheep that is slow or isolated from the flock might require attention."] ?? ""
                ]),
                const SizedBox(height: 16),

                // Nutrition Section
                buildSectionTitle(translations["Nutrition"] ?? "Nutrition"),
                Text(translations["Sheep pellets and hay."] ??
                    "Sheep pellets and hay.",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 40),

                // Health and Common Diseases Section
                buildSectionTitle(translations["Health and Common Diseases"] ??
                    "Health and Common Diseases"),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Foot Rot"] ?? "Foot Rot",
                  '${translations["Symptoms: Lameness, foul odor, swelling between the toes."]}\n'
                      '${translations["Causes: Bacteria from damp, muddy ground."]}\n'
                      '${translations["Prevention: Regular hoof trimming, dry bedding, and foot baths with zinc or copper sulfate."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Internal Parasites (Worms)"] ??
                      "Internal Parasites (Worms)",
                  '${translations["Symptoms: Weight loss, diarrhea, bottle jaw (fluid under jaw), pale gums."]}\n'
                      '${translations["Causes: Grazing contaminated pastures."]}\n'
                      '${translations["Prevention: Rotate grazing areas, deworm regularly, avoid overstocking."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Sheep Scab"] ?? "Sheep Scab",
                  '${translations["Symptoms: Severe itching, wool loss, crusty skin."]}\n'
                      '${translations["Cause: Mites (Psoroptes ovis)."]}\n'
                      '${translations["Prevention: Treat with injectable medications (e.g., ivermectin) and quarantine new animals."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Coccidiosis"] ?? "Coccidiosis",
                  '${translations["Symptoms: Diarrhea (sometimes bloody), weight loss, dehydration."]}\n'
                      '${translations["Cause: Protozoa in contaminated feed or water."]}\n'
                      '${translations["Prevention: Clean feeding/drinking areas, provide coccidiostats for lambs."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Mastitis"] ?? "Mastitis",
                  '${translations["Symptoms: Swollen, hard, or hot udder; abnormal milk (clotted or watery)."]}\n'
                      '${translations["Causes: Bacterial infection (e.g., Staphylococcus, Streptococcus)."]}\n'
                      '${translations["Prevention: Keep bedding clean, ensure lambs nurse from both teats."]}',
                ),
                const SizedBox(height: 8),
                buildDiseaseSection(
                  translations["Clostridial Diseases"] ??
                      "Clostridial Diseases",
                  '${translations["Symptoms: Sudden death, abdominal pain, stiffness (tetanus)."]}\n'
                      '${translations["Prevention: Vaccinate against clostridial diseases (e.g., CDT vaccine)."]}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper function to build section title
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
