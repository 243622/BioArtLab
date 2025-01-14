import 'package:bioartlab_planner/models/classes/AnimalType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
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

  AnimalType? dropDownValue;
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
      child: Icon(Icons.animation),
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
                    const SizedBox(height: 20),
                    _buildTextField(nameController, 'Animal Name (required)'),
                    const SizedBox(height: 15),
                    DropdownMenu<AnimalType>(
                      initialSelection: null,
                      dropdownMenuEntries: context.watch<GlobalProvider>().allAnimalTypes.map<DropdownMenuEntry<AnimalType>>((AnimalType e) {
                        return DropdownMenuEntry<AnimalType>(
                          value: e,
                          label: e.name,
                        );
                      }).toList(),
                      hintText: "Select animal type", // Text to show when nothing is selected
                      onSelected: (AnimalType? newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(sicknessesController, 'Sicknesses (optional)', maxLines: 2),
                    const SizedBox(height: 15),
                    _buildTextField(descriptionController, 'Description (optional)', maxLines: 3),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        birthDate = await _pickDateTime(context, initialDate: birthDate);
                      },
                      child: Text(birthDate == null ? 'Pick Birth Date' : 'Change Birth Date'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<GlobalProvider>(
                      builder: (context, animalManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if(nameController.text.isNotEmpty)
                            {
                              final newAnimal = Animal(
                                name: nameController.text,
                                animalTypeId: dropDownValue?.animalTypeId,
                                birthDate: birthDate,
                                sicknesses: sicknessesController.text,
                                description: descriptionController.text,
                              );

                              animalManager.createAnimal(newAnimal); // Assuming createAnimal is defined
                              Navigator.pop(context);
                              nameController.clear();
                              dropDownValue = null;
                              sicknessesController.clear();
                              descriptionController.clear();
                            }
                            else{
                              showSnackBar("Please fill the required fields");
                            }
                          },
                          child: const Text("Add Animal"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<DateTime?> _pickDateTime(BuildContext context, {DateTime? initialDate}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    return date;
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  void closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
