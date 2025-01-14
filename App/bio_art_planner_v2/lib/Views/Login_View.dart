import 'dart:async';

import '../models/classes/User.dart';
import '../models/globalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onLoginSuccessUser;
  final VoidCallback onLoginSuccessAdmin;

  const LoginView({
    super.key,
    required this.onLoginSuccessUser,
    required this.onLoginSuccessAdmin,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;
  bool isLoginMode = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    // Focus username field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(usernameFocusNode);
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Fill username and password fields");
      return;
    }

    User user = User(
      username: usernameController.text,
      password: passwordController.text,
      function: isLoginMode ? null : 0, // Function is null for login
    );

    try {
      if (isLoginMode) {
        await _handleLogin(user);
      } else {
        await _handleRegister(user);
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _handleLogin(User user) async {
    try {
      final result = await Future.any([
        context.read<GlobalProvider>().loginUser(user),
        Future.delayed(
          const Duration(seconds: 10),
              () => throw TimeoutException('Login timed out'),
        ),
      ]);

      if (result == true) {
        final role = context.read<GlobalProvider>().currentUser["function"];
        if (role == 1) {
          widget.onLoginSuccessAdmin();
        } else {
          widget.onLoginSuccessUser();
        }
        _clearFields();
      } else {
        throw Exception("Invalid username or password");
      }
    } on TimeoutException {
      _showSnackBar("Login timed out, please try again.");
    }
  }

  Future<void> _handleRegister(User user) async {
    final response = await context.read<GlobalProvider>().createUser(user);
    if (response) {
      await _handleLogin(user); // Automatically login after registration
    } else {
      throw Exception("Registration failed. Try again.");
    }
  }

  void _clearFields() {
    usernameController.clear();
    passwordController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'Close', onPressed: ScaffoldMessenger.of(context).clearSnackBars),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required IconData icon,
    bool isPassword = false,
    TextInputAction action = TextInputAction.done,
    VoidCallback? onSubmit,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword,
      textInputAction: action,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: labelText,
      ),
      onSubmitted: (_) => onSubmit?.call(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: context.watch<GlobalProvider>().isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // App Logo
              Image.asset(
                isLightMode
                    ? 'lib/Assets/bioartlaboratorieslogostaandzwart.png'
                    : 'lib/Assets/bioartlaboratorielLogostaandwit.png',
                width: 300,
                height: 150,
              ),
              const SizedBox(height: 40),

              // Username TextField
              _buildTextField(
                controller: usernameController,
                focusNode: usernameFocusNode,
                labelText: "Username",
                icon: Icons.person,
                action: TextInputAction.next,
                onSubmit: () =>
                    FocusScope.of(context).requestFocus(passwordFocusNode),
              ),
              const SizedBox(height: 20),

              // Password TextField
              _buildTextField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                labelText: "Password",
                icon: Icons.lock,
                isPassword: true,
                action: TextInputAction.done,
                onSubmit: _handleSubmit,
              ),
              const SizedBox(height: 30),

              // Login/Register Button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isLoginMode ? "Login" : "Register"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
