import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> _authErrorMapping = {
  "user-not-found": AuthErrorUserNotFound(),
  "weak-password": AuthErrorWeakPassword(),
  "invalid-email": AuthErrorInvalidEmail(),
  "operation-not-allowed": AuthErrorOperationNotAllowed(),
  "email-already-in-use": AuthErrorEmailAlreadyInUse(),
  "requires-recent-login": AuthErrorRequiresRecentLogin(),
  "no-current-user": AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) {
    final error = exception.code.toLowerCase().trim();
    return _authErrorMapping[error] ?? const AuthErrorUnknown();
  }
}

//! auth/auth-error-unknown
@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogText: "Authentication error",
          dialogTitle: "Unknown authentication error",
        );
}

//! auth/no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogText: "No current user!",
          dialogTitle: "No current user with thid information was found!",
        );
}

//! auth/requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogText: "Requires recent login",
          dialogTitle:
              "You need to log out and log back in again in order to perform this operation",
        );
}

//! auth/operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogText: "Operation not allowed",
          dialogTitle: "You cannot register using this method as this moment!",
        );
}

//! auth/user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogText: "User not found",
          dialogTitle: "The given user was not found on the server!",
        );
}

//! auth/weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogText: "Weak password",
          dialogTitle:
              "Please choose a stronger password consisting of more characters!",
        );
}

//! auth/invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogText: "Invalid email",
          dialogTitle: "Please double check your email and  try again!",
        );
}

//! auth/invalid-email
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogText: "Email already in use",
          dialogTitle: "Please choose another email to register with!",
        );
}
