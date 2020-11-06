import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'commons.dart';
import 'globeVar.dart';
import 'package:flutter/services.dart';
import 'viewer.dart';
import 'widgetlib.dart';
///Login sign up page
class Login extends StatefulWidget{
  @override
  _LoginState createState()=>_LoginState();
}
class _LoginState extends State<Login> {
  bool login=(Guser==null)?false:true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context,snap) {
        if(snap.connectionState==ConnectionState.done){
          if (loggedin == true) {
            return Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      height:MediaQuery
                          .of(context)
                          .size
                          .height*0.3,
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
                      child: Stack(
                        children: [
                          Positioned(
                            top: 5,
                            left: 10,
                            child: GestureDetector(
                              child: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              onTap: () =>
                              {
                                License(context),
                              },
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(
                                  'Welcome! \n${Guser.displayName.split(
                                      new RegExp('\\s+'))[0]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                fit: BoxFit.fitWidth,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height:MediaQuery
                          .of(context)
                          .size
                          .height*0.7,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (Luser['Phone']=='phone')?
                          Container(
                            child: Text(
                              'Email: ${Guser.email}\n'
                                  '\nPlease Update your info completely',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ):
                          Container(
                            child: Text(
                              'Email: ${Guser.email}\n'
                                  '\nPhone: ${Luser['phone']}\n'
                                  '\nAddress: ${Luser['addressl1']}'
                                  ' ${Luser['addressl2']}'
                                  '\n${Luser['landmark']}'
                                  '\n${Luser['city']}:${Luser['pincode']}'
                                  '\n${Luser['state']}',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RaisedButton(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async =>
                            {
                              await getLuser(),
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Edit()),
                              ),
                            },
                            color: Colors.blue,
                          ),
                          RaisedButton(
                            child: Text(
                              'Your Appointments',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async =>
                            {
                              await getUser(),
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Loader()),
                              ),
                            },
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          else if(loggedin==false) {
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
                          child: Image.asset('$visuals/google.png',
                            height: 100,
                          ),
                          onPressed: () async =>
                          {
                            await signInWithGoogle(),
                            setState(() {
                              login = true;
                            }),
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
        return Loading();
      },

    );
  }
}
///edit user details
class Edit extends StatefulWidget{
  @override
  _EditState createState()=>_EditState();
}
class _EditState extends State<Edit>{
  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    tempuser=Luser;
    return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 50, 5, 10),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Field(TextInputType.name,'name','Name',false),
                  Field(TextInputType.emailAddress,'email','Email',false),
                  Field(TextInputType.phone,'phone','Phone',true),
                  Field(TextInputType.text,'addressl1','Address Line 1',true),
                  Field(TextInputType.text,'addressl2','Address Line 2',true),
                  Field(TextInputType.text,'landmark','Landmark',true),
                  Field(TextInputType.number,'pincode','Pincode',true),
                  Field(TextInputType.text,'city','City',false),
                  Field(TextInputType.text,'state','State',false),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.all(5),
          child: FloatingActionButton(
            child: Icon(
              Icons.update,
              size: 35,
            ),
            onPressed: ()async=>{
              Luser=tempuser,
              await saveJason(),
              Navigator.pop(context),
            },
          ),
        )
    );
  }
}