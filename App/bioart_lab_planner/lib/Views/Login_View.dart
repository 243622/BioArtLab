import 'package:bioartlab_planner/models/classes/User.dart';
import 'package:bioartlab_planner/models/globalProvider.dart';
import 'package:bioartlab_planner/models/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLoginSuccessUser;
  final VoidCallback onLoginSuccessAdmin;

  const LoginView(
      {super.key,
      required this.onLoginSuccessUser,
      required this.onLoginSuccessAdmin});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late bool toLogin;
  late bool toRegister;
  late User user;

  void initState() {
    // TODO: implement initState
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    toLogin = true;
    toRegister = false;
    super.initState();
  }

  login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      user = User(
          username: usernameController.text, password: passwordController.text);
      final result = context.read<GlobalProvider>().loginUser(user);
      if (await result == true) {
        final role = context.read<GlobalProvider>().currentUser["function"];
        if (role == 1) {
          widget.onLoginSuccessAdmin();
        } else {
          widget.onLoginSuccessUser();
        }
        usernameController.text = '';
        passwordController.text = '';
      } else {
        print("Login failed");
        showSnackBar(
            "Username or password wrong, try again or create a new account");
        return;
      }
    } else {
      showSnackBar("Fill username and password fields");
    }
  }

  register() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      user = User(
          username: usernameController.text,
          password: passwordController.text,
          function: 0);
      await context.read<GlobalProvider>().createUser(user);
      showSnackBar("Account created");
      login();
    } else {
      showSnackBar("Fill username and password fields");
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (context.watch<GlobalProvider>().isLoading == true) ...[
                CircularProgressIndicator(),
              ] else ...[
                Image.asset(
                  'lib/Assets/BioArtLaboratoriesLogo_Staand_Wit.png',
                  width: 400,
                  height: 200,
                ),
                SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                    ),
                    autofocus: true,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (toLogin)
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.only(left: 55, right: 55)),
                    ),
                    onPressed: login,
                    child: Text("Login"),
                  )
                else if (toRegister)
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.only(left: 55, right: 55)),
                    ),
                    onPressed: register,
                    child: Text("Register"),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15)),
                  ),
                  onPressed: () {
                    setState(() {
                      toRegister = !toRegister;
                      toLogin = !toLogin;
                    });
                  },
                  child: Text(
                      "Want to create account or have an account already?"),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
