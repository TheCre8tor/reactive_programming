import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

@immutable
abstract class AuthStatus {
  const AuthStatus();
}

@immutable
class AuthStatusLoggedOut implements AuthStatus {
  const AuthStatusLoggedOut();
}

@immutable
class AuthStatusLoggedIn implements AuthStatus {
  const AuthStatusLoggedIn();
}

@immutable
abstract class AuthCommand {
  final String email;
  final String password;

  const AuthCommand({
    required this.email,
    required this.password,
  });
}

class LoginCommand extends AuthCommand {
  const LoginCommand({
    required super.email,
    required super.password,
  });
}

class RegisterCommand extends AuthCommand {
  const RegisterCommand({
    required super.email,
    required super.password,
  });
}

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(
    bool isLoading, {
    required Sink<bool> onSink,
  }) {
    return doOnEach((_) {
      onSink.add(isLoading);
    });
  }
}

@immutable
class AuthBloc {
  // read-only properties ->
  final Stream<AuthStatus> authStatus;
  final Stream<AuthError?> authError;
  final Stream<bool> isLoading;
  final Stream<String?> userId;

  // write-only properties ->
  final Sink<LoginCommand> login;
  final Sink<RegisterCommand> register;
  final Sink<void> logout;

  const AuthBloc._({
    required this.authStatus,
    required this.authError,
    required this.isLoading,
    required this.userId,
    required this.login,
    required this.register,
    required this.logout,
  });

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();

    final Stream<User?> authUser = FirebaseAuth.instance.authStateChanges();

    final Stream<AuthStatus> authStatus = authUser.map((user) {
      if (user != null) {
        return const AuthStatusLoggedIn();
      }

      return const AuthStatusLoggedOut();
    });

    // get the user-id
    final Stream<String?> userId = authUser
        .map((user) => user?.uid)
        .startWith(FirebaseAuth.instance.currentUser?.uid);

    // login + error handling
    final login = BehaviorSubject<LoginCommand>();

    final processLogin = login.setLoadingTo(true, onSink: isLoading.sink);
    final loginError = processLogin.asyncMap<AuthError?>((command) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: command.email,
          password: command.password,
        );

        // if we successfully signed-in, we return
        // null, which means there was no error.
        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    });

    // set loading to false ->
    loginError.setLoadingTo(false, onSink: isLoading.sink);

    // ----------------------

    // register + error handling
    final register = BehaviorSubject<RegisterCommand>();

    final processRegister = register.setLoadingTo(true, onSink: isLoading.sink);
    final registerError = processRegister.asyncMap<AuthError?>((command) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: command.email,
          password: command.password,
        );

        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    });

    // set loading to false ->
    registerError.setLoadingTo(false, onSink: isLoading.sink);

    // -----------------------

    // logout + error handling
    final logout = BehaviorSubject<void>();

    final processLogout = logout.setLoadingTo(true, onSink: isLoading.sink);
    final logoutError = processLogout.asyncMap<AuthError?>((_) async {
      try {
        await FirebaseAuth.instance.signOut();
        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    });

    // set loading to false ->
    logoutError.setLoadingTo(false, onSink: isLoading.sink);

    // -----------------------
    // auth error = (login error + register error + logout error)
    final Stream<AuthError?> authError = Rx.merge([
      loginError,
      registerError,
      logoutError,
    ]);

    return AuthBloc._(
      authStatus: authStatus,
      authError: authError,
      isLoading: isLoading,
      userId: userId,
      login: login.sink,
      register: register.sink,
      logout: logout.sink,
    );
  }
}
