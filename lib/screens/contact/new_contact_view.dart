import 'package:flutter/material.dart';
import 'package:reactive_programming/core/type_definitions.dart';
import 'package:reactive_programming/helpers/if_debugging.dart';

class NewContactView extends StatefulWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;

  const NewContactView({
    super.key,
    required this.createContact,
    required this.goBack,
  });

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  final firstNameController = TextEditingController(
    text: "Alexander".ifDebugging,
  );
  final lastNameController = TextEditingController(
    text: "Nitiola".ifDebugging,
  );
  final phoneNumberController = TextEditingController(
    text: "+2348035001321".ifDebugging,
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.goBack,
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    hintText: "First name...",
                  ),
                  keyboardType: TextInputType.name,
                  keyboardAppearance: Brightness.dark,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    hintText: "Last name...",
                  ),
                  keyboardType: TextInputType.name,
                  keyboardAppearance: Brightness.dark,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: "Phone number...",
                  ),
                  keyboardType: TextInputType.phone,
                  keyboardAppearance: Brightness.dark,
                ),
                TextButton(
                  onPressed: () {
                    final firstName = firstNameController.text;
                    final lastName = lastNameController.text;
                    final phoneNumber = phoneNumberController.text;

                    // create contact ->
                    widget.createContact(firstName, lastName, phoneNumber);
                    // after creating a contact, go
                    // back to the previous screen
                    widget.goBack();
                  },
                  child: const Text("Save Contact"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
