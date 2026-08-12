import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DSClimasApp());
}

class DSClimasApp extends StatelessWidget {
  const DSClimasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DS Climas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DS Climas'),
        ),
        body: const Center(
          child: Text(
            'Firebase conectado correctamente',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}