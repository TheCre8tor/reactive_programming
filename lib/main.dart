import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_programming/blocs/app_bloc/app_bloc.dart';
import 'package:reactive_programming/blocs/auth_bloc/auth_error.dart';
import 'package:reactive_programming/blocs/views_bloc/current_view.dart';
import 'package:reactive_programming/dialogs/auth_error_dialog.dart';
import 'package:reactive_programming/screens/contact/contact_list_view.dart';
import 'package:reactive_programming/screens/contact/new_contact_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reactive_programming/screens/loading/page/loading_screen.dart';
import 'package:reactive_programming/screens/login/login_view.dart';
import 'package:reactive_programming/screens/register/register_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;

  StreamSubscription<AuthError?>? authErrorSub;
  StreamSubscription<bool>? isLoadingSub;

  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
  }

  @override
  void dispose() {
    super.dispose();

    appBloc.dispose();
    authErrorSub?.cancel();
    isLoadingSub?.cancel();
  }

  void handleAuthErrors(BuildContext context) async {
    await authErrorSub?.cancel();

    authErrorSub = appBloc.authError.listen((event) {
      final AuthError? authError = event;
      if (authError == null) return;

      showAuthError(authError: authError, context: context);
    });
  }

  void setupLoadingScreen(BuildContext context) async {
    await isLoadingSub?.cancel();

    isLoadingSub = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        LoadingScreen.instance().show(
          context: context,
          text: "Loading...",
        );
      } else {
        LoadingScreen.instance().hide();
      }
    });
  }

  Widget getHomePage() {
    return StreamBuilder(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;

            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  login: appBloc.login,
                  gotoRegisterView: appBloc.gotoRegisterView,
                );
              case CurrentView.register:
                return RegisterView(
                  register: appBloc.register,
                  gotoLoginView: appBloc.gotoRegisterView,
                );
              case CurrentView.contactList:
                return ContactListView(
                  contacts: appBloc.contacts,
                  deleteContact: appBloc.deleteContact,
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  createNewContact: appBloc.gotoCreateContactView,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContact: appBloc.createContact,
                  goBack: appBloc.gotoContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setupLoadingScreen(context);

    return getHomePage();
  }
}
