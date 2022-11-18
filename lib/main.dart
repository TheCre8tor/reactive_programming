import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

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
  late final BehaviorSubject<String> subject;

  @override
  void initState() {
    super.initState();
    // Create our behavior subject every time widget is rebuild ->
    subject = BehaviorSubject<String>();
  }

  @override
  void dispose() async {
    super.dispose();
    // Dispose of the old subject every time widget is rebuild ->
    await subject.close();
    print("Subject close");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              StreamBuilder(
                stream: subject.stream.distinct().debounceTime(
                      const Duration(seconds: 1),
                    ),
                initialData: "Please start typing...",
                builder: ((context, snapshot) {
                  return Text(snapshot.requireData);
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: subject.sink.add,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* BehaviourSubject is a stream that holds on
 * to its last value and it will provide the value
 * to any new listeners as well as any existen 
 * listeners. 
 * 
 * BehaviorSubject as the permission to read and write */

/* A stream -> readonly
   A sink -> write only
   A SreamController -> read and write */
