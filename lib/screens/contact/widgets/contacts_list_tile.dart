import 'package:flutter/material.dart';
import 'package:reactive_programming/core/type_definitions.dart';
import 'package:reactive_programming/dialogs/delete_contact_dialog.dart';
import 'package:reactive_programming/models/contact.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;

  const ContactListTile({
    super.key,
    required this.contact,
    required this.deleteContact,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        onPressed: () async {
          final shouldDelete = await showDeleteContactDialog(context);
          if (shouldDelete) deleteContact(contact);
        },
        icon: const Icon(Icons.delete_rounded),
      ),
    );
  }
}
