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
  // streamA | ---- 0 ---- 1 ---- 2 ---- 3 ---- 4 ---- |
  // take(3)
  // result | ---- 0 ---- 1 ---- 2 |

  /* 
    final result = foo  // Stream-1
      .take(3)          // Stream-2
      .debounce()       // Stream-3
      .merge()          // Stream-4
      .concat()         // Stream-5
   */

  final streamA = Stream.periodic(
    const Duration(seconds: 1),
    (count) => "Stream 1, count = $count",
  ).take(3);

  final streamB = Stream.periodic(
    const Duration(seconds: 3),
    (count) => "Stream 2, count = $count",
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();

    return Container();
  }
}
