import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globeVar.dart';
import 'appoint.dart';
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