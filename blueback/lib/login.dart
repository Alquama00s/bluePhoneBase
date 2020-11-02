import 'package:flutter/material.dart';
import 'commons.dart';
import 'launch.dart';
///Login sign up page
String uid;
class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 35,
            left: 10,
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Icon(
                  Icons.info,
                  color: Colors.blue[900],
                ),
                onTap: () =>
                {
                  License(context),
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),

                RaisedButton(
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/visuals/google.png',
                    height: 100,
                  ),
                  onPressed: () async =>
                  {
                    uid=await signInWithGoogle(),
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Verify()),
                            (Route<dynamic> route) => false),
                  },
                  color: Colors.blue[900],
                ),
                Container(
                  child: Text(
                    'Google \nSign in is great',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
class Verify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getFire('backstate/user'),
        builder: (context, snap) {
          if (snap.hasError) {
            return Error('Something Went wrong');
          }
          if (snap.connectionState == ConnectionState.done) {
            if(snap.data['uid'].contains(uid)){
              return Pageloader('phone/phone/brand/brand');
            }else{
              return Error('Unauthorized!');
            }
          }
          return Loading();
        },
      ),
    );
  }
}