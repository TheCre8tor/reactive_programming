import 'package:flutter/material.dart';
import 'package:reactive_programming/blocs/auth_bloc/auth_error.dart';
import 'package:reactive_programming/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: authError.dialogText,
    content: authError.dialogText,
    optionBuilder: () {
      return {"OK": true};
    },
  );
}
