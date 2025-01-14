import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '/models/globalProvider.dart';
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
      heroTag: "UserFab",
      child: const Icon(Icons.animation),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            var provider = context.read<GlobalProvider>();
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
                    const SizedBox(height: 5),
                    provider.buildTextField(usernameController, 'Username (required)'),
                    const SizedBox(height: 5),
                    provider.buildTextField(passwordController, 'Password (optional)', isPassword: true),
                    const SizedBox(height: 5),
                    provider.buildOption(icon: Icons.person, label: context.watch<GlobalProvider>().selectedFunction.toString() != "null" ? context.watch<GlobalProvider>().selectedFunction.toString() : "select a function",
                        onTap: (
                            ){
                          showModalBottomSheet(context: context, builder: (BuildContext context) {
                            final functions = context.watch<GlobalProvider>().userFunctions;
                            return ListView.builder(
                              itemCount: functions.length,
                              itemBuilder: (context, index) {
                                final function = functions[index];
                                return ListTile(
                                  title: Text(function["label"]),
                                  onTap: () {
                                    context.read<GlobalProvider>().setSelectedFunction(function["value"]);
                                    Navigator.pop(context); // Close the bottom sheet
                                  },
                                );
                              },
                            );
                          });
                        }),
                    const SizedBox(height: 15),
                    Consumer<GlobalProvider>(
                      builder: (context, userManager, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty)
                            {
                              final newUser = User(
                               username: usernameController.text,
                                password: passwordController.text,
                                function: userManager.selectedFunction
                              );

                              userManager.createUser(newUser); // Assuming createAnimal is defined
                              Navigator.pop(context);
                              usernameController.clear();
                              passwordController.clear();
                            }
                            else{
                              userManager.showSnackBar("Please fill the required fields", context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Add user"),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ).whenComplete(() {
          keyToClose.currentState?.toggle();
          //context.read<GlobalProvider>().cleanSelected();
          });
      },
    );
  }
}
