import 'package:appointments/commons.dart';
import 'package:appointments/viewer.dart';
import 'package:appointments/widgetClean.dart';
import 'package:flutter/material.dart';
import 'widgetLib.dart';
Map<String,dynamic> deliv={};
class Pickup extends StatelessWidget{
  final String root,hashid;
  Pickup(this.root,this.hashid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:EdgeInsets.fromLTRB(0, 25, 0, 0),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Field(TextInputType.name, 'Pickup boy name', 'Name', (v){deliv['name']=v;}, true),
              Field(TextInputType.number,'Pickup boy number','Number',(v){deliv['number']=v;},true),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
        Icons.send
    ),
        onPressed: ()=> {
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=>Send(pickup(deliv, root, hashid),Loader())),
          ),
        },
    ),
    );
  }
}