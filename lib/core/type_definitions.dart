import 'package:flutter/material.dart';
import 'package:reactive_programming/models/contact.dart';

typedef LogoutCallback = VoidCallback;
typedef DeleteAccountCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef LoginFunction = void Function(String email, String password);
typedef RegisterFunction = void Function(String email, String password);
typedef CreateContactCallback = void Function({
  required String firstName,
  required String lastName,
  required String phoneNumber,
});
typedef DeleteContactCallback = void Function(Contact contact);
