import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/classes/User.dart';
import '../../models/globalProvider.dart';

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

  Future<void> fetchUsers(
      {int maxRetries = 5, Duration timeout = const Duration(
          seconds: 10)}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Attempt to fetch tasks with a timeout
        await Future.any([
          fetchUsersInternal(), // The actual fetch logic
          Future.delayed(
              timeout, () => throw TimeoutException("Fetch tasks timed out"))
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

  Future<void> fetchUsersInternal() async {
    if (selectedFilter == "Users") {
      await context.read<GlobalProvider>().getAllUsers();
    }
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchUsers,
      child: Column(
        children: [
          _buildSegmentedButton(),
          Expanded(
            child: FutureBuilder<void>(
              future: fetchUsers(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(context);
                } else {
                  return _buildUserList(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

// Builds the segmented button for filtering
  Widget _buildSegmentedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Users', label: Text('Users')),
          ButtonSegment(value: 'Functions', label: Text('User functions')),
        ],
        selected: {selectedFilter},
        onSelectionChanged: (newSelection) {
          setState(() {
            selectedFilter = newSelection.first;
          });
        },
      ),
    );
  }

// Error widget when FutureBuilder encounters an error
  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fetchUsers,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

// Builds the user list based on the selected filter
  Widget _buildUserList(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, userManager, child) {
        final List toShow = _getFilteredUsers(userManager);

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var item = toShow[index];
            if (item is User) {
              return _buildUserTile(context, userManager, item);
            }
            return null;
          },
          separatorBuilder: (context, index) =>
          const Divider(height: 10, color: Colors.transparent),
          itemCount: toShow.length,
        );
      },
    );
  }

// Filters the user list based on selectedFilter
  List _getFilteredUsers(GlobalProvider userManager) {
    if (selectedFilter == 'Users') {
      return userManager.allUsers;
    } else if (selectedFilter == 'Functions') {
      return userManager.allUsers; // TODO: Replace with functions
    } else {
      return userManager.allUsers;
    }
  }

// Builds a single user tile
  Widget _buildUserTile(BuildContext context, GlobalProvider userManager,
      User item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () => userManager.deleteUser(item.userId!),
          ),
          children: [
            _buildSlidableAction(
              context,
              icon: Icons.delete,
              color: Colors.red,
              label: 'Delete',
              onTap: () => userManager.deleteUser(item.userId!),
            ),
            _buildSlidableAction(
              context,
              icon: Icons.edit,
              color: Colors.blue,
              label: 'Edit',
              onTap: () => _editUserDialog(context, userManager, item),
            ),
          ],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 10),
          collapsedBackgroundColor: _getTileBackgroundColor(
              context, isCollapsed: true),
          backgroundColor: _getTileBackgroundColor(context, isCollapsed: false),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          leading: CircleAvatar(child: Text(item.username![0])),
          title: Text(item.username.toString()),
          subtitle: Text(item.function.toString()),
          trailing: const Icon(
              Icons.arrow_forward_ios_rounded, color: Colors.white70),
          children: const [
            Padding(padding: EdgeInsets.all(10), child: Text('User Details'))
          ],
        ),
      ),
    );
  }

// Slidable action button
  Widget _buildSlidableAction(BuildContext context,
      {required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return SlidableAction(
      onPressed: (context) => onTap(),
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: label,
    );
  }

// Determines tile background color based on theme
  Color _getTileBackgroundColor(BuildContext context,
      {required bool isCollapsed}) {
    final brightness = Theme
        .of(context)
        .brightness;
    return brightness == Brightness.light
        ? (isCollapsed ? Colors.grey[350]! : Colors.grey[200]!)
        : (isCollapsed ? Colors.grey[850]! : Colors.grey[900]!);
  }

  void _editUserDialog(BuildContext context, GlobalProvider userManager,
      User user) {
    usernameController.text = user.username!;
    passwordController.text = user.password!;

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
                  userManager.buildTextField(
                      usernameController, 'Edit username (required)'),
                  const SizedBox(height: 5),
                  userManager.buildTextField(
                      passwordController, 'Edit password (required)',
                      inputType: TextInputType.text, isPassword: true),
                  const SizedBox(height: 5),
                  userManager.buildOption(icon: Icons.person, label: context
                      .watch<GlobalProvider>()
                      .selectedFunction
                      .toString() != "null" ? context
                      .watch<GlobalProvider>()
                      .selectedFunction
                      .toString() : "select a function",
                      onTap: () {
                        showModalBottomSheet(
                            context: context, builder: (BuildContext context) {
                          final functions = context
                              .watch<GlobalProvider>()
                              .userFunctions;
                          return ListView.builder(
                            itemCount: functions.length,
                            itemBuilder: (context, index) {
                              final function = functions[index];
                              return ListTile(
                                title: Text(function["label"]),
                                onTap: () {
                                  context.read<GlobalProvider>()
                                      .setSelectedFunction(function["value"]);
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                },
                              );
                            },
                          );
                        });
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  User updatedUser = User(
                      username: usernameController.text,
                      password: passwordController.text,
                      function: userManager.selectedFunction ?? 0
                  );
                  userManager.editUser(updatedUser, user.userId!);
                }
                else {
                  userManager.showSnackBar("Fill the required fields", context);
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
    ).whenComplete(() => userManager.cleanSelected());
  }
}
