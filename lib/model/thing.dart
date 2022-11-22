import 'package:flutter/foundation.dart';

enum TypeOfThing { animal, person }

@immutable
class Thing {
  final TypeOfThing type;
  final String name;

  const Thing({
    required this.type,
    required this.name,
  });
}
