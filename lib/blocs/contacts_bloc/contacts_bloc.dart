import 'dart:async';
import 'package:flutter/foundation.dart' show immutable;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reactive_programming/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reactive_programming/models/contact.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() {
    return switchMap((optional) async* {
      if (optional != null) {
        yield optional;
      }
    });
  }
}

@immutable
class ContactBloc implements Bloc {
  // write-only ->
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Sink<void> deleteAllContacts;

  // read-only ->
  final Stream<Iterable<Contact>> contacts;

  // subscribing to a value that comes from a stream ->
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactsSubscription;

  @override
  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContacts.close();
    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
    _deleteAllContactsSubscription.cancel();
  }

  const ContactBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required this.deleteAllContacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactsSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription,
        _deleteAllContactsSubscription = deleteAllContactsSubscription;

  factory ContactBloc() {
    final backend = FirebaseFirestore.instance;

    // user id
    final userId = BehaviorSubject<String?>();

    // upon changes to user id, retrieve our contacts
    final Stream<_Snapshots> retrieveContacts = userId.switchMap<_Snapshots>(
      (String? id) {
        if (id != null) {
          return backend.collection(id).snapshots();
        }

        return const Stream<_Snapshots>.empty();
      },
    );

    final Stream<Iterable<Contact>> contacts = retrieveContacts.map(
      (snapshots) sync* {
        for (final doc in snapshots.docs) {
          yield Contact.fromJson(id: doc.id, doc.data());
        }
      },
    );

    // create contact
    final createContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> createContactSubscription = createContact
        .switchMap(
          // 1. take the most recent emitted item in the createContact stream
          // 2. map it by taking the first emitted item of userId stream
          // 3. make sure userId is not nullable by unwrapping the result
          // 4. call the contactService inside the asyncMap callback function
          // 5. save the contact data to the backend
          (contactToCreate) => userId.take(1).unwrap().asyncMap((id) {
            return _createContactService(backend, id, contactToCreate);
          }),
        )
        .listen(
          (event) {},
        );

    // delete contact
    final deleteContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> deleteContactSubscription = deleteContact
        .switchMap(
          // 1. take the most recent emitted item in the createContact stream
          // 2. map it by taking the first emitted item of userId stream
          // 3. make sure userId is not nullable by unwrapping the result
          // 4. call the contactService inside the asyncMap callback function
          // 5. save the contact data to the backend
          (contactToDelete) => userId.take(1).unwrap().asyncMap((id) {
            return _deleteContactService(backend, id, contactToDelete);
          }),
        )
        .listen(
          (event) {},
        );

    // delete all contacts
    final deleteAllContacts = BehaviorSubject<void>();

    final StreamSubscription<void> deleteAllContactsSubscription =
        deleteAllContacts
            .switchMap(
              (_) => userId.take(1).unwrap().asyncMap((id) {
                return _deleteAllContactsService(backend, id);
              }).switchMap((collection) {
                return Stream.fromFutures(collection.docs.map(
                  (doc) => doc.reference.delete(),
                ));
              }),
            )
            .listen(
              (event) {},
            );

    // create ContactBloc
    return ContactBloc._(
      userId: userId.sink,
      createContact: createContact.sink,
      deleteContact: deleteContact.sink,
      deleteAllContacts: deleteAllContacts.sink,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactsSubscription: deleteAllContactsSubscription,
    );
  }

  static Future<_Document> _createContactService(
      FirebaseFirestore backend, String id, Contact contact) {
    return backend.collection(id).add(contact.data);
  }

  static Future<void> _deleteContactService(
      FirebaseFirestore backend, String userId, Contact contact) {
    return backend.collection(userId).doc(contact.id).delete();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> _deleteAllContactsService(
    FirebaseFirestore backend,
    String userId,
  ) {
    return backend.collection(userId).get();
  }
}
