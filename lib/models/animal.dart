import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_programming/models/thing.dart';

enum AnimalType { dog, cat, rabbit, unknow }

@immutable
class Animal extends Thing {
  final AnimalType type;

  const Animal({
    required String name,
    required this.type,
  }) : super(name: name);

  factory Animal.fromJson(Map<String, dynamic> json) {
    var animalType = _parseSwitch(json);

    return Animal(name: json["name"], type: animalType);
  }

  static AnimalType _parseSwitch(Map<String, dynamic> json) {
    switch ((json["type"] as String).toLowerCase().trim()) {
      case "dog":
        return AnimalType.dog;
      case "cat":
        return AnimalType.cat;
      case "rabbit":
        return AnimalType.rabbit;
      default:
        return AnimalType.unknow;
    }
  }

  @override
  String toString() {
    return "Animal, name: $name, type: $type";
  }
}
