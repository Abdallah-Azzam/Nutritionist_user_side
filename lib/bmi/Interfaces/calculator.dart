import 'package:new_template/bmi/reuseables/constants.dart';
import 'package:flutter/material.dart';
import 'package:new_template/bmi/reuseables/reusable_widget.dart';

class ResultPage extends StatelessWidget {
  ResultPage(this.result, this.calculation, this.interpertation);
  final String result;
  final String interpertation;
  final String calculation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Result Page',
          style: kWrighting,
        )),
        body: SafeArea(
          child: Column(
            children: [
              Reusable(
                  cardChild: Column(
                    children: [
                      Text(
                        'Your Result',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  colour: Color(0xff1308a1)),
              Expanded(
                flex: 5,
                child: Reusable(
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          result,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color(0xff24de15),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          calculation,
                          style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          interpertation,
                          style: kWrighting,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    colour: kActive),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Text(
                    'Re-Calculate',
                    style: kWrighting,
                    textAlign: TextAlign.center,
                  ),
                  height: 80,
                  padding: EdgeInsets.only(top: 10),
                  margin: EdgeInsets.only(top: 10),
                  color: kBottomAppBarColor,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ));
  }
}
