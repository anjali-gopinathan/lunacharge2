import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motor_flutter/motor_flutter.dart';
import 'package:motor_flutter_starter/pages/map_page.dart';

import 'pages/start_page.dart';

Future<void> main() async {
  await MotorFlutter.init();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motor Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'DM Sans',
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'DM Sans',
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      home: const MapPage(),
      // home: const StartPage(),
    );
  }
}
