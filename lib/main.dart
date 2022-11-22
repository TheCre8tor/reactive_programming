import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

import 'package:reactive_programming/bloc/bloc.dart';
import 'package:reactive_programming/core/async_snapshot_builder.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Bloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = Bloc();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CombineLatest with RxDart"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 25),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter first name here...",
                ),
                onChanged: bloc.setFirstName.add,
              ),
              const SizedBox(height: 25),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter last name here...",
                ),
                onChanged: bloc.setLastName.add,
              ),
              const SizedBox(height: 25),
              AsyncSnapshotBuilder<String>(
                stream: bloc.fullName,
                onActive: ((context, value) {
                  return Text(value ?? '');
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
