import 'package:flutter/material.dart';
import 'package:reactive_programming/core/type_definitions.dart';
import 'package:reactive_programming/helpers/if_debugging.dart';

class RegisterView extends StatefulWidget {
  final RegisterFunction register;
  final VoidCallback gotoLoginView;

  const RegisterView({
    super.key,
    required this.register,
    required this.gotoLoginView,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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

                    widget.register(email, password);
                  },
                  child: const Text("Register"),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: widget.gotoLoginView,
                  child: const Text("Already registered? Log in here!"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
