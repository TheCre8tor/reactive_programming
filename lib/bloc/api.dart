import 'dart:convert';
import 'dart:io';

import 'package:reactive_programming/models/animal.dart';
import 'package:reactive_programming/models/person.dart';
import 'package:reactive_programming/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animal;
  List<Person>? _person;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    // search in the cache
    final cachedResult = _extractThingsUsingSearchTerm(term);

    if (cachedResult != null) {
      return cachedResult;
    }

    // -> we dont have the values cached, let's call the API

    // start by calling persons API
    final persons = await _getJson("http://127.0.0.1:5500/apis/persons.json")
        .then((value) => value.map((json) => Person.fromJson(json)));

    // cache persons value ->
    _person = persons.toList();

    // start by calling animals API
    final animals = await _getJson("http://127.0.0.1:5500/apis/animals.json")
        .then((value) => value.map((json) => Animal.fromJson(json)));

    // cache animals value ->
    _animal = animals.toList();

    return _extractThingsUsingSearchTerm(term) ?? [];
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animal;
    final cachedPersons = _person;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];

      // go through animal
      for (final animal in cachedAnimals) {
        if (animal.name.trimedContains(term) ||
            animal.type.name.trim().trimedContains(term)) {
          result.add(animal);
        }
      }

      // go through person
      for (final person in cachedPersons) {
        if (person.name.trimedContains(term) ||
            person.age.toString().trimedContains(term)) {
          result.add(person);
        }
      }

      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(url) {
    return HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close())
        .then((response) => response.transform(utf8.decoder).join())
        .then((jsonString) => json.decode(jsonString) as List<dynamic>);
  }
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimedContains(String other) {
    return trim().toLowerCase().contains(other.trim().toLowerCase());
  }
}
