import 'package:bioartlab_planner/models/classes/Stock.dart';
import 'package:bioartlab_planner/models/classes/Task.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/classes/Animal.dart';
import '../models/classes/AnimalType.dart';
import '../models/classes/FoodType.dart';
import '../models/classes/TaskType.dart';

class StockListView extends StatefulWidget {
  const StockListView({super.key});

  @override
  State<StockListView> createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  late TextEditingController stockQuantity;
  late TextEditingController stockMinimumQuantity;
  
  late TextEditingController foodTypeName;

  FoodType? dropDownValue;
  
  String selectedFilter = 'Stocks';

  @override
  void initState() {
    super.initState();
    stockQuantity = TextEditingController();
    stockMinimumQuantity = TextEditingController();
    foodTypeName = TextEditingController();
    
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
                  value: 'Stocks', label: Text('Stocks')),
              ButtonSegment(value: 'Foodtypes', label: Text('Food types')),
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
            builder: (context, stockManager, child) {
              List toShow;

              // Apply filter based on selectedFilter value
              if (selectedFilter == 'Stocks') {
                toShow = stockManager.allStocks;
              } else if (selectedFilter == 'Foodtypes') {
                toShow = stockManager.allFoodTypes;
              }
              else {
                toShow = stockManager.allStocks; // Default to all tasks
              }

              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  var item = toShow[index];
                  if (item is Stock) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              stockManager.deleteStock(item.stockId!);
                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                stockManager.deleteStock(item.stockId!);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                //!TODO maak hier de edit dialog
                                _editStockDialog(context, stockManager, item);
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
                          leading: Text(item.stockId.toString()),
                          subtitle: Text(item.foodTypeInString.toString()),
                          title: Text(
                            item.quantity.toString(),
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
                                    "Description: ${item.quantity ?? 'No description'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Animaltype: ${item.foodTypeInString ?? 'No tasktype'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Priority: ${item.minimumQuantity ?? 'N/A'}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (item is FoodType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () async{
                              final response = await stockManager.deleteFoodType(item.foodTypeId!);
                              if(response != true){
                                showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                return;
                              }

                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) async{
                                final response = await stockManager.deleteFoodType(item.foodTypeId!);
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
                                _editFoodTypeDialog(context, stockManager,item );
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
                            leading: Text(item.foodTypeId.toString()),
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

  void _editFoodTypeDialog(
      BuildContext context, GlobalProvider stockManager, FoodType foodType) {
    foodTypeName.text = foodType.name!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${foodType.name}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      foodTypeName, 'Edit animal type name (required)'),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(foodTypeName.text.isNotEmpty){
                  FoodType updatedFoodType = FoodType(name: foodTypeName.text);
                  stockManager.editFoodType(updatedFoodType, foodType.foodTypeId!);
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

  void _editStockDialog(
      BuildContext context, GlobalProvider stockManager, Stock stock) {
    stockQuantity.text = stock.quantity!.toString();
    stockMinimumQuantity.text = stock.minimumQuantity!.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Edit ${stock.foodTypeInString}",
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
                      stockQuantity, 'Stock quantity'),
                  const SizedBox(height: 10),
                  DropdownMenu<FoodType>(
                    initialSelection: null,
                    dropdownMenuEntries: context
                        .watch<GlobalProvider>()
                        .allFoodTypes
                        .map<DropdownMenuEntry<FoodType>>(
                            (FoodType e) {
                          return DropdownMenuEntry<FoodType>(
                            value: e,
                            label: e.name,
                          );
                        }).toList(),
                    hintText: "Select animal type",
                    // Text to show when nothing is selected
                    onSelected: (FoodType? newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                      stockMinimumQuantity, 'Minimum quantity',
                      inputType: TextInputType.number),
                  const SizedBox(height: 10)
              ]
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (stockQuantity.text.isNotEmpty &&
                    dropDownValue != null) {
                  final updatedStock = Stock(
                     quantity: int.tryParse(stockQuantity.text),
                    minimumQuantity: int.tryParse(stockMinimumQuantity.text),
                    foodTypeId: dropDownValue?.foodTypeId
                  );
                  stockManager.editStock(
                      updatedStock, stock.stockId!);
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
