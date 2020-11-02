import 'package:flutter/material.dart';
import 'login.dart';
import 'commons.dart';

String pass = 'Student@10';
String currPass = '';

class Pass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        color: Colors.blue[900],
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 10,
              child: Container(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  onTap: () => {
                    License(context),
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    color: Colors.grey[350],
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) => {
                        currPass = value,
                      },
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'Key',
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
                  ),
                  RaisedButton(
                    onPressed: () => {
                      if (currPass == pass)
                        {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                              (Route<dynamic> route) => false),
                        }
                    },
                    child: Text('Enter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
