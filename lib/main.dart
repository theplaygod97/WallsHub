import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:walls/views/home.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(FlutterConfig.get('API_KEY'));
    return MaterialApp(
      title: 'Walls',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}

