import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool loading = true;
  @override
  void initState() {
    loadProgressData();
    super.initState();
  }

  List weight = [];
  List<ProgressData> chartData = [];
  Future loadProgressData() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot docLength = await userCollection
        .doc(fireBaseUser?.uid)
        .collection('progress')
        .doc('09-08')
        .get();
    setState(() {
      weight.addAll(docLength['weight']);

      try {
        for (int i = 0; i < weight.length; i++)
          chartData.add(
            ProgressData('week$i', double.parse(weight[i])),
          );
      } catch (e) {
        print(e);
      }
    });

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : SfCartesianChart(
            title: ChartTitle(
              text: 'Progress',
            ),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
                LineSeries<ProgressData, String>(
                  color: Color.fromRGBO(141, 30, 23, 1),
                  dataSource: chartData,
                  xValueMapper: (ProgressData progress, _) => progress.week,
                  yValueMapper: (ProgressData progress, _) => progress.weight,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
              ]);
    // : SfCartesianChart(
    //     tooltipBehavior: TooltipBehavior(enable: true),
    //     title: ChartTitle(text: 'Progress'),
    //     primaryXAxis: CategoryAxis(),
    //     series: <ChartSeries>[
    //       LineSeries<ProgressData, String>(
    //           enableTooltip: false,
    //           dataSource: chartData,
    //           dataLabelSettings: DataLabelSettings(isVisible: true),
    //           xValueMapper: (ProgressData progress, _) => progress.week,
    //           yValueMapper: (ProgressData progress, _) => progress.weight),
    //     ],
    //   );
  }
}

class ProgressData {
  ProgressData(this.week, this.weight);
  final String week;
  final double weight;
}
