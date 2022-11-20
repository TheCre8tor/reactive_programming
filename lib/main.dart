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
    const Duration(seconds: 3),
    (count) => "Stream 1, count = $count",
  );

  final streamB = Stream.periodic(
    const Duration(seconds: 1),
    (count) => "Stream 2, count = $count",
  );

  // Work similarly to git merge ->
  // Merge is great for immediate response to UI events.
  // For instance in a ListView of check boxes ->
  final result = streamA.mergeWith([streamB]);

  await for (final value in result) {
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
