import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';
import '../../models/classes/Animal.dart'; // Assuming this file exists and contains the Animal model

class AddNewAnimalFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;
  const AddNewAnimalFloatingActionButton({
    super.key,
    required this.keyFab
  });

  @override
  State<AddNewAnimalFloatingActionButton> createState() => _AddNewAnimalFloatingActionButtonState();
}

class _AddNewAnimalFloatingActionButtonState extends State<AddNewAnimalFloatingActionButton> {
  late TextEditingController nameController;
  late TextEditingController sicknessesController;
  late TextEditingController descriptionController;

  DateTime? birthDate;
  late GlobalKey<ExpandableFabState> keyToClose;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    sicknessesController = TextEditingController();
    descriptionController = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "AnimalFab",
      child: FaIcon(FontAwesomeIcons.horse),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            var provider = context.read<GlobalProvider>();
            var providerWatch = context.watch<GlobalProvider>();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Animal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    provider.buildTextField(nameController, 'Animal Name (required)', sizeForFont: 24),
                    const SizedBox(height: 5),

                    // Use buildOption for Animal Type Selection
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.paw),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                 context.watch<GlobalProvider>().selectedAnimalType.isNotEmpty
                                    ? context.watch<GlobalProvider>().selectedAnimalType["name"]
                                    : "Select a type for the animal",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView(
                              children: providerWatch.allAnimalTypes.map<Widget>((e) {
                                return ListTile(
                                  title: Text(e.name),
                                  onTap: () {
                                    context.read<GlobalProvider>().setSelectedAnimalType({
                                      "animalTypeId": e.animalTypeId,
                                      "name": e.name
                                    });
                                    Navigator.pop(context);  // Close the modal after selection
                                  },
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 5),
                    provider.buildTextField(sicknessesController, 'Sicknesses (optional)'),
                    const SizedBox(height: 5),
                    provider.buildTextField(descriptionController, 'Description (optional)'),
                    const SizedBox(height: 5),

                    // Date selection
                    provider.buildOption(
                      icon: Icons.calendar_today,
                      label: providerWatch.selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(providerWatch.selectedDate!)
                          : "Select a birthdate for the animal",
                      onTap: () async {
                        birthDate = await provider.pickDate(context, initialDate: birthDate);
                      },
                    ),
                    const SizedBox(height: 20),

                    Consumer<GlobalProvider>(
                      builder: (context, animalManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty) {
                              final newAnimal = Animal(
                                name: nameController.text,
                                animalTypeId: context.read<GlobalProvider>().selectedAnimalType["animalTypeId"],
                                birthDate: birthDate,
                                sicknesses: sicknessesController.text,
                                description: descriptionController.text,
                              );

                              animalManager.createAnimal(newAnimal);
                              Navigator.pop(context);
                              nameController.clear();
                              sicknessesController.clear();
                              descriptionController.clear();
                              animalManager.cleanSelected();
                            } else {
                              animalManager.showSnackBar("Please fill the required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add Animal"),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ).whenComplete(() => keyToClose.currentState?.toggle());
      },
    );
  }



}
