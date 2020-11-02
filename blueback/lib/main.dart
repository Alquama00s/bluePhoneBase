import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'commons.dart';
import 'package:flutter/services.dart';
import 'pass.dart';
import 'launch.dart';
String version='Unstable';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}
class Main extends StatelessWidget {
  // This widget is the root of application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Error('Something Went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return State();
          }
          return Loading();
        },
      ),
    );
  }
}
///state
class State extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getFire('backstate/version'),
        builder: (context, snap) {
          if (snap.hasError) {
            return Error('Something Went wrong');
          }
          if (snap.connectionState == ConnectionState.done) {
            if(snap.data['${version[0].toLowerCase()}${version.substring(1)}']==true){
              return Pass();
            }else{
              return Error('Version: $version \nThis version of app is outdated\n Please update');
            }
          }
          return Loading();
        },
      ),
    );
  }
}