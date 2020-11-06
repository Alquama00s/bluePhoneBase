import 'package:flutter/material.dart';
import 'package:store/globeVar.dart';
import 'widgetlib.dart';
import 'commons.dart';
import 'globeVar.dart';

class Options extends StatelessWidget {
  final Map<String, dynamic> view;
  Options(this.view);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewAppoint(view)),
        ),
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.white,
          ),
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              height: 40,
              width: MediaQuery.of(context).size.width - 29,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0,
                  color: Colors.red.withOpacity(1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Text(
                view['datetime'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: Colors.red.withOpacity(1),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    view['datetime'] == 'ASAP'
                        ? '${view['datetime']}'
                        : '${DateTime.parse(view['datetime']).day} '
                        '${month[DateTime.parse(view['datetime']).month]} '
                        '${DateTime.parse(view['datetime']).year}\n'
                        '${day[DateTime.parse(view['datetime']).weekday]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  height: 80,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: Colors.red.withOpacity(0),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    '${view['price']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ViewAppoint extends StatelessWidget {
  final Map<String, dynamic> view;
  ViewAppoint(this.view);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              '${view['root']}',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            Text(
              'Price : ${view['price']}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[800],
              ),
            ),
            Text(
              view['datetime'] == 'ASAP'
                  ? 'Date : ${view['datetime']}'
                  : 'Date : ${DateTime.parse(view['datetime']).day} '
                  '${month[DateTime.parse(view['datetime']).month]} '
                  '${DateTime.parse(view['datetime']).year} '
                  '${day[DateTime.parse(view['datetime']).weekday]}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(
              height: 90,
            ),
            RaisedButton(
              onPressed: () => {},
              child: Text('Generate Phone data'),
            ),
            RaisedButton(
              onPressed: () => {},
              child: Text('Mark Finished'),
            ),
          ],
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  List<dynamic> list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getFire('appointments/${Luser['uid']}'),
        builder: (context, snap) {
          if (snap.hasError) {
            return Error('Something Went wrong');
          }
          if (snap.connectionState == ConnectionState.done) {
            list = ConvAppointments(snap.data['appointmentid'],snap.data['appointments'] );
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                return Options(list[i]);
              },
            );
          }
          return Loading();
        },
      ),
    );
  }
}
