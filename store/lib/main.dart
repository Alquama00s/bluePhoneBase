import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'commons.dart';
import 'widgetlib.dart';
import 'globeVar.dart';
import 'package:flutter/services.dart';
import 'intro.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}
class Main extends StatelessWidget {
  // This widget is the root of application.
  Future<dynamic> _initialization()async{
   await Firebase.initializeApp();
   await getLuser();
   return;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initialization(),
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
///state check
class State extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getFire('state/version'),
        builder: (context, snap) {
          if (snap.hasError) {
            return Error('Something Went wrong');
          }
          if (snap.connectionState == ConnectionState.done) {
            if(snap.data['${version.toLowerCase()}']==true){
              return Intro();
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
class Test extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Error('Something Went wrong');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Main();
          }
          return Loading();
        },
      ),
    );
  }
}
