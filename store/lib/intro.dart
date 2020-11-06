import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'commons.dart';
import 'globeVar.dart';
import 'widgetlib.dart';
import 'package:permission_handler/permission_handler.dart';
import 'browser.dart';
class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Permission.storage.status.isGranted,
      builder: (context,snap){
        if(snap.connectionState == ConnectionState.done){
          if(snap.data==true) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.7,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                          ),
                          boxShadow: [new BoxShadow(
                            color: Colors.black,
                            blurRadius: 20.0,
                          ),
                          ],
                        ),
                        child: FutureBuilder(
                          future: getLuser(),
                          builder: (context, data) {
                            if (data.hasError || data.data == null) {
                              return Text('Hi There!\n\n Welcome back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (data.connectionState == ConnectionState.done) {
                              return Text('Hi There!\n\n Welcome back\n\n${data
                                  .data['name']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Text('Hi There!\n Welcome back');
                          },
                        )
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(

                            child: Text(
                              'Lets sell your phone',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Select Phone!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async =>
                            {
                              initializep(),
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    Pageloader(StartPoint)),
                              ),
                            },
                            color: Colors.blue[900],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
            else{
              Permission.storage.request();
              return Error('Restart the app with storage permission\n'
                  'This issue will be resolved in future release');
          }
          }else{
          return Loading();
        }
      },
    );
  }
}
