import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/globeVar.dart';

class Settings extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
        child:  Container(
          child: Text(
            'some',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.info,
        ),
        onPressed: ()=>{
          showAboutDialog(context: context,
              applicationName: 'Blue Phone Base',
              applicationVersion: version,
              applicationLegalese: 'All rights reserved'

          ),
        },
      ),
    );
  }
}