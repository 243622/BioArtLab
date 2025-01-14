import 'package:bioartlab_planner/models/classes/FoodType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import '../../models/classes/Stock.dart';

class AddNewStockFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;

  const AddNewStockFloatingActionButton({
    super.key,
    required this.keyFab

  });

  @override
  State<AddNewStockFloatingActionButton> createState() => _AddNewStockFloatingActionButtonState();
}

class _AddNewStockFloatingActionButtonState extends State<AddNewStockFloatingActionButton> {
  late TextEditingController stockQuantity;
  late TextEditingController stockMinimumQuantity;
  late GlobalKey<ExpandableFabState> keyToClose;

  FoodType? dropDownValue;
  @override
  void initState() {
    super.initState();
    stockMinimumQuantity = TextEditingController();
    stockQuantity = TextEditingController();
    keyToClose = widget.keyFab;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      child: Icon(Icons.manage_history),
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
                          'Add New Stock',
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
                    _buildTextField(stockQuantity, 'Stock quantity(required)', inputType: TextInputType.number),
                    const SizedBox(height: 15),
                    DropdownMenu<FoodType>(
                      initialSelection: null,
                      dropdownMenuEntries: context.watch<GlobalProvider>().allFoodTypes.map<DropdownMenuEntry<FoodType>>((FoodType e) {
                        return DropdownMenuEntry<FoodType>(
                          value: e,
                          label: e.name,
                        );
                      }).toList(),
                      hintText: "Select food type", // Text to show when nothing is selected
                      onSelected: (FoodType? newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                    ),                    const SizedBox(height: 15),
                    _buildTextField(stockMinimumQuantity, 'Stock minimum-quantity(required)', inputType: TextInputType.number),
                    const SizedBox(height: 15),
                    Consumer<GlobalProvider>(
                      builder: (context, stockManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if(stockQuantity.text.isNotEmpty && stockMinimumQuantity.text.isNotEmpty && dropDownValue != null)
                              {
                                final newStock = Stock(
                                  quantity: int.tryParse(stockQuantity.text),
                                  foodTypeId: dropDownValue?.foodTypeId,
                                  minimumQuantity: int.tryParse(stockMinimumQuantity.text)
                                );

                                stockManager.createStock(newStock);
                                Navigator.pop(context);
                                stockQuantity.clear();
                                stockMinimumQuantity.clear();
                              }
                              else{
                                      showSnackBar("Fill de required fields");
                            }
                          },
                          child: const Text("Add Stock"),
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
        ).whenComplete(() =>  keyToClose.currentState?.toggle());
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
  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

