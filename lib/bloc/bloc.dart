import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class Bloc {
  final Sink<String?> setFirstName; // write-only
  final Sink<String?> setLastName; // write-only
  final Stream<String> fullName; // read-only

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  void dispose() {
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc() {
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();

    /* With combineLatest the Stream will not emit until 
       all streams have emitted at least one item.*/
    final Stream<String> fullName = Rx.combineLatest2(
      firstNameSubject.startWith(null),
      lastNameSubject.startWith(null),
      (String? firstName, String? lastName) {
        if (firstName != null &&
            firstName.isNotEmpty &&
            lastName != null &&
            lastName.isNotEmpty) {
          return "$firstName $lastName";
        } else {
          return "Both first and last name must be provided";
        }
      },
    );

    return Bloc._(
      setFirstName: firstNameSubject.sink,
      setLastName: lastNameSubject.sink,
      fullName: fullName,
    );
  }
}
