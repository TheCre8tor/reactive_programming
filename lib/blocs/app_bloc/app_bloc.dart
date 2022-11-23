import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/blocs/auth_bloc/auth_bloc.dart';
import 'package:reactive_programming/blocs/auth_bloc/auth_error.dart';
import 'package:reactive_programming/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:reactive_programming/blocs/views_bloc/current_view.dart';
import 'package:reactive_programming/blocs/views_bloc/views_bloc.dart';
import 'package:reactive_programming/models/contact.dart';

@immutable
class AppBloc {
  final AuthBloc _authBloc;
  final ViewsBloc _viewsBloc;
  final ContactBloc _contactBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewsBloc viewsBloc,
    required ContactBloc contactBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _viewsBloc = viewsBloc,
        _contactBloc = contactBloc,
        _userIdChanges = userIdChanges;

  factory AppBloc() {}

  // Auth usecases ->
  void register(String email, String password) {
    _authBloc.register.add(
      RegisterCommand(
        email: email,
        password: password,
      ),
    );
  }

  void login(String email, String password) {
    _authBloc.login.add(
      LoginCommand(
        email: email,
        password: password,
      ),
    );
  }

  void logout() {
    _authBloc.logout.add(null);
  }

  // Contact usecases ->
  Stream<Iterable<Contact>> get contacts => _contactBloc.contacts;

  void createContact({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    _contactBloc.createContact.add(
      Contact.withoutId(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void deleteContact(Contact contact) {
    _contactBloc.deleteContact.add(contact);
  }

  // UI: Navigation logic ->
  void gotoContactListView() {
    _viewsBloc.goToView.add(CurrentView.contactList);
  }

  void gotoCreateContactView() {
    _viewsBloc.goToView.add(CurrentView.createContact);
  }

  void gotoRegisterView() {
    _viewsBloc.goToView.add(CurrentView.register);
  }

  void gotoLoginView() {
    _viewsBloc.goToView.add(CurrentView.login);
  }
}
