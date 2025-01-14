import 'dart:async';
import 'dart:convert';

import 'package:bio_art_planner_v2/models/classes/AnimalType.dart';
import 'package:bio_art_planner_v2/models/classes/many_many/Foodtype_Animal.dart';

import '../../models/classes/Stock.dart';
import '../../models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/classes/FoodType.dart';
import '../../models/services/NotificationService.dart';

class StockListView extends StatefulWidget {
  const StockListView({super.key});

  @override
  State<StockListView> createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late ScrollController scrollController;

  late TextEditingController stockQuantity;
  late TextEditingController stockMinimumQuantity;
  late TextEditingController foodTypeName;
  int limit = 8;
  FoodType? dropDownValue;

  String selectedFilter = 'Stocks';

  @override
  void initState() {
    super.initState();
    stockQuantity = TextEditingController();
    stockMinimumQuantity = TextEditingController();
    foodTypeName = TextEditingController();

    scrollController = ScrollController();

    scrollController.addListener(onScroll);
  }
  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      refreshIndicatorKey.currentState?.show();

      limit += 8;
      getStocksBySelected();
    }
  }
  Future<void> getStocksBySelected({int maxRetries = 5, Duration timeout = const Duration(seconds: 10)}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Attempt to fetch tasks with a timeout
        await Future.any([
          getStocksBySelectedInternal(), // The actual fetch logic
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

  Future<void> getStocksBySelectedInternal() async{
    if(selectedFilter == "Stocks"){
      await context.read<GlobalProvider>().getAllStocks(limit);
    }
    else if(selectedFilter == "FoodTypes"){
      await context.read<GlobalProvider>().getAllFoodTypes();
    }
    else{
      await context.read<GlobalProvider>().getAllStocks(limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: getStocksBySelected,
      child: Column(
        children: [
          // Filter Toggle Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Stocks', label: Text('Stocks')),
                ButtonSegment(value: 'FoodTypes', label: Text('Food types')),
              ],
              selected: {selectedFilter},
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedFilter = newSelection.first;
                });
              },
            ),
          ),
          // Content View
          Expanded(
            child: FutureBuilder(
              future: getStocksBySelected(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error);
                } else {
                  return Consumer<GlobalProvider>(
                    builder: (context, stockManager, child) {
                      final filteredData = _applyFilter(stockManager);

                      return _buildListView(filteredData, stockManager);
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

// Error Widget
  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: getStocksBySelected,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

// Filter Logic
  List _applyFilter(GlobalProvider stockManager) {
    if (selectedFilter == 'Stocks') {
      return stockManager.allStocks..sort(_sortStocks);
    } else if (selectedFilter == 'FoodTypes') {
      return stockManager.allFoodTypes;
    }
    return [];
  }

// Sort Stocks
  int _sortStocks(dynamic a, dynamic b) {
    if (a is Stock && b is Stock) {
      final aMinReached = a.quantity != null && a.minimumQuantity != null && a.quantity! <= a.minimumQuantity!;
      final bMinReached = b.quantity != null && b.minimumQuantity != null && b.quantity! <= b.minimumQuantity!;
      return aMinReached && !bMinReached
          ? -1
          : !aMinReached && bMinReached
          ? 1
          : 0;
    }
    return 0;
  }

// Build ListView
  Widget _buildListView(List data, GlobalProvider stockManager) {
    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        final item = data[index];
        if (item is Stock) {
          return _buildStockTile(context, stockManager, item);
        } else if (item is FoodType) {
          return _buildFoodTypeTile(context, stockManager, item);
        }
        return const SizedBox();
      },
      separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 10),
      itemCount: data.length,
    );
  }

// Stock Tile
  Widget _buildStockTile(BuildContext context, GlobalProvider stockManager, Stock stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => stockManager.deleteStock(stock.stockId!),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (_) => _editStockDialog(context, stockManager, stock),
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          collapsedBackgroundColor: _getStockBackgroundColor(stock, context),
          backgroundColor: _getStockBackgroundColor(stock, context, collapsed: false),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Text(stock.stockId.toString()),
          title: Text(stock.foodTypeInString ?? 'Unknown'),
          subtitle: Text('Quantity: ${stock.quantity ?? 0}'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
          children: [
            _buildStockDetails(stock),
          ],
        ),
      ),
    );
  }

// Stock Background Color
  Color _getStockBackgroundColor(Stock stock, BuildContext context, {bool collapsed = true}) {
    final reachedMin = (stock.quantity ?? 0) <= (stock.minimumQuantity ?? 0);
    if (reachedMin) {
      return collapsed ? Colors.red.shade600 : Colors.red.shade400;
    }
    return Theme.of(context).brightness == Brightness.light
        ? (collapsed ? Colors.grey[350]! : Colors.grey[200]!)
        : (collapsed ? Colors.grey[850]! : Colors.grey[900]!);
  }


  void _editStockDialog(BuildContext context, GlobalProvider stockManager,
      Stock stock) {
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
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                stockManager.buildTextField(stockQuantity, 'Stock quantity', labelBehavior: FloatingLabelBehavior.always, inputType: TextInputType.number),
                const SizedBox(height: 10),
                DropdownMenu<FoodType>(
                  width: 500,
                  initialSelection: null,
                  dropdownMenuEntries: context
                      .watch<GlobalProvider>()
                      .allFoodTypes
                      .map<DropdownMenuEntry<FoodType>>((FoodType e) {
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
                stockManager.buildTextField(
                    stockMinimumQuantity, 'Minimum quantity', labelBehavior: FloatingLabelBehavior.always,
                    inputType: TextInputType.number),
                const SizedBox(height: 10)
              ]),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async{
                if (stockQuantity.text.isNotEmpty && dropDownValue != null) {
                  final updatedStock = Stock(
                      quantity: int.tryParse(stockQuantity.text),
                      minimumQuantity: int.tryParse(stockMinimumQuantity.text),
                      foodTypeId: dropDownValue?.foodTypeId);
                  stockManager.editStock(updatedStock, stock.stockId!);
                  if(updatedStock.minimumQuantity! <= stock.quantity!){
                    NotificationService().showNotification(0, "Stock: ${stock.foodTypeInString}, moet bijbesteld worden", "Stocks current quantity: ${stock.quantity}, minimum allowed: ${stock.minimumQuantity}", null);
                  }

                  Navigator.pop(context);
                } else {
                  stockManager.showSnackBar('Please fill the required fields', context);
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
  void showAnimalTypeSelector(FoodType foodType) {

    context.read<GlobalProvider>().cleanSelectedAnimals();
    for (var animalType in foodType.animalTypes!) {
      context.read<GlobalProvider>().addToSelectedAnimalTypes({
        "animalTypeId": animalType.animalTypeId,
        "name": animalType.name
      });
    }
    }

// Stock Details
  Widget _buildStockDetails(Stock stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quantity: ${stock.quantity ?? 'No description'}"),
          Text("Food Type: ${stock.foodTypeInString ?? 'Unknown'}"),
          Text("Minimum Quantity: ${stock.minimumQuantity ?? 'N/A'}"),
        ],
      ),
    );
  }

// FoodType Tile (Similar to StockTile)
  Widget _buildFoodTypeTile(
      BuildContext context, GlobalProvider stockManager, FoodType foodType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () async {
              final response = await stockManager.deleteFoodType(foodType.foodTypeId!);
              if (response != true) {
                stockManager.showSnackBar(
                  "Please remove all stocks associated with this food type first.",
                  context,
                );
                return;
              }
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) async {
                final response = await stockManager.deleteFoodType(foodType.foodTypeId!);
                if (response != true) {
                  stockManager.showSnackBar(
                    "Please remove all stocks associated with this food type first.",
                    context,
                  );
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
                _editFoodTypeDialog(context, stockManager, foodType);
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          collapsedBackgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[350]
              : Colors.grey[850],
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Text(foodType.foodTypeId.toString()),
          title: Text(
            foodType.name,
            style: const TextStyle(),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white70,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodType.animalTypes != null && foodType.animalTypes!.isNotEmpty
                        ? "For Animals: ${foodType.animalTypes!.map((e) => e.name).join(', ')}"
                        : "No Associated Animals",
                    style: const TextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _editFoodTypeDialog(BuildContext context, GlobalProvider stockManager,
      FoodType foodType) {
    foodTypeName.text = foodType.name;

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
                  stockManager.buildTextField(
                      foodTypeName, 'Edit animal type name (required)'),
                  const SizedBox(height: 10),
                  context.watch<GlobalProvider>().buildOption(icon: Icons.key,
                      label: (foodType.animalTypes != null && foodType.animalTypes!.isNotEmpty)
                          ? foodType.animalTypes!.map((e) => e.name).join(', ')
                          : "Connect animalType (Optional)",
                      onTap: (){showAnimalTypeSelector(foodType);}),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async{
                if (foodTypeName.text.isNotEmpty) {
                  FoodType updatedFoodType = FoodType(name: foodTypeName.text);

                  var animalTypesFirst = await context.read<GlobalProvider>()
                      .getAllAnimalTypesByFoodTypeId(foodType.foodTypeId!);

                  List animalTypeToRemove = animalTypesFirst["animalTypes"].where((initialAnimalType) {
                    return context.read<GlobalProvider>().selectedAnimalTypes.any((selectedAnimalType) =>
                    selectedAnimalType["animalTypeId"] == initialAnimalType.animalTypeId);
                  }).toList();


                  for (var animalType in animalTypeToRemove) {
                    for (var animalTypeV in animalTypesFirst["animalTypes"]) {
                      if (animalType.animalTypeId == animalTypeV.animalTypeId) {
                        var responseToDecode = jsonDecode(
                            animalTypesFirst["response"]);
                        for (var foodTypeAnimalTypeToRemove in responseToDecode) {
                          await context.read<GlobalProvider>().deleteFoodTypeAnimalType(
                              foodTypeAnimalTypeToRemove["foodTypesAnimalsId"]);
                        }
                      }
                    }
                  }
                  for (var animalType in context.read<GlobalProvider>().selectedAnimalTypes) {
                    FoodtypeAnimal foodTypeAnimal = FoodtypeAnimal(
                        animalTypeId: animalType["animalTypeId"], foodTypeId: foodType.foodTypeId!);
                    await context.read<GlobalProvider>().createFoodTypeAnimalType(
                        foodTypeAnimal);
                  }

                  stockManager.editFoodType(updatedFoodType, foodType.foodTypeId!);
                  stockManager.cleanSelectedAnimals();
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

}
