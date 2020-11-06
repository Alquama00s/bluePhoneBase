import 'package:flutter/material.dart';
import 'widgetlib.dart';
import 'package:flutter/cupertino.dart';
import 'commons.dart';
import 'globeVar.dart';
import 'login.dart';
import 'evaluate.dart';
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