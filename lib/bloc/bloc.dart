import 'package:flutter/foundation.dart';
import 'package:reactive_programming/model/thing.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class Bloc {
  final Sink<TypeOfThing?> setTypeOfThing; // right-only
  final Stream<TypeOfThing?> currentTypeOfThing; // read-only
  final Stream<Iterable<Thing>> things; // read-only

  /* The reason why we create a private constructor
     is because the UI should not care about creating
     the bloc using the parameters. It's not the job
     of the UI to provide the arguments to the bloc,
     it's the bloc factory constructors job. */
  const Bloc._({
    required this.setTypeOfThing,
    required this.currentTypeOfThing,
    required this.things,
  });

  void dispose() {
    setTypeOfThing.close();
  }

  factory Bloc({required Iterable<Thing> things}) {
    final typeOfThingSubject = BehaviorSubject<TypeOfThing?>();

    final filteredThings = typeOfThingSubject
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<Thing>>((typeOfThing) => _mapThings(typeOfThing, things))
        .startWith(things);

    return Bloc._(
      setTypeOfThing: typeOfThingSubject.sink,
      currentTypeOfThing: typeOfThingSubject.stream,
      things: filteredThings,
    );
  }

  static Iterable<Thing> _mapThings(
    TypeOfThing? typeOfThing,
    Iterable<Thing> things,
  ) {
    if (typeOfThing != null) {
      return things.where((thing) => thing.type == typeOfThing);
    } else {
      return things;
    }
  }
}
