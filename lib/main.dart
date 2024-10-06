// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:nutriverde/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri Verde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color.fromARGB(255, 194, 223, 189),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 232, 255, 225), backgroundColor: Colors.green,
            minimumSize: Size(130, 130),
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.green, 
        ),
      ),
      home: MyHomePage(),
    );
  }
}