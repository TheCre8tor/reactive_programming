import 'package:flutter/material.dart';
import 'package:reactive_programming/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog({required BuildContext context}) {
  final dialogResponse = showGenericDialog(
    context: context,
    title: "Delete account",
    content:
        "Are you sure you want to delete your account? You cannot undo this operation!",
    optionBuilder: () {
      return {
        "Cancel": false,
        "Delete account": true,
      };
    },
  );

  return dialogResponse.then((value) => value ?? false);
}
