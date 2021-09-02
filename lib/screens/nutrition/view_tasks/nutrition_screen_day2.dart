import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen_by_week.dart';

class NutritionScreenByDay2 extends StatefulWidget {
  const NutritionScreenByDay2({Key? key}) : super(key: key);
  @override
  _NutritionScreenByDay2State createState() => _NutritionScreenByDay2State();
}

class _NutritionScreenByDay2State extends State<NutritionScreenByDay2> {
  late Stream<DocumentSnapshot> tomorrowStream;
  ScrollController? controller;
  String? uid;
  bool loading = true;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    setState(() {
      uid = userDoc['uid'];
    });
    loading = false;
  }

  late DateTime now;
  List breakFast = [];
  List lunch = [];
  List dinner = [];
  getStream() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    now = DateTime.now().add(Duration(days: 1));
    setState(() {
      tomorrowStream = userCollection
          .doc(fireBaseUser.uid)
          .collection('schedule')
          .doc(DateFormat("dd-MM").format(now))
          .snapshots();
    });
    DocumentSnapshot userDoc = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(now))
        .get();
    setState(
      () {
        try {
          breakFast = List.from(userDoc['Breakfast']);
        } catch (e) {}
        try {
          lunch = List.from(userDoc['Lunch']);
        } catch (e) {}
        try {
          dinner = List.from(userDoc['Dinner']);
        } catch (e) {}
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    controller = ScrollController();
    getStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NutritionScreenMain.value = false;
    return loading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                  Icons.shopping_cart_outlined,
                                  color: Color.fromRGBO(141, 30, 23, 1),
                                ),
                              ),
                              onTap: () {
                                // setState(() {
                                //   NutritionScreenMain.value =
                                //       !NutritionScreenMain.value;
                                // });
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return NutritionScreenMain();
                                // }));
                                showBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        NutritionScreenByWeek());
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
                    'Tomorrow\'s Schedule',
                    style: TextStyle(
                        fontFamily: 'Tajwal',
                        color: Color.fromRGBO(36, 51, 72, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Divider(
                              thickness: 0.5,
                            ),

                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(141, 30, 23, 1),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12))),
                                    child: Icon(
                                      Icons.more_vert,
                                    )),
                              ],
                            ),
                            if (breakFast.isNotEmpty)
                              //TaskTile(breakFast[i]),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  color: Colors.white,
                                  elevation: 6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        color:
                                            Color.fromRGBO(146, 168, 189, 0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' Breakfast',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DottedLine(
                                        dashColor:
                                            Color.fromRGBO(36, 51, 72, 0.4),
                                        lineThickness: 0.3,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      for (int i = 0; i < breakFast.length; i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${breakFast[i]}',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          36, 51, 72, 1)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      // if (userAddedBreakfast.isNotEmpty)
                                      //   for (int i = 0;
                                      //       i < userAddedBreakfast.length;
                                      //       i++)
                                      //     Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         Row(
                                      //           children: [
                                      //             InkWell(
                                      //               child: Icon(
                                      //                 Icons.check_box,
                                      //                 color:
                                      //                     Color.fromRGBO(
                                      //                         36,
                                      //                         51,
                                      //                         72,
                                      //                         1),
                                      //               ),
                                      //               onTap: () {
                                      //                 setState(() {
                                      //                   String g =
                                      //                       userAddedBreakfast[
                                      //                           i];
                                      //                   redoDoneBreakfastFromUser(
                                      //                       g);
                                      //                   userAddedBreakfast
                                      //                       .removeAt(i);
                                      //                 });
                                      //               },
                                      //             ),
                                      //             SizedBox(
                                      //               width: 5,
                                      //             ),
                                      //             Text(
                                      //               '${userAddedBreakfast[i]}',
                                      //               style: TextStyle(
                                      //                   decoration:
                                      //                       TextDecoration
                                      //                           .lineThrough,
                                      //                   color: Color
                                      //                       .fromRGBO(
                                      //                           36,
                                      //                           51,
                                      //                           72,
                                      //                           1)),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //         SizedBox(
                                      //           height: 8,
                                      //         ),
                                      //       ],
                                      //     ),
                                    ],
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 39.0, top: 7),
                            ),
                            // DottedLine(
                            //   dashColor: Color.fromRGBO(36, 51, 72, 1),
                            //   lineThickness: 2,
                            // ),
                            if (lunch.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  // color: Color.fromRGBO(146, 168, 189, 1),

                                  elevation: 6,

                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        color:
                                            Color.fromRGBO(146, 168, 189, 0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' Lunch',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DottedLine(
                                        dashColor:
                                            Color.fromRGBO(36, 51, 72, 0.4),
                                        lineThickness: 0.3,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      for (int i = 0; i < lunch.length; i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(lunch[i]),
                                              ],
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
                            // DottedLine(
                            //   dashColor: Colors.green,
                            //   lineThickness: 2,
                            // ),
                            if (dinner.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  // color: Color.fromRGBO(146, 168, 189, 1),

                                  elevation: 6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        color:
                                            Color.fromRGBO(146, 168, 189, 0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' Dinner',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DottedLine(
                                        dashColor:
                                            Color.fromRGBO(36, 51, 72, 0.4),
                                        lineThickness: 0.3,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      for (int i = 0; i < dinner.length; i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(dinner[i]),
                                              ],
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
                            if (dinner.isEmpty &&
                                lunch.isEmpty &&
                                breakFast.isEmpty)
                              Center(
                                  child: Text(
                                'Nothing to show',
                                style: TextStyle(
                                    fontFamily: 'Tajwal',
                                    fontWeight: FontWeight.w600),
                              )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]);
  }
}
