import 'package:flutter/material.dart';
import 'launch.dart';
///send data
class Send extends StatelessWidget{
  final run;
  final then;
  Send(this.run,this.then);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: run,
      builder: (context,snap){
        if(snap.hasError){
          return Error('${snap.error}');
        }
        if(snap.connectionState==ConnectionState.done){
          return then;
        }
        return Loading();
      },
    );
  }
}