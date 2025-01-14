import '/models/classes/FoodType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';
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
      heroTag: "StockFab",
      child: const Icon(Icons.manage_history),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    const SizedBox(height: 10),
                    context.read<GlobalProvider>().buildTextField(stockQuantity, 'Stock quantity(required)', inputType: TextInputType.number),
                    const SizedBox(height: 10),
                    DropdownMenu<FoodType>(
                      width: 500,
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
                    context.read<GlobalProvider>().buildTextField(stockMinimumQuantity, 'Stock minimum-quantity(required)', inputType: TextInputType.number),
                    const SizedBox(height: 10),
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
                                      stockManager.showSnackBar("Fill de required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add Stock"),
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


}

