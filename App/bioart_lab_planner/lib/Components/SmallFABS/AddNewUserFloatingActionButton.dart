import 'package:bioartlab_planner/models/classes/AnimalType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import '../../models/classes/Animal.dart';
import '../../models/classes/User.dart'; // Assuming this file exists and contains the Animal model

class AddNewUserFloatingActionButton extends StatefulWidget {
  final GlobalKey<ExpandableFabState> keyFab;
  const AddNewUserFloatingActionButton({
    super.key,
    required this.keyFab
  });

  @override
  State<AddNewUserFloatingActionButton> createState() => _AddNewUserFloatingActionButtonState();
}

class _AddNewUserFloatingActionButtonState extends State<AddNewUserFloatingActionButton> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController functionController;

  late GlobalKey<ExpandableFabState> keyToClose;


  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    functionController = TextEditingController();
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
                          'Add New User',
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
                    _buildTextField(usernameController, 'Username (required)'),
                    const SizedBox(height: 15),
                    _buildTextField(passwordController, 'Password (optional)'),
                    const SizedBox(height: 15),
                    _buildTextField(functionController, 'Function (optional)', inputType: TextInputType.number),
                    const SizedBox(height: 15),
                    Consumer<GlobalProvider>(
                      builder: (context, userManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && functionController.text.isNotEmpty)
                            {
                              final newUser = User(
                               username: usernameController.text,
                                password: passwordController.text,
                                function: int.tryParse(functionController.text)
                              );

                              userManager.createUser(newUser); // Assuming createAnimal is defined
                              Navigator.pop(context);
                              usernameController.clear();
                              passwordController.clear();
                              functionController.clear();
                            }
                            else{
                              showSnackBar("Please fill the required fields");
                            }
                          },
                          child: const Text("Add user"),
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


  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: closeSnackBar)));
  }

  void closeSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
