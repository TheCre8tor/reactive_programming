import 'package:flutter/material.dart';
import 'package:reactive_programming/core/type_definitions.dart';
import 'package:reactive_programming/helpers/if_debugging.dart';

class LoginView extends StatefulWidget {
  final LoginFunction login;
  final VoidCallback gotoRegisterView;

  const LoginView({
    super.key,
    required this.login,
    required this.gotoRegisterView,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController(
    text: "alexander@gmail.com".ifDebugging,
  );

  final passwordController = TextEditingController(
    text: "test@1234".ifDebugging,
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Enter your email here...",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.dark,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Enter your password here...",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  keyboardAppearance: Brightness.dark,
                  obscureText: true,
                  obscuringCharacter: "*",
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    widget.login(email, password);
                  },
                  child: const Text("Log in"),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: widget.gotoRegisterView,
                  child: const Text("Not registered yet? Register here!"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
