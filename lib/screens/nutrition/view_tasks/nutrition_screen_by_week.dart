import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen.dart';

class NutritionScreenByWeek extends StatefulWidget {
  @override
  _NutritionScreenByWeekState createState() => _NutritionScreenByWeekState();
}

class _NutritionScreenByWeekState extends State<NutritionScreenByWeek> {
  ScrollController? controller;
  List finalDinner = [];
  List finalLunch = [];
  List finalBreakfast = [];
  late DateTime now;
  List breakFast = [];
  List lunch = [];
  List dinner = [];
  late Stream<DocumentSnapshot> todayStream;
  getStream() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    now = DateTime.now();

    DocumentSnapshot userDoc0 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 0))))
        .get();

    DocumentSnapshot userDoc1 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 1))))
        .get();

    DocumentSnapshot userDoc2 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 2))))
        .get();

    DocumentSnapshot userDoc3 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 3))))
        .get();

    DocumentSnapshot userDoc4 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 4))))
        .get();
    DocumentSnapshot userDoc5 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 5))))
        .get();
    DocumentSnapshot userDoc6 = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now.add(Duration(days: 5))))
        .get();
    setState(() {
      try {
        breakFast.addAll(userDoc0['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc1['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc2['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc3['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc4['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc5['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc6['weekBreakfast']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc0['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc1['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc2['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc3['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc4['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc6['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc5['weekLunch']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc0['weekDinner']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc1['weekDinner']);
      } catch (e) {}

      try {
        breakFast.addAll(userDoc2['weekDinner']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc3['weekDinner']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc4['weekDinner']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc5['weekDinner']);
      } catch (e) {}
      try {
        breakFast.addAll(userDoc6['weekDinner']);
      } catch (e) {}

      try {
        List compare = List.of(breakFast);
        compare.sort();
        print(compare);
        //for (int i = 0; i < compare.length; i++) {
        int i = 1;
        while (compare.length > 0) {
          String g = compare[0];
          compare.removeAt(0);
          if (!compare.contains(g) && !finalBreakfast.contains(g)) {
            print(finalBreakfast);
            compare.remove(g);

            finalBreakfast.add('$g x$i');
            i = 1;
          } else {
            i++;
          }
        }
      } catch (e) {}
    });
    loading = false;
  }

  @override
  void initState() {
    controller = ScrollController();
    getStream();
    super.initState();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    NutritionScreenMain.value = false;
    return loading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Color.fromRGBO(141, 30, 23, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      NutritionScreenMain.value =
                                          !NutritionScreenMain.value;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Grocery List',
                        style: TextStyle(
                            fontFamily: 'Tajwal',
                            color: Color.fromRGBO(36, 51, 72, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < finalBreakfast.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                color: Colors.white,
                                elevation: 3,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // DottedLine(
                                    //   lineThickness: 0.3,
                                    // ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '${finalBreakfast[i]}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    36, 51, 72, 1)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          );
  }
}
