import 'package:flutter/material.dart';
import 'package:reactive_programming/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  final dialogResponse = showGenericDialog(
    context: context,
    title: "Log out",
    content: "Are you sure you want to log out",
    optionBuilder: () {
      return {
        "Cancel": false,
        "Log out": true,
      };
    },
  );

  return dialogResponse.then((value) => value ?? false);
}
