import 'package:flutter/material.dart';
import 'dart:io';
import 'commons.dart';
import 'pass.dart';
import 'widgetClean.dart';
import 'package:flutter/services.dart';
import 'globvar.dart';
import 'package:image_picker/image_picker.dart';

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
    if (info == 'Add') {
      load = Addbrand(data['type']);
    } else {
      if (data['address'][info] != 'tomap') {
        updateroot = '$root${data['address'][info]}';
        load = Pageloader('$root${data['address'][info]}');
      } else {
        updateroot = root;
        load = Optionbuilder(data[info], root);
      }
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
  Optionbuilder(this.data, this.root);
  @override
  Widget build(BuildContext context) {
    if (data['type'] != 3) {
      options = data['list'];
      if(options.length==0)
        options.add('Add');
      if(options[options.length-1]!='Add')
          options.add('Add');

      ///distinguishes between data 3 and other data
      return Scaffold(
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
      return Evaluate(
          quest[0], option[0], data['ratelist'], data['price'].toDouble(), 0);
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
  final double rate;
  final int id;
  final int qid;
  Radioselect(this.info, this.rate, this.id, this.qid);
  @override
  _RadioselectState createState() => _RadioselectState();
}

class _RadioselectState extends State<Radioselect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(
          color: Colors.yellow,
          width: 5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 50,
              color: Colors.yellow,
              //padding: EdgeInsets.only(top: 5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${widget.info}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: Colors.white.withOpacity(0.4),
            child: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                ratelist['${widget.qid}'][widget.id] = double.parse(value),
                print(ratelist),
              },
              onEditingComplete: () => {
                TextEditingController().clear(),
              },
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: '${widget.rate}',
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
        ],
      ),
    );
  }
}

class Radiobuilder extends StatefulWidget {
  final List<dynamic> options;
  List<bool> sel;
  final List<dynamic> priceList;
  final int id;
  Radiobuilder(this.options, this.priceList, this.id);
  @override
  _RadiobuilderState createState() => _RadiobuilderState();
}

class _RadiobuilderState extends State<Radiobuilder> {
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
          children: List<Widget>.generate(
              widget.options.length,
              (i) => Radioselect(widget.options[i],
                  widget.priceList[i].toDouble(), i, widget.id)),
        ),
      ),
    );
  }
}

///phone condition evaluator
class Evaluate extends StatefulWidget {
  final String quest;
  final List<dynamic> option;
  final Map<String, dynamic> rateList;
  final double base;
  final int i;
  Evaluate(this.quest, this.option, this.rateList, this.base, this.i);
  @override
  _EvaluateState createState() => _EvaluateState();
}

class _EvaluateState extends State<Evaluate> {
  ///evaluates the condition of phone
  void tap() {
    FocusScope.of(context).unfocus();
    if (widget.i < widget.rateList['limit'] - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Evaluate(
                quest[widget.i + 1],
                option[widget.i + 1],
                widget.rateList,
                widget.base,
                widget.i + 1)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Price()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ratelist = widget.rateList;
    price = widget.base;
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
                '${widget.quest}?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Radiobuilder(widget.option, widget.rateList['${widget.i + 1}'],
                  widget.i + 1),
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
                'Updated Successfully',
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
                    MaterialPageRoute(
                        builder: (context) => Pageloader(StartPoint)),
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
                '',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
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
                        'price',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      color: Colors.grey[350],
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) => {
                          price = double.parse(value),
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: '$price',
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
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Text(
                        'Summary\n'
                        '${ratelist['1']}\n'
                        '${ratelist['2']}\n'
                        '${ratelist['3']}\n'
                        '${ratelist['4']}\n'
                        '${ratelist['5']}\n'
                        '${ratelist['6']}',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
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
                        update(),
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Success())),
                      },
                      color: Colors.green[600],
                      child: Text(
                        'Update',
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
            ],
          ),
        ),
      ),
    );
  }
}

///add brand
class Addbrand extends StatefulWidget {
  final int i;
  Addbrand(this.i);
  @override
  _AddbrandState createState() => _AddbrandState();
}

class _AddbrandState extends State<Addbrand> {
  String info,namevar='a',phone;
  File _imageFile,_varFile,_phoneFile;
  bool varient=false;
  final picker = ImagePicker();
  Image img = Image.asset('$visuals/default.png');
  Image img1 = Image.asset('$visuals/default.png');
  Image img2 = Image.asset('$visuals/default.png');
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 180,maxHeight: 180);
    return File(pickedFile.path);
    /*if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print(_image.path);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Field(TextInputType.text, '', 'Enter name', (value) {
                info = value;
              }, true),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () async => {
                          _imageFile=await pickImage(),
                          //await uploadFile(_imageFile.path),
                          setState(() => {
                            img = Image.file(_imageFile),
                          }),
                        },
                        child: img,
                      ),
                    ),
                  ],
                ),
              ),
              (widget.i==1)?
              Field(TextInputType.text, '', 'Enter Phone name in this series', (value) {
                phone = value;
              }, true):Container(),
              (widget.i==1)?
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Upload Phone Image',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () async => {
                          _phoneFile=await pickImage(),
                          //await uploadFile(_imageFile.path),
                          setState(() => {
                            img1 = Image.file(_phoneFile),
                          }),
                        },
                        child: img1,
                      ),
                    ),
                  ],
                ),
              ):Container(),
              (widget.i==1)?
              Container(
                child: Row(
                  children: [
                    Checkbox(value: varient,
                        onChanged: (value)=>{
                      setState(()=>{
                        varient=value,
                      }),
                        },
                    ),
                    Text('Add variant'),
                  ],
                ),
              ):Container(),
              (varient)?
              Field(TextInputType.text, '', 'Enter Variant name', (value) {
                namevar = value;
              }, true):Container(),
              (varient)?
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Upload Variant Image',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () async => {
                          _varFile=await pickImage(),
                          //await uploadFile(_imageFile.path),
                          setState(() => {
                            img2 = Image.file(_varFile),
                          }),
                        },
                        child: img2,
                      ),
                    ),
                  ],
                ),
              ):Container(),
              RaisedButton(
                onPressed: () async => {
                  if(widget.i==0){
                    if (info != null && _imageFile != null)
                      {await addBrand(info, _imageFile.path)},
                  },
                  if(widget.i==1){
                    await addSeries(info, _imageFile.path,phone,_phoneFile.path,varient,namevar,varient?_varFile.path:'')
                  }
                },
                child: Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
