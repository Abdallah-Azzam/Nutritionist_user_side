import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen_by_week.dart';
import '../../../widgets/bottom_bar.dart';
import 'package:intl/intl.dart';
import 'add_food.dart';

class NutritionScreenByDay1 extends StatefulWidget {
  @override
  _NutritionScreenByDay1State createState() => _NutritionScreenByDay1State();
}

class _NutritionScreenByDay1State extends State<NutritionScreenByDay1> {
  late Stream<DocumentSnapshot> todayStream;

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

  //
  // int getItems(String g) {
  //   int i = 1;
  //   setState(() {
  //     compare = List.of(breakFast);
  //     //for (int i = 0; i < compare.length; i++) {
  //     while (compare.length > 0) {
  //       compare.removeAt(0);
  //       if (compare.contains(g) && finalBreakfast.contains(g)) {
  //         compare.remove(g);
  //         i++;
  //       } else if (!compare.contains(g) && !finalBreakfast.contains(g)) {
  //         i++;
  //         finalBreakfast.add(g);
  //         compare.remove(g);
  //       } else {}
  //       print(finalBreakfast);
  //     }
  //   });
  //   return i;
  // }
  List doneBreakfast = [];
  List userAddedLunch = [];
  List doneLunch = [];
  List doneDinner = [];
  List userAddedBreakfast = [];
  List finalDinner = [];
  List finalLunch = [];
  List finalBreakfast = [];
  late DateTime now;
  getStream() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    now = DateTime.now();
    setState(() {
      todayStream = userCollection
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

    setState(() {
      try {
        finalBreakfast = List.from(userDoc['Breakfast']);
      } catch (e) {}
      try {
        doneBreakfast = List.from(userDoc['DoneBreakfast']);
      } catch (e) {
        print(e);
      }
      try {
        finalLunch = List.from(userDoc['Lunch']);
      } catch (e) {}
      try {
        doneLunch = List.from(userDoc['DoneLunch']);
      } catch (e) {}
      try {
        userAddedBreakfast = List.from(userDoc['UserAddedBreakfast']);
        // List compare = List.of(userAddedBreakfast);
        // List finalUserAddedBreakfast = [];
        // compare.sort();
        // print(compare);
        // //for (int i = 0; i < compare.length; i++) {
        // int i = 1;
        // while (compare.length > 0) {
        //   String g = compare[0];
        //   compare.removeAt(0);
        //   // while (compare.contains(g) && finalBreakfast.contains(g)) {
        //   //   compare.remove(g);
        //   //   print('[]$compare');
        //   // }
        //   if (!compare.contains(g) && !finalUserAddedBreakfast.contains(g)) {
        //     print(finalUserAddedBreakfast);
        //     compare.remove(g);
        //
        //     finalUserAddedBreakfast.add('$g x$i');
        //     i = 1;
        //   } else {
        //     i++;
        //   }
        // }
        // userAddedBreakfast = finalUserAddedBreakfast;
      } catch (e) {}
      try {
        userAddedLunch = List.from(userDoc['UserDoneLunch']);
        // List compare = List.of(userAddedBreakfast);
        // List finalUserAddedBreakfast = [];
        // compare.sort();
        // print(compare);
        // //for (int i = 0; i < compare.length; i++) {
        // int i = 1;
        // while (compare.length > 0) {
        //   String g = compare[0];
        //   compare.removeAt(0);
        //   // while (compare.contains(g) && finalBreakfast.contains(g)) {
        //   //   compare.remove(g);
        //   //   print('[]$compare');
        //   // }
        //   if (!compare.contains(g) && !finalUserAddedBreakfast.contains(g)) {
        //     print(finalUserAddedBreakfast);
        //     compare.remove(g);
        //
        //     finalUserAddedBreakfast.add('$g x$i');
        //     i = 1;
        //   } else {
        //     i++;
        //   }
        // }
        // userAddedBreakfast = finalUserAddedBreakfast;
      } catch (e) {}

      try {
        finalDinner = List.from(userDoc['Dinner']);
      } catch (e) {}
      try {
        doneDinner = List.from(userDoc['DoneDinner']);
      } catch (e) {}
    });
  }

  @override
  void initState() {
    getUserInfo();
    controller = ScrollController();
    getStream();
    super.initState();
  }

  switchView() {
    setState(() {
      NutritionScreenMain.value = true;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BottomBar();
    }));
  }

  redoDoneBreakfast(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneBreakfast': FieldValue.arrayRemove([g]),
      'Breakfast': FieldValue.arrayUnion([g])
    });
    setState(() {
      finalBreakfast.add(g);
    });
  }

  addDoneBreakfast(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneBreakfast': FieldValue.arrayUnion([g]),
      'Breakfast': FieldValue.arrayRemove([g])
    });
    setState(() {
      doneBreakfast.add(g);
    });
  }

  redoDoneLunch(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneLunch': FieldValue.arrayRemove([g]),
      'Lunch': FieldValue.arrayUnion([g])
    });
    setState(() {
      finalLunch.add(g);
    });
  }

  addDoneLunch(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneLunch': FieldValue.arrayUnion([g]),
      'Lunch': FieldValue.arrayRemove([g])
    });
    setState(() {
      doneLunch.add(g);
    });
  }

  redoDoneDinner(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneDinner': FieldValue.arrayRemove([g]),
      'Dinner': FieldValue.arrayUnion([g])
    });
    setState(() {
      finalDinner.add(g);
    });
  }

  addDoneDinner(String g) async {
    await userCollection
        .doc(uid)
        .collection('schedule')
        .doc(DateFormat('dd-MM').format(now))
        .update({
      'DoneDinner': FieldValue.arrayUnion([g]),
      'Dinner': FieldValue.arrayRemove([g])
    });
    setState(() {
      doneDinner.add(g);
    });
  }

  bool isChecked = false;
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
                    'Today\'s Schedule',
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
                    StreamBuilder<DocumentSnapshot>(
                      stream: todayStream,
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        return ListView.builder(
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  141, 30, 23, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12))),
                                          child: Icon(
                                            Icons.more_vert,
                                          )),
                                    ],
                                  ),
                                  if (finalBreakfast.isNotEmpty ||
                                      doneBreakfast.isNotEmpty)
                                    //TaskTile(breakFast[i]),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        color: Colors.white,
                                        elevation: 6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              color: Color.fromRGBO(
                                                  146, 168, 189, 0.4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ' Breakfast',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            36, 51, 72, 1)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DottedLine(
                                              dashColor: Color.fromRGBO(
                                                  36, 51, 72, 0.4),
                                              lineThickness: 0.3,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            for (int i = 0;
                                                i < finalBreakfast.length;
                                                i++)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: Icon(Icons
                                                            .check_box_outline_blank),
                                                        onTap: () {
                                                          setState(() {
                                                            String g =
                                                                finalBreakfast[
                                                                    i];
                                                            addDoneBreakfast(g);
                                                            finalBreakfast
                                                                .remove(g);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '${finalBreakfast[i]}',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    36,
                                                                    51,
                                                                    72,
                                                                    1)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            if (doneBreakfast.isNotEmpty)
                                              for (int i = 0;
                                                  i < doneBreakfast.length;
                                                  i++)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.check_box,
                                                            color:
                                                                Color.fromRGBO(
                                                                    36,
                                                                    51,
                                                                    72,
                                                                    1),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              String g =
                                                                  doneBreakfast[
                                                                      i];
                                                              redoDoneBreakfast(
                                                                  g);
                                                              doneBreakfast
                                                                  .removeAt(i);
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${doneBreakfast[i]}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      36,
                                                                      51,
                                                                      72,
                                                                      1)),
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
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddFood(
                                                                        uid!,
                                                                        1)))
                                                    .whenComplete(() =>
                                                        Navigator.maybePop(
                                                            context));
                                                // showBottomSheet(
                                                //     context: context,
                                                //     builder: (context) =>
                                                //         AddFood(uid!, 1));
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.add,
                                                        color: Color.fromRGBO(
                                                            141, 30, 23, 1)),
                                                    Text(
                                                      'Add food',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              141, 30, 23, 1)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 39.0, top: 7),
                                  ),
                                  // DottedLine(
                                  //   dashColor: Color.fromRGBO(36, 51, 72, 1),
                                  //   lineThickness: 2,
                                  // ),
                                  if (finalLunch.isNotEmpty ||
                                      doneLunch.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        // color: Color.fromRGBO(146, 168, 189, 1),

                                        elevation: 6,

                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              color: Color.fromRGBO(
                                                  146, 168, 189, 0.4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ' Lunch',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            36, 51, 72, 1)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DottedLine(
                                              dashColor: Color.fromRGBO(
                                                  36, 51, 72, 0.4),
                                              lineThickness: 0.3,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            for (int i = 0;
                                                i < finalLunch.length;
                                                i++)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: Icon(Icons
                                                            .check_box_outline_blank),
                                                        onTap: () {
                                                          setState(() {
                                                            String g =
                                                                finalLunch[i];
                                                            addDoneLunch(g);
                                                            finalLunch
                                                                .remove(g);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(finalLunch[i]),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            if (doneLunch.isNotEmpty)
                                              for (int i = 0;
                                                  i < doneLunch.length;
                                                  i++)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.check_box,
                                                            color:
                                                                Color.fromRGBO(
                                                                    36,
                                                                    51,
                                                                    72,
                                                                    1),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              String g =
                                                                  doneLunch[i];
                                                              redoDoneLunch(g);
                                                              doneLunch
                                                                  .removeAt(i);
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${doneLunch[i]}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      36,
                                                                      51,
                                                                      72,
                                                                      1)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddFood(
                                                                        uid!,
                                                                        2)))
                                                    .whenComplete(() =>
                                                        Navigator.maybePop(
                                                            context));
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.add,
                                                        color: Color.fromRGBO(
                                                            141, 30, 23, 1)),
                                                    Text(
                                                      'Add food',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              141, 30, 23, 1)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  // DottedLine(
                                  //   dashColor: Colors.green,
                                  //   lineThickness: 2,
                                  // ),
                                  if (finalDinner.isNotEmpty ||
                                      doneDinner.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        // color: Color.fromRGBO(146, 168, 189, 1),

                                        elevation: 6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              color: Color.fromRGBO(
                                                  146, 168, 189, 0.4),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ' Dinner',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromRGBO(
                                                            36, 51, 72, 1)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DottedLine(
                                              dashColor: Color.fromRGBO(
                                                  36, 51, 72, 0.4),
                                              lineThickness: 0.3,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            for (int i = 0;
                                                i < finalDinner.length;
                                                i++)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        child: Icon(Icons
                                                            .check_box_outline_blank),
                                                        onTap: () {
                                                          setState(() {
                                                            String g =
                                                                finalDinner[i];
                                                            addDoneDinner(g);
                                                            finalDinner
                                                                .remove(g);
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(finalDinner[i]),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            if (doneDinner.isNotEmpty)
                                              for (int i = 0;
                                                  i < doneDinner.length;
                                                  i++)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.check_box,
                                                            color:
                                                                Color.fromRGBO(
                                                                    36,
                                                                    51,
                                                                    72,
                                                                    1),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              String g =
                                                                  doneDinner[i];
                                                              redoDoneDinner(g);
                                                              doneDinner
                                                                  .removeAt(i);
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${doneDinner[i]}',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      36,
                                                                      51,
                                                                      72,
                                                                      1)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddFood(
                                                                        uid!,
                                                                        3)))
                                                    .whenComplete(() =>
                                                        Navigator.maybePop(
                                                            context));
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.add,
                                                        color: Color.fromRGBO(
                                                            141, 30, 23, 1)),
                                                    Text(
                                                      'Add food',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              141, 30, 23, 1)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (finalDinner.isEmpty &&
                                      finalLunch.isEmpty &&
                                      finalBreakfast.isEmpty &&
                                      doneBreakfast.isEmpty &&
                                      doneLunch.isEmpty &&
                                      doneDinner.isEmpty)
                                    Center(
                                        child: Text(
                                      'Nothing to show',
                                      style: TextStyle(
                                          fontFamily: 'Tajwal',
                                          fontWeight: FontWeight.w600),
                                    )),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]);
  }

  bool values = false;
}
