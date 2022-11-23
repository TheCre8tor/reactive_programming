import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import "package:rxdart/rxdart.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

Stream<String> getNames({required String filePath}) {
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}

Stream<String> getAllNames() {
  final catNames = getNames(filePath: "assets/texts/cats.txt");
  final dogNames = getNames(filePath: "assets/texts/dogs.txt");
  return catNames.concatWith([dogNames]).delay(const Duration(seconds: 3));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("concat with RxDart"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<String>>(
            future: getAllNames().toList(),
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  final names = snapshot.requireData;

                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(
                      color: Colors.black,
                    ),
                    itemCount: names.length,
                    itemBuilder: (context, idx) {
                      return ListTile(
                        title: Text(names[idx]),
                      );
                    },
                  );
              }
            }),
          ),
        ),
      ),
    );
  }
}
