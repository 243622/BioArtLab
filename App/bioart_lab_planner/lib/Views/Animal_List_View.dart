import 'package:bioartlab_planner/models/classes/Task.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/classes/Animal.dart';
import '../models/classes/AnimalType.dart';
import '../models/classes/TaskType.dart';

class AnimalListView extends StatefulWidget {
  const AnimalListView({super.key});

  @override
  State<AnimalListView> createState() => _AnimalListViewState();
}

class _AnimalListViewState extends State<AnimalListView> {
  late TextEditingController animalName;
  late TextEditingController birthDateController;
  late TextEditingController sicknesses;
  late TextEditingController description;

  late TextEditingController animalTypeName;

  AnimalType? dropDownValue;
  String selectedFilter = 'Animals';

  @override
  void initState() {
    super.initState();
    animalName = TextEditingController();
    birthDateController = TextEditingController();
    sicknesses = TextEditingController();
    description = TextEditingController();
    animalTypeName = TextEditingController();


  }

  formatDate(DateTime? date) {
    var dateFormat = DateFormat("dd-MM-yyyy");
    if (date != null) {
      var formatedDate = dateFormat.format(date!);
      return formatedDate;
    }
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'Animals', label: Text('Animals')),
              ButtonSegment(value: 'AnimalTypes', label: Text('Animal types')),
            ],
            selected: {selectedFilter},
            onSelectionChanged: (newSelection) {
              setState(() {
                selectedFilter = newSelection.first;
              });
            },
          ),
        ),
        Expanded(
          child: Consumer<GlobalProvider>(
            builder: (context, taskManager, child) {
              List toShow;

              // Apply filter based on selectedFilter value
              if (selectedFilter == 'Animals') {
                toShow = taskManager.allAnimals;
              } else if (selectedFilter == 'AnimalTypes') {
                toShow = taskManager.allAnimalTypes;
              }
              else {
                toShow = taskManager.allAnimals; // Default to all tasks
              }

              return ListView.separated(
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
                                //!TODO maak hier de edit dialog
                                _editAnimalDialog(context, taskManager, item);
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
                          collapsedBackgroundColor: Colors.grey[850],
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Text(item.animalId.toString()),
                          subtitle: Text(item.animalTypeInString.toString()),
                          title: Text(
                            item.name.toString(),
                            style: const TextStyle(color: Colors.white),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description: ${item.description ?? 'No description'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Animaltype: ${item.animalTypeInString ?? 'No tasktype'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Priority: ${item.sicknesses ?? 'N/A'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Birth: ${item.birthDate != null ? item.birthDate.toString() : 'No deadline'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () async{
                              final response = await taskManager.deleteAnimalType(item.animalTypeId!);
                              if(response != true){
                                showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                return;
                              }

                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) async{
                                final response = await taskManager.deleteAnimalType(item.animalTypeId!);
                                if(response != true){
                                  showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                  return;
                                }
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                //!TODO Maak hier de edit dialog
                                _editAnimalTypeDialog(context, taskManager,item );
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Container(
                          color: Colors.grey[850],
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Text(item.animalTypeId.toString()),
                            title: Text(
                              item.name.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(color: Colors.transparent, height: 10),
                itemCount: toShow.length,
              );
            },
          ),
        ),
      ],
    );
  }

  void _editAnimalTypeDialog(
      BuildContext context, GlobalProvider taskManager, AnimalType animalType) {
    animalTypeName.text = animalType.name!;

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
                  _buildTextField(
                      animalTypeName, 'Edit task type name (required)'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(animalTypeName.text.isNotEmpty){
                  AnimalType updatedAnimalType = AnimalType(name: animalTypeName.text);
                  taskManager.editAnimalType(updatedAnimalType, animalType.animalTypeId!);
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
    birthDateController.text = animal.birthDate?.toString() ?? '';
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
              TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      animalName, 'Animal Name'),
                  const SizedBox(height: 10),
                  DropdownMenu<AnimalType>(
                    initialSelection: null,
                    dropdownMenuEntries: context
                        .watch<GlobalProvider>()
                        .allAnimalTypes
                        .map<DropdownMenuEntry<AnimalType>>(
                            (AnimalType e) {
                          return DropdownMenuEntry<AnimalType>(
                            value: e,
                            label: e.name,
                          );
                        }).toList(),
                    hintText: "Select animal type",
                    // Text to show when nothing is selected
                    onSelected: (AnimalType? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                      birthDateController, 'Birth Date',
                      inputType: TextInputType.datetime),
                  const SizedBox(height: 10),
                  _buildTextField(sicknesses, 'Sicknesses'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      description, 'Description'),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (animalName.text.isNotEmpty &&
                    dropDownValue != null) {
                  final updatedAnimal = Animal(
                    name: animalName.text,
                    animalTypeId:
                    dropDownValue?.animalTypeId,
                    birthDate: DateTime.tryParse(
                        birthDateController.text),
                    sicknesses: sicknesses.text,
                    description: description.text,
                  );
                  animalManager.editAnimal(
                      updatedAnimal, animal.animalId!);
                  Navigator.pop(context);
                } else {
                  showSnackBar(
                      'Please fill the required fields');
                }
              },
              child: Text("Save Changes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
