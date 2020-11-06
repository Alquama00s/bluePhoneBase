import 'package:flutter/material.dart';
import 'commons.dart';
import 'launch.dart';
import 'pass.dart';
import 'globvar.dart';
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