import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import "dart:developer" as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

void testIt() async {
  final streamA = Stream.periodic(
    const Duration(seconds: 1),
    (count) => "Stream 1, count = $count",
  );

  final streamB = Stream.periodic(
    const Duration(seconds: 3),
    (count) => "Stream 2, count = $count",
  );

  final combined = Rx.combineLatest2(
    streamA,
    streamB,
    (one, two) => "One = ($one), Two = ($two)",
  );

  await for (final value in combined) {
    value.log();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();

    return Container();
  }
}
