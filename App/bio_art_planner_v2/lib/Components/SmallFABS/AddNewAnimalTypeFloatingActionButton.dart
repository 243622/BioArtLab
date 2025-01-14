import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/many_many/Foodtype_Animal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/classes/AnimalType.dart';
import '/models/classes/TaskType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';

class AddNewAnimalTypeFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;

  const AddNewAnimalTypeFloatingActionButton({
    super.key,
    required this.keyFab,
  });

  @override
  State<AddNewAnimalTypeFloatingActionButton> createState() =>
      _AddNewAnimalTypeFloatingActionButtonState();
}

class _AddNewAnimalTypeFloatingActionButtonState
    extends State<AddNewAnimalTypeFloatingActionButton> {
  late TextEditingController animalTypeNameController;
  TaskType? dropDownValue;
  late GlobalKey<ExpandableFabState> keyToClose;

  @override
  void initState() {
    super.initState();
    animalTypeNameController = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "AnimalTypeFab",
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
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
                          'Add new animal type',
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
                    const SizedBox(height: 20),
                    context.read<GlobalProvider>().buildTextField(
                        animalTypeNameController, 'Animaltype name (required)'),
                    SizedBox(height: 10),
                    context.read<GlobalProvider>().buildOption(icon: Icons.key,
                        label: context.watch<GlobalProvider>().selectedFoodTypes.isNotEmpty
                            ? context.watch<GlobalProvider>().selectedFoodTypes.map((e) => e['name']).join(', ')
                            : "Connect foodType(Optional)",
                        onTap: (){showFoodTypeSelector();
                        }),
                    const SizedBox(height: 20),
                    Consumer<GlobalProvider>(
                      builder: (context, animalManager, child) {
                        return ElevatedButton(
                          onPressed: () async{
                            if (animalTypeNameController.text.isNotEmpty) {
                              final newAnimalType =
                              AnimalType(name: animalTypeNameController.text);
                              var createdAnimalType = await animalManager.createAnimalType(newAnimalType);

                              if(animalManager.selectedFoodTypes.isNotEmpty){
                                for(var i = 0; i < animalManager.selectedFoodTypes.length; i++){
                                final foodTypeId = animalManager.selectedFoodTypes[i]["foodTypeId"];
                                final animalType = jsonDecode(createdAnimalType);
                                final animalTypeId = animalType["animalTypeId"];
                                FoodtypeAnimal foodTypeAnimal = FoodtypeAnimal(foodTypeId: foodTypeId, animalTypeId: animalTypeId);
                                animalManager.createFoodTypeAnimalType(foodTypeAnimal);
                                }
            }                  animalManager.cleanSelectedAnimals();
                              Navigator.pop(context);
                              animalTypeNameController.clear();
                            } else {
                              context.read<GlobalProvider>().showSnackBar("Fill de required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add animal type"),
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
      child: const FaIcon(FontAwesomeIcons.paw),
    );
  }
  void showFoodTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final foodTypes = context.read<GlobalProvider>().allFoodTypes;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Select foodtypes for this animalType',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodTypes.length,
                itemBuilder: (context, index) {
                  final foodType = foodTypes[index];
                  final isSelected = context.watch<GlobalProvider>().selectedFoodTypes.any((u) => u['foodTypeId'] == foodType.foodTypeId);

                  return ListTile(
                    title: Text(foodType.name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      if (isSelected) {
                        context.read<GlobalProvider>().removeFromSelectedFoodTypes(foodType.foodTypeId!); // Remove user
                      } else {
                        context.read<GlobalProvider>().addToSelectedFoodTypes({
                          "foodTypeId": foodType.foodTypeId,
                          "name": foodType.name
                        });

                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    ).whenComplete((){

    });
  }
}
