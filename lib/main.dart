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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();

    subject = BehaviorSubject<DateTime>();

    // Switch map dispose previous subscription
    // and create a new one.
    streamOfStrings = subject.switchMap(
      (dateTime) => Stream.periodic(
        const Duration(seconds: 1),
        (count) => "Stream count = $count, dateTime = $dateTime",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: streamOfStrings,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final string = snapshot.requireData;
                    return Text(string);
                  }

                  return const Text("Waiting for the button to be pressed!");
                },
              ),
              TextButton(
                onPressed: () {
                  subject.add(DateTime.now());
                },
                child: const Text("Start the stream"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
