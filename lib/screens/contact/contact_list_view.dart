import 'package:flutter/material.dart';
import 'package:reactive_programming/core/type_definitions.dart';
import 'package:reactive_programming/models/contact.dart';
import 'package:reactive_programming/screens/contact/widgets/contacts_list_tile.dart';
import 'package:reactive_programming/screens/widgets/main_popup_menu_button.dart';

class ContactListView extends StatelessWidget {
  final Stream<Iterable<Contact>> contacts;
  final LogoutCallback logout;
  final DeleteContactCallback deleteContact;
  final DeleteAccountCallback deleteAccount;
  final VoidCallback createNewContact;

  const ContactListView({
    super.key,
    required this.contacts,
    required this.deleteContact,
    required this.logout,
    required this.deleteAccount,
    required this.createNewContact,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        actions: [
          MainPopupMenuButton(
            logout: logout,
            deleteAccount: deleteAccount,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final contacts = snapshot.requireData;

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, idx) {
                  final contact = contacts.elementAt(idx);

                  return ContactListTile(
                    contact: contact,
                    deleteContact: deleteContact,
                  );
                },
              );
          }
        },
      ),
    );
  }
}
