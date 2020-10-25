import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/intro.dart';
import 'commons.dart';
import 'globeVar.dart';
import 'widgetClean.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'settings.dart';
///dependency for optionBuilder
class Box extends StatelessWidget {
  final String info;
  final String root;
  final Map<String, dynamic> data;
  Box(this.data, this.info, this.root);
  Widget loadPage() {
    /// chooses between data of type 1 and 0
    Widget load;

    /// for more info see database docs
    if (data['address'][info] != 'tomap') {
      phonestate['root']='$root${data['address'][info]}';
      load = Pageloader('$root${data['address'][info]}');
    } else {
      phonestate['root']='$root$data[info]';
      load = Optionbuilder(data[info], root);
    }
    return load;
  }

  Widget build(BuildContext context) {
    Container bottomName = Container(
      constraints: BoxConstraints(
        minHeight: 28,
      ),
      width: double.infinity,
      color: Colors.white.withOpacity(0.5),
      //alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 5),
      child: Text(
        '${info[0].toUpperCase() + info.substring(1)}',
        textAlign: TextAlign.right,
        textHeightBehavior: TextHeightBehavior.fromEncoded(1),
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 20,
          height: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => loadPage()),
          )
        },
        child: Container(
          child: Stack(
            children: [
              FutureBuilder(
                future: getimage('/$info.png'),
                builder: (context, data) {
                  if (data.hasData) {
                    return Container(
                      padding: EdgeInsets.all(0),
                      child: data.data,
                    );
                  }
                  return Container();
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: bottomName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Optionbuilder(list of option)
class Optionbuilder extends StatelessWidget {
  ///takes a list and root address as input
  final Map<String, dynamic> data;

  ///and displays it as options
  final String root;
  List<dynamic> options;
  Icon checkLog(){
    if(Luser==null){
      return Icon(
        Icons.supervised_user_circle,
        size: 40,
        color: Colors.red[600],
      );

    }else{
      return  Icon(
        Icons.supervised_user_circle,
        size: 40,
        color: Colors.blue[900],
      );
    }
  }
  Optionbuilder(this.data, this.root);
  @override
  Widget build(BuildContext context) {
    if (data['type'] != 3) {
      options = data['list'];
      ///distinguishes between data 3 and other data
      return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: ()=>{
                Navigator.push(context,
                MaterialPageRoute(builder:(context)=>Login()),
                ),
              },
              child:checkLog(),
            ),
            ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            primary: false,
            //padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: List<Widget>.generate(
                options.length, (i) => Box(data, options[i], root)),
          ),
        ),
      );
    } else {
      return Evaluate(quest, option, data['ratelist'], data['price'].toDouble());
    }
  }
}

///Pageloader loads data from fire base displays as option
class Pageloader extends StatefulWidget {
  final String address;
  Pageloader(this.address);
  @override
  _PageloaderState createState() => _PageloaderState();
}

class _PageloaderState extends State<Pageloader> {
  // the clutter of different error screen are to be maneged here
  List<String> options;
  //bool load=false;
  Widget load;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getFire(widget.address),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
        if (data.hasData) {
          load = Optionbuilder(data.data, widget.address);
        } else if (data.hasError) {
          load = Error(data.error);
        } else {
          load = Loading();
        }
        return load;
      },
    );
  }
}

///dependency for evaluate
class Radioselect extends StatefulWidget {
  final String info;
  final check;
  final List<bool> sel;
  final int id;
  Radioselect(this.info, this.check, this.sel, this.id);
  @override
  _RadioselectState createState() => _RadioselectState();
}

class _RadioselectState extends State<Radioselect> {
  Color select = Colors.blue.withOpacity(0);
  Color seltext = Colors.blue;
  List<bool> def;
  void toggle() {
    if (widget.sel[widget.id] == false) {
      setState(() {
        select = Colors.blue.withOpacity(0);
        seltext = Colors.blue;
      });
    } else {
      setState(() {
        select = Colors.blue.withOpacity(1);
        seltext = Colors.white;
      });
    }
  }

  void tap() {
    widget.check(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    toggle();
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 50,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(
            color: select,
            width: 5,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          color: select,
          //padding: EdgeInsets.only(top: 5),
          child: Text(
            '${widget.info}',
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: seltext,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Radiobuilder extends StatefulWidget {
  final List<dynamic> options;
  List<bool> sel;
  final List<dynamic> priceList;
  final modifyRate;
  Radiobuilder(this.options, this.priceList, this.modifyRate, this.sel);
  @override
  _RadiobuilderState createState() => _RadiobuilderState();
}

class _RadiobuilderState extends State<Radiobuilder> {
  dynamic temp = 0.0;
  Function check(int i) {
    setState(() {
      temp=temp.toDouble();
      if ((widget.sel[i] == false) && (widget.options[0] == 'R')) {
        widget.sel =
            List<bool>.generate(widget.options.length - 1, (i) => false);
        widget.sel[i] = true;
        if (widget.priceList[0] == 1) {
          widget.modifyRate(widget.priceList[i + 1] - temp,widget.sel);
          temp = widget.priceList[i + 1];
        } else {
          widget.modifyRate(-widget.priceList[i + 1] - temp,widget.sel);
          temp = -widget.priceList[i + 1];
        }
      } else {
        if (widget.sel[i] == true) {
          widget.sel[i] = false;
          if (widget.priceList[0] == 1) {
            widget.modifyRate(-widget.priceList[i + 1],widget.sel);
          } else {
            widget.modifyRate(widget.priceList[i + 1],widget.sel);
          }
        } else {
          widget.sel[i] = true;
          if (widget.priceList[0] == 1) {
            widget.modifyRate(widget.priceList[i + 1],widget.sel);
          } else {
            widget.modifyRate(-widget.priceList[i + 1],widget.sel);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 400,
        child: GridView.count(
          primary: false,
          //padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List<Widget>.generate(widget.options.length - 1,
              (i) => Radioselect(widget.options[i + 1], check, widget.sel, i)),
        ),
      ),
    );
  }
}

///phone condition evaluator
class Evaluate extends StatefulWidget {
  final List<String> quest;
  final List<List<dynamic>> option;
  final Map<String,dynamic> rateList;
  final double base;
  Evaluate(this.quest, this.option, this.rateList, this.base);
  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  ///evaluates the condition of phone
  double rate;
  int i = 0;
  Function modifyRate(dynamic value,List<bool> select) {
    phonestate['pstate']['${i+1}']=select;
    value=value.toDouble();
    rate += value;
    if(rate<0){
      rate=0;
    }
  }

  void tap() {
    if (i < widget.quest.length - 1) {
      setState(() {
        i++;
      });
    } else {
      phonestate['price']=rate;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Price(rate)),
      );
    }
  }

  @override
  void initState() {
    rate = widget.base;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white.withOpacity(0),
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${widget.quest[i]}?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Radiobuilder(widget.option[i], widget.rateList['${i+1}'], modifyRate,
                  List<bool>.generate(option[i].length - 1, (i) => false)),
              FloatingActionButton(
                onPressed: tap,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.blue,
                  size: 40,
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height - 150,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 40.0, // soften the shadow
                spreadRadius: 25.0, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  0.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///the loading page
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Loading',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

///error page
class Error extends StatelessWidget {
  final String data;
  Error(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Error',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                data,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
///success page
class Success extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.done,
              color: Colors.green[700],
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Appointment was fixed Successfully',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 150,
            ),
            RaisedButton(
              padding: EdgeInsets.all(20),
              onPressed: () => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Intro()),
              (Route<dynamic> route) => false),
              },
              color: Colors.green[600],
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'This is only the test version of App\n'
                    'we are not yet operational!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///handle back button

///price screen
class Price extends StatelessWidget {
  final double rate;
  Price(this.rate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Congrats you get',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Icon(
              Icons.monetization_on,
              color: Colors.green[600],
              size: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Text(
                'Rupee $rate',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            RaisedButton(
              padding: EdgeInsets.all(20),
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Appoint())),
              },
              color: Colors.green[600],
              child: Text(
                'Sell Now',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    getUser();
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
        update(Guser.uid);
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
            update(Guser.uid);
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
                Container(
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
                ),

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
            Navigator.push(context,
              MaterialPageRoute(builder:(context)=>Login()),
            ),
          },
        ),
      )
    );
  }
}