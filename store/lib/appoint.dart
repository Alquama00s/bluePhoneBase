import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'commons.dart';
import 'globeVar.dart';
import 'widgetlib.dart';
import 'login.dart';
///appoint
class Appoint extends StatefulWidget{
  @override
  _AppointState createState()=>_AppointState();
}
class _AppointState extends State<Appoint> {
  String message='';
  Color mcolor=Colors.red;
  Widget action=new  Container();
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);
  DateTime selectedDate;
  String time = 'ASAP';
  Future<bool> complete(context)async{
    bool success=false;
    await getUser();
    if(loggedin==false){
      setState(() {
        message='Seems you are not logged in!\n'
            'Login here and come back';
        action=Container(
          child: GestureDetector(
            onTap: ()=>{
              message='',
              Navigator.push(context,
                  MaterialPageRoute(builder:(context)=>Login())
              ),
            },
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.blue[900],
              size: 50,
            ),
          ),
        );
      });
      return success;
    }
    if(await userExist(Guser.uid)==true){
      await update(Guser.uid);
      success=true;
      return success;
    }
    getLuser();
    if(Luser['phone']=='Phone'){
      setState(() {
        message='Seem your details are not updated\n'
            'update here and come back';
        action=Container(
          child: GestureDetector(
            onTap: ()=>{
              message='',
              Navigator.push(context,
                  MaterialPageRoute(builder:(context)=>Login())
              ),
            },
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.blue[900],
              size: 50,
            ),
          ),
        );
      });
      return success;
    }
    else{
      initAppoint(Guser.uid);
      await update(Guser.uid);
      success=true;
      return success;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: ()async=> {
                phonestate['datetime']=time,
                if(await complete(context)==true){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>Success()),
                  ),},
              },
              color: Colors.blue,
              child: Text(
                'As Soon As Possible',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                'OR\n At your convenience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    onPressed: () async => {
                      selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2100)),
                    },
                    color: Colors.blue,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    onPressed: () async => {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      ),
                    },
                    color: Colors.blue,
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                    ),
                  ),
                ),*/

              ],
            ),
            RaisedButton(
              onPressed: ()async => {
                if (selectedDate != null)
                  {
                    selectedDate = new DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    time = selectedDate.toString(),},
                phonestate['datetime']=time,
                if(await complete(context)==true){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>Success()),
                  ),},
              },
              color: Colors.blue,
              child: Text(
                'Appoint',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: mcolor,
                    fontWeight: FontWeight.normal,
                  )
              ),
            ),
            action,
          ],
        ),
      ),
    );
  }
}