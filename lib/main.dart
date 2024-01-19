import 'package:login_andriod/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:login_andriod/screens/login_screen.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = LocalStorage("USER_SEASON");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, data) {
            var token = storage.getItem("TOKEN");
            if (token != null) {
              return HomeScreen();
            }
            return LoginScreen();
          }),
    );
  }
}
