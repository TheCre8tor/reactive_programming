import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({
    required String name,
    required this.age,
  }) : super(name: name);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(name: json["name"], age: json["age"]);
  }

  @override
  String toString() {
    return "Person($name, $age)";
  }
}
