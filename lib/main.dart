import 'package:flutter/material.dart';

import 'view/home_page.dart';

void main() {
  runApp(const MyApp());
}

/* Start the live-server everytime you run this project */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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
