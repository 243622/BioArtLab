import 'package:bioartlab_planner/models/classes/Task.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/classes/TaskType.dart';
import '../models/classes/User.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController userFunction;

  String selectedFilter = 'Users';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    userFunction = TextEditingController();
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
                  value: 'Users', label: Text('Users')),
              ButtonSegment(value: 'Functions', label: Text('User functions')),
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
            builder: (context, userManager, child) {
              List toShow;

              // Apply filter based on selectedFilter value
              if (selectedFilter == 'Users') {
                toShow = userManager.allUsers;
              } else if (selectedFilter == 'Functions') {
                toShow = userManager.allUsers; //!TODO Hier de functies laten zien
              }else {
                toShow = userManager.allUsers; // Default to all tasks
              }

              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  var item = toShow[index];
                  if (item is User) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              userManager.deleteUser(item.userId!);
                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                userManager.deleteUser(item.userId!);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                _editUserDialog(context, userManager, item);
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
                          leading: CircleAvatar(child: Text(item.username![0]),),
                          subtitle: Text(item.function.toString()),
                          title: Text(
                            item.username.toString(),
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

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (item is TaskType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Slidable(
                        key: UniqueKey(),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(
                            onDismissed: () async{
                              final response = await userManager.deleteTaskType(item.taskTypeId!);
                              if(response != true){
                                showSnackBar("Verwijder eerst alle aan de taskType gekoppelde tasks");
                                return;
                              }

                            },
                          ),
                          children: [
                            SlidableAction(
                              onPressed: (context) async{
                                final response = await userManager.deleteTaskType(item.taskTypeId!);
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
                                //_editTaskTypeDialog(context, taskManager,item );
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
                            leading: Text(item.taskTypeId.toString()),
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

  // void _editTaskTypeDialog(
  //     BuildContext context, GlobalProvider taskManager, TaskType taskType) {
  //   taskTypeName.text = taskType.name!;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape:
  //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         title: Text("Edit ${taskType.name}",
  //             style: const TextStyle(fontWeight: FontWeight.bold)),
  //         content: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 _buildTextField(
  //                     taskTypeName, 'Edit task type name (required)'),
  //                 const SizedBox(height: 10),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               if(taskTypeName.text.isNotEmpty){
  //                 TaskType updatedTask = TaskType(name: taskTypeName.text);
  //                 taskManager.editTaskType(updatedTask, taskType.taskTypeId!);
  //               }
  //               Navigator.pop(context);
  //             },
  //             child: const Text("Save Changes"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _editUserDialog(
      BuildContext context, GlobalProvider userManager, User user) {
    usernameController.text = user.username!;
    userFunction.text = user.function?.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit ${user.username}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      usernameController, 'Edit username (required)'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      passwordController, 'Edit password (required)'),
                  const SizedBox(height: 10),
                  _buildTextField(
                      userFunction, 'Edit function (required)',
                      inputType: TextInputType.number),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && userFunction.text.isNotEmpty){
                  User updatedUser = User(
                    username: usernameController.text,
                    password: passwordController.text,
                    function: int.tryParse(userFunction.text)
                  );

                  userManager.editUser(updatedUser, user.userId!);
                }
                else{
                  showSnackBar("Fill the required fields");
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
