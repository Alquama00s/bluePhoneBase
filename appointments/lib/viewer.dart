import 'package:flutter/material.dart';
import 'launch.dart';
import 'commons.dart';
import 'globvar.dart';

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
                view['profile']['name'],
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
                    view['phonestate']['datetime'] == 'ASAP'
                        ? '${view['phonestate']['datetime']}'
                        : '${DateTime.parse(view['phonestate']['datetime']).day} '
                            '${month[DateTime.parse(view['phonestate']['datetime']).month]} '
                            '${DateTime.parse(view['phonestate']['datetime']).year}\n'
                            '${day[DateTime.parse(view['phonestate']['datetime']).weekday]}',
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
                    '${view['phonestate']['price']}',
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Customer\'s profile\n',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Name : ${view['profile']['name']}\n'
                    'Address : ${view['profile']['addressl1']} '
                    '${view['profile']['addressl2']}\n'
                    'Landmark : ${view['profile']['landmark']}\n'
                    'City : ${view['profile']['city']}\n'
                    'State : ${view['profile']['state']}\n'
                    'Pincode : ${view['profile']['pincode']}\n',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[800],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child:Text(
                view['phonestate']['datetime'] == 'ASAP'
                    ? 'Appointment Date : ${view['phonestate']['datetime']}'
                    : 'Appointment Date : ${DateTime.parse(view['phonestate']['datetime']).day} '
                    '${month[DateTime.parse(view['phonestate']['datetime']).month]} '
                    '${DateTime.parse(view['phonestate']['datetime']).year} '
                    '${day[DateTime.parse(view['phonestate']['datetime']).weekday]}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[800],
                ),
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
              child: Text('Send Recalculated Price'),
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
        future: getFire('appointments/global'),
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
