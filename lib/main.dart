import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCxg5ztaePTolOZPqq1owWOKn1p5yYS0Q8",
          appId: "1:137582490404:web:3870dac5194d90c86f39b1",
          messagingSenderId: "137582490404",
          projectId:  "tic-tac-toe-76c40",));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(), // Set WelcomePage as the home screen
    );
  }
}
