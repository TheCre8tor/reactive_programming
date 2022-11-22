import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

import 'package:reactive_programming/bloc/bloc.dart';
import 'package:reactive_programming/constants/list_of_things.dart';
import 'package:reactive_programming/model/thing.dart';

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
    bloc = Bloc(things: things);
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
        title: const Text("Filterchip with RxDart"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: bloc.currentTypeOfThing,
                builder: (context, snapshot) {
                  final selectedTypeOfThing = snapshot.data;

                  return Wrap(
                    children: TypeOfThing.values.map((typeOfThing) {
                      return FilterChip(
                        label: Text(typeOfThing.name),
                        selected: typeOfThing == selectedTypeOfThing,
                        selectedColor: Colors.blueAccent[100],
                        onSelected: (selected) {
                          final type = selected ? typeOfThing : null;
                          bloc.setTypeOfThing.add(type);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<Iterable<Thing>>(
                  stream: bloc.things,
                  builder: ((context, snapshot) {
                    final things = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: things.length,
                      itemBuilder: (context, idx) {
                        final thing = things.elementAt(idx);

                        return ListTile(
                          title: Text(thing.name),
                          subtitle: Text(thing.type.name),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
