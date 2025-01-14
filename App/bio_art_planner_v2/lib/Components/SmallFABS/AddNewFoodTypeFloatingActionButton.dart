import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/many_many/Foodtype_Animal.dart';

import '/models/classes/TaskType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';
import '../../models/classes/FoodType.dart';

class AddNewFoodTypeFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;

  const AddNewFoodTypeFloatingActionButton({
    super.key,
    required this.keyFab,
  });

  @override
  State<AddNewFoodTypeFloatingActionButton> createState() =>
      _AddNewFoodTypeFloatingActionButtonState();
}

class _AddNewFoodTypeFloatingActionButtonState
    extends State<AddNewFoodTypeFloatingActionButton> {
  late TextEditingController foodTypeNameController;
  TaskType? dropDownValue;
  late GlobalKey<ExpandableFabState> keyToClose;

  @override
  void initState() {
    super.initState();
    foodTypeNameController = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "FoodTypeFab",
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
                          'Add new food type',
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
                        foodTypeNameController, 'Foodtype name (required)'),
                    const SizedBox(height: 20),
                    context.read<GlobalProvider>().buildOption(icon: Icons.key,
                        label: context.watch<GlobalProvider>().selectedAnimalTypes.isNotEmpty
                        ? context.watch<GlobalProvider>().selectedAnimalTypes.map((e) => e['name']).join(', ')
                        : "Connect animaltype(Optional)",
                        onTap: (){showAnimalTypeSelector();
                    }),
                    Consumer<GlobalProvider>(
                      builder: (context, stockManager, child) {
                        return ElevatedButton(
                          onPressed: () async{
                            if (foodTypeNameController.text.isNotEmpty) {
                              final newFoodType = FoodType(name: foodTypeNameController.text);
                              var createdFoodType = await stockManager.createFoodType(newFoodType);
                              if(stockManager.selectedAnimalTypes != []){
                                for(var i = 0; i < stockManager.selectedAnimalTypes.length; i++){
                                  final animalTypeId = stockManager.selectedAnimalTypes[i]["animalTypeId"];
                                  final foodType = jsonDecode(createdFoodType);
                                  final foodTypeId = foodType["foodTypeId"];
                                  FoodtypeAnimal foodTypeAnimal = FoodtypeAnimal(foodTypeId: foodTypeId, animalTypeId: animalTypeId);
                                  stockManager.createFoodTypeAnimalType(foodTypeAnimal);
                                }
                              }
                              stockManager.cleanSelectedAnimals();
                              Navigator.pop(context);
                              foodTypeNameController.clear();
                            } else {
                              stockManager.showSnackBar("Fill de required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add food type"),
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
      child: const Icon(Icons.add),
    );
  }
  void showAnimalTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final animalTypes = context.read<GlobalProvider>().allAnimalTypes;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select animels for this foodtype',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                itemCount: animalTypes.length,
                itemBuilder: (context, index) {
                  final animalType = animalTypes[index];
                  final isSelected = context.watch<GlobalProvider>().selectedAnimalTypes.any((u) => u['animalTypeId'] == animalType.animalTypeId);

                  return ListTile(
                    title: Text(animalType.name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      if (isSelected) {
                        context.read<GlobalProvider>().removeFromSelectedAnimalTypes(animalType.animalTypeId!); // Remove user
                      } else {
                        context.read<GlobalProvider>().addToSelectedAnimalTypes({
                          "animalTypeId": animalType.animalTypeId,
                          "name": animalType.name
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
