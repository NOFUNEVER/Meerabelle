import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyCharts extends StatefulWidget {
  int petdex;
  var petlist;

  MyCharts({Key? key, required this.petdex, required this.petlist})
      : super(key: key);

//  int _counter = 0;
  @override
  State<MyCharts> createState() => _MyChartsState(this.petdex, this.petlist);
}

class _MyChartsState extends State<MyCharts> {
  int petdex = 0;
  int chartdex =0;
  var petlist = [];
  var chartlist = [];

  void _incrementCounter() {}

  _MyChartsState(this.petdex, this.petlist);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('pets')
            .doc(petlist.elementAt(petdex)['name'])
            .collection('data')
            .get()
            .then((value) {
          chartlist = value.docs;

          print('ssssssssssooooooooo ' + chartlist[0].id);
        }),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(35.0),
                child: AppBar(
                  title: const Text(
                    'Charts',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              body: Center(
                  child: Container(
                child: Padding(
                  // Even Padding On All Sides
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: provideDocumentFieldStream(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<ChartData> chartData = <ChartData>[];
                            Map<String, dynamic> documentFields =
                                snapshot.data.data();
                            for (int i = 0; i < documentFields.length; i++) {
                              chartData.add(ChartData(
                                  documentFields.keys.elementAt(i),
                                  documentFields.values.elementAt(i)));
                            }

                            return SfCartesianChart(
                                margin: EdgeInsets.all(8.0),
                                title: ChartTitle(text: chartlist[chartdex].id ),
                                // Initialize category axis
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis:
NumericAxis(),//                                    NumericAxis(minimum: 0, maximum: 4),
                                series: <ChartSeries>[
                                  // Initialize line series
                                  LineSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData dat, _) =>
                                          dat.year,
                                      yValueMapper: (ChartData dat, _) =>
                                          dat.val,
                                      // Render the data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true))
                                ]);
                          } else {
                            return SfCartesianChart();
                          }
                        }),
                  ),
                ),
              )),
              endDrawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.

                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.


                  child:Column(
                  children: <Widget>[
                    //    Expanded(
                    Container(
                      child: DrawerHeader(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const <Widget>[
                            Text('Charts'),
                          ],
                        ),
                      ),
                      color: Colors.blueAccent,
                    ), // Divider //

                    Expanded(
                      child: //SingleChildScrollView(

                          ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black,
                        ),
                        physics: ClampingScrollPhysics(),
                        itemCount: chartlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Ink(
                            color: true ? Colors.lightBlueAccent : null,
                            //    children: <Widget>[
                            child: ListTile(
                              title: Text(chartlist[index].id),
                              onTap: () {
                                // Navigator.pop(context);
                                      setState(() {
                                        chartdex = index;
                                      });
                                // Update the state of the
                                //    Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        padding: EdgeInsets.only(top: 0),
                      ),
                    ),
                  ],
                ),

                )



          );
        });
  }

  Stream<DocumentSnapshot> provideDocumentFieldStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('pets')
        .doc(petlist.elementAt(petdex)['name'].toString())
        .collection('data')
        .doc(  chartlist[chartdex].id  )
        .snapshots();
  }
}

class ChartData {
  ChartData(this.year, this.val);

  final String year;
  final num? val;
}
