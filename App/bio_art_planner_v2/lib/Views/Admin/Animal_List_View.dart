import 'dart:async';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/classes/FoodType.dart';
import '../../models/classes/many_many/Foodtype_Animal.dart';
import '../../models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/classes/Animal.dart';
import '../../models/classes/AnimalType.dart';

class AnimalListView extends StatefulWidget {
  const AnimalListView({super.key});

  @override
  State<AnimalListView> createState() => _AnimalListViewState();
}

class _AnimalListViewState extends State<AnimalListView> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late ScrollController scrollController;

  late TextEditingController animalName;
  late TextEditingController birthDateController;
  late TextEditingController sicknesses;
  late TextEditingController description;

  late TextEditingController animalTypeName;

  int limit = 8;
  String selectedFilter = 'Animals';

  @override
  void initState() {
    super.initState();
    animalName = TextEditingController();
    birthDateController = TextEditingController();
    sicknesses = TextEditingController();
    description = TextEditingController();
    animalTypeName = TextEditingController();
    scrollController = ScrollController();

    scrollController.addListener(onScroll);

  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      refreshIndicatorKey.currentState?.show();

      limit += 8;
      getAnimalsBySelected();
    }
  }

  formatDate(DateTime? date) {
    var dateFormat = DateFormat("dd-MM-yyyy");
    if (date != null) {
      var formatedDate = dateFormat.format(date);
      return formatedDate;
    }
  }



  Future<void> getAnimalsBySelected({int maxRetries = 5, Duration timeout = const Duration(seconds: 10)}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Attempt to fetch tasks with a timeout
        await Future.any([
          getAnimalsBySelectedInternal(), // The actual fetch logic
          Future.delayed(timeout, () => throw TimeoutException("Fetch tasks timed out"))
        ]);
        print("Tasks fetched successfully.");
        return; // Exit the loop on success
      } catch (e) {
        retryCount++;
        print("Fetch attempt $retryCount failed: $e");
        if (retryCount >= maxRetries) {
          rethrow; // Re-throw the error if max retries reached
        }
      }
    }

  }

  Future<void> getAnimalsBySelectedInternal() async{
    if(selectedFilter == "Animals"){
      await context.read<GlobalProvider>().getAllAnimals(limit);
    }
    else if(selectedFilter == "AnimalTypes"){
      await context.read<GlobalProvider>().getAllAnimalTypes();
    }
    else{
      await context.read<GlobalProvider>().getAllAnimals(limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: getAnimalsBySelected,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Animals', label: Text('Animals')),
                ButtonSegment(value: 'AnimalTypes', label: Text('Animal types')),
              ],
              selected: {selectedFilter},
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedFilter = newSelection.first;
                });
                getAnimalsBySelected();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<void>(
              future: getAnimalsBySelected(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: getAnimalsBySelected,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Consumer<GlobalProvider>(
                    builder: (context, taskManager, child) {
                      List toShow = selectedFilter == 'AnimalTypes'
                          ? taskManager.allAnimalTypes
                          : taskManager.allAnimals;

                      return ListView.separated(
                        controller: scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          var item = toShow[index];
                          if (item is Animal) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Slidable(
                                key: UniqueKey(),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible: DismissiblePane(
                                    onDismissed: () {
                                      taskManager.deleteAnimal(item.animalId!);
                                    },
                                  ),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        taskManager.deleteAnimal(item.animalId!);
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        _editAnimalDialog(
                                            context, taskManager, item);
                                      },
                                      backgroundColor: const Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                ),
                                child: ExpansionTile(
                                  tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  collapsedBackgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[350] : Colors.grey[850]  ,
                                  backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900]  ,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  leading: Text(item.animalId.toString()),
                                  subtitle:
                                  Text(item.animalTypeInString.toString()),
                                  title: Text(
                                    item.name.toString(),
                                    style: const TextStyle(),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description: ${item.description ?? 'No description'}",
                                            style: const TextStyle(
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Animaltype: ${item.animalTypeInString ?? 'No animaltype'}",
                                            style: const TextStyle(
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Sicknesses: ${item.sicknesses ?? 'N/A'}",
                                            style: const TextStyle(
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Birthdate: ${item.birthDate != null ? DateFormat("yyyy-MM-dd").format(item.birthDate!) : 'No birthdate'}",
                                            style: const TextStyle(
                                                ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (item is AnimalType) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Slidable(
                                key: UniqueKey(),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible: DismissiblePane(
                                    onDismissed: () async {
                                      final response = await taskManager
                                          .deleteAnimalType(item.animalTypeId!);
                                      if (response != true) {
                                        taskManager.showSnackBar(
                                            "Remove linked tasks before deleting", context);
                                      }
                                    },
                                  ),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        final response = await taskManager
                                            .deleteAnimalType(item.animalTypeId!);
                                        if (response != true) {
                                          taskManager.showSnackBar(
                                              "Remove linked tasks before deleting", context);
                                        }
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        _editAnimalTypeDialog(
                                            context, taskManager, item);
                                      },
                                      backgroundColor: const Color(0xFF21B7CA),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                ),
                                child: ExpansionTile(
                                  tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  collapsedBackgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[350] : Colors.grey[850]  ,
                                  backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900]  ,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  leading: Text(item.animalTypeId.toString()),
                                  title: Text(
                                    item.name.toString(),
                                    style: const TextStyle(),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.foodTypes!.isNotEmpty
                                                ? "For foodtypes: ${item.foodTypes?.map((e) => e.name).join(', ')}"
                                                : "No foodtypes",
                                            style: const TextStyle(
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                            color: Colors.transparent, height: 10),
                        itemCount: toShow.length,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  void _editAnimalTypeDialog(
      BuildContext context, GlobalProvider taskManager, AnimalType animalType) {
    animalTypeName.text = animalType.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${animalType.name}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.read<GlobalProvider>().buildTextField(
                      animalTypeName, 'Edit task type name (required)'),
                  const SizedBox(height: 10),
                  context.watch<GlobalProvider>().buildOption(icon: Icons.key,
                      label: (animalType.foodTypes != null && animalType.foodTypes!.isNotEmpty)
                          ? animalType.foodTypes!.map((e) => e.name).join(', ')
                          : "Connect foodTypes (Optional)",
                      onTap: (){showFoodTypeSelector(animalType);}),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (animalTypeName.text.isNotEmpty) {
                  AnimalType updatedAnimalType = AnimalType(name: animalTypeName.text);

                  // Fetch all existing food types for the animal
                  var foodTypesFirst = await context.read<GlobalProvider>()
                      .getAllFoodTypesByAnimalId(animalType.animalTypeId!);

                  // Identify food types to remove
                  List foodTypesToRemove = foodTypesFirst["foodTypes"].where((initialFoodType) {
                    return !context.read<GlobalProvider>().selectedFoodTypes.any((selectedFoodType) =>
                    selectedFoodType["foodTypeId"] == initialFoodType.foodTypeId);
                  }).toList();

                  // Delete the food types to remove
                  for (var foodType in foodTypesToRemove) {
                    var responseToDecode = jsonDecode(foodTypesFirst["response"]);
                    for (var foodTypeAnimalTypeToRemove in responseToDecode) {
                      if (foodTypeAnimalTypeToRemove["foodTypeId"] == foodType.foodTypeId) {
                        await context.read<GlobalProvider>().deleteFoodTypeAnimalType(
                            foodTypeAnimalTypeToRemove["foodTypesAnimalsId"]);
                      }
                    }
                  }

                  // Add new selected food types
                  for (var foodType in context.read<GlobalProvider>().selectedFoodTypes) {
                    FoodtypeAnimal foodTypeAnimal = FoodtypeAnimal(
                        animalTypeId: animalType.animalTypeId!,
                        foodTypeId: foodType["foodTypeId"]);
                    await context.read<GlobalProvider>().createFoodTypeAnimalType(foodTypeAnimal);
                  }

                  // Update the animal type and clean up
                  taskManager.editAnimalType(updatedAnimalType, animalType.animalTypeId!);
                  taskManager.cleanSelectedAnimals();
                }
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _editAnimalDialog(
      BuildContext context, GlobalProvider animalManager, Animal animal) {
    animalName.text = animal.name!;
    sicknesses.text = animal.sicknesses!;


    birthDateController.text = DateFormat("yyyy-MM-dd").format(animal.birthDate!) ?? '';
    description.text = animal.description?.toString() ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Edit ${animal.name}",
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.read<GlobalProvider>().buildTextField(
                      animalName, 'Animal Name'),
                  const SizedBox(height: 10),
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
                            children: context.watch<GlobalProvider>().allAnimalTypes.map<Widget>((e) {
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
                  const SizedBox(height: 10),
                  context.read<GlobalProvider>().buildTextField(
                      birthDateController, 'Birth Date',
                      inputType: TextInputType.datetime),
                  const SizedBox(height: 10),
                  context.read<GlobalProvider>().buildTextField(sicknesses, 'Sicknesses'),
                  const SizedBox(height: 10),
                  context.read<GlobalProvider>().buildTextField(
                      description, 'Description'),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (animalName.text.isNotEmpty &&
                    context.read<GlobalProvider>().selectedAnimalType.isNotEmpty) {
                  final updatedAnimal = Animal(
                    name: animalName.text,
                    animalTypeId:
                    context.read<GlobalProvider>().selectedAnimalType["animalTypeId"],
                    birthDate: DateTime.tryParse(
                        birthDateController.text),
                    sicknesses: sicknesses.text,
                    description: description.text,
                  );
                  animalManager.editAnimal(
                      updatedAnimal, animal.animalId!);
                  context.read<GlobalProvider>().cleanSelected();
                  Navigator.pop(context);
                } else {
                  context.read<GlobalProvider>().showSnackBar(
                      'Please fill the required fields', context);
                }
              },
              child: const Text("Save Changes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showFoodTypeSelector(AnimalType animalType) {

    context.read<GlobalProvider>().cleanSelectedAnimals();
    for (var foodType in animalType.foodTypes!) {
      context.read<GlobalProvider>().addToSelectedFoodTypes({
        "foodTypeId": foodType.foodTypeId,
        "name": foodType.name
      });
    }


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final foodTypes = context.watch<GlobalProvider>().allFoodTypes;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Select foodtypes for this animalType',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodTypes.length,
                itemBuilder: (context, index) {
                  final foodType = foodTypes[index];
                  final isSelected = context.watch<GlobalProvider>().selectedFoodTypes
                      .any((u) => u['foodTypeId'] == foodType.foodTypeId);

                  return ListTile(
                    title: Text(foodType.name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () async {
                      if (isSelected) {
                        context.read<GlobalProvider>().removeFromSelectedFoodTypes(foodType.foodTypeId!);
                        animalType.foodTypes = context.read<GlobalProvider>().selectedFoodTypes.map((u) {
                          return FoodType(
                              foodTypeId: u["foodTypeId"],
                              name: u["name"]
                          );
                        }).toList();
                      } else {
                        context.read<GlobalProvider>().addToSelectedFoodTypes({
                          "foodTypeId": foodType.foodTypeId,
                          "name": foodType.name
                        });

                        animalType.foodTypes = context.read<GlobalProvider>().selectedFoodTypes.map((u) {
                          return FoodType(
                              foodTypeId: u["foodTypeId"],
                              name: u["name"]
                          );
                        }).toList();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() async{

    });
  }

}
