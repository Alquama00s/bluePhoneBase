import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globvar.dart';
class Field extends StatelessWidget {
  final String hint,label;
  final bool active;
  final TextInputType type;
  final function;
  Field(this.type,this.hint,this.label,this.function,this.active);
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        //color: Colors.grey[350],
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          active
              ? Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.grey[350],
            child: TextFormField(
              keyboardType: type,
              onChanged: (value)=>{
                function(value),
              },
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                //labelText: hint[0].toUpperCase()+hint.substring(1),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          )
              : Container(
            color: Colors.grey[350],
            constraints: BoxConstraints(minWidth: double.infinity),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      )
    );
  }
}
///
