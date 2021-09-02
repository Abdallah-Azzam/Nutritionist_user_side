import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/bmi/Calculations/bmiBrain.dart';
import 'package:new_template/bmi/reuseables/RawButton.dart';
import 'package:new_template/bmi/reuseables/constants.dart';
import 'package:new_template/bmi/reuseables/reusable_widget.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/feeds/chart.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

int firstWeight = 180;

class _ProgressState extends State<Progress> {
  PageController? pageController;
  String? height;
  String? initialWeight;
  String? currentWeight;
  String? targetBodyType;
  bool loading = true;
  String? targetWeight;
  currentUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot document =
        await userCollection.doc(fireBaseUser.uid).get();

    setState(() {
      height = document['height'];
      initialWeight = document['initialWeight'];
      currentWeight = document['currentWeight'];
      targetWeight = document['targetWeight'];
      targetBodyType = document['targetBodyType'];
    });

    loading = false;
  }

  String? currentWeightBmi;
  String? heightBmi;
  bool loadingBmi = true;
  currentUserBmiInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot document =
        await userCollection.doc(fireBaseUser.uid).get();
    setState(() {
      try {
        currentWeightBmi = document['currentWeight'];
      } catch (e) {}
      try {
        heightBmi = document['height'];
      } catch (e) {}
      try {
        height1 = int.parse(height!);
      } catch (e) {}
      try {
        weight = int.parse(currentWeight!);
      } catch (e) {}
    });

    loadingBmi = false;
  }

  update() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    await userCollection.doc(fireBaseUser.uid).update({
      'currentWeight': weight.toString(),
    });
    await userCollection
        .doc(fireBaseUser.uid)
        .collection('progress')
        .doc('09-08')
        .update({
      'weight': FieldValue.arrayUnion([weight.toString()]),
    });
  }

  int? weight;
  int? height1;
  @override
  void initState() {
    currentUserBmiInfo();
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUserInfo();
    return loading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : PageView(
            scrollDirection: Axis.vertical,
            controller: pageController,
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: 1,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 10),
                              child: Text(
                                'Basic Info:',
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 51, 72, 1),
                                    fontFamily: 'Tajwal',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                                // color: Colors.white70
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Height:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'CM ${height.toString()}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'FirstWeight:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'KG ${initialWeight!}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'currentWeight:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'KG ${currentWeight!}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Target weight:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'kg ${targetWeight!}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Goal: ',
                                        style: TextStyle(
                                            fontFamily: 'Tajwal',
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        targetBodyType!,
                                        style: TextStyle(
                                            fontFamily: 'Tajwal',
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Way to go:',
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 51, 72, 1),
                                    fontFamily: 'Tajwal',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black)
                                  // color: Color.fromRGBO(146, 168, 189, 1)
                                  ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'WeightDiff:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      if (int.parse(currentWeight!) -
                                              int.parse(initialWeight!) <=
                                          0)
                                        Text(
                                          '${(int.parse(initialWeight!) - int.parse(currentWeight!)).toString()}kg lost',
                                          style: TextStyle(
                                              fontFamily: 'Tajwal',
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                      if (int.parse(currentWeight!) -
                                              int.parse(initialWeight!) >
                                          0)
                                        Text(
                                          '${(int.parse(currentWeight!) - int.parse(initialWeight!)).toString()}kg gained',
                                          style: TextStyle(
                                              fontFamily: 'Tajwal',
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'GoalDiff:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      if (int.parse(currentWeight!) -
                                              int.parse(targetWeight!) >=
                                          0)
                                        Text(
                                          '${(int.parse(currentWeight!) - int.parse(targetWeight!)).toString()}kg to lose',
                                          style: TextStyle(
                                              fontFamily: 'Tajwal',
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        )
                                      else
                                        Text(
                                          '${(int.parse(targetWeight!) - int.parse(currentWeight!)).toString()}kg to gain',
                                          style: TextStyle(
                                              fontFamily: 'Tajwal',
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        )
                                    ],
                                  ),
                                  Divider(
                                      color: Color.fromRGBO(36, 51, 72, 1),
                                      thickness: 0.6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'BMI Score:',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        BmiBrain(int.parse(height!),
                                                int.parse(currentWeight!))
                                            .bmiCalculation(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),
                                            fontFamily: 'Tajwal',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    currentUserBmiInfo();
                                    pageController!.nextPage(
                                        duration: Duration(milliseconds: 450),
                                        curve: Curves.decelerate);
                                    // Navigator.push(
                                    //     context,
                                    //     (MaterialPageRoute(
                                    //         builder: (context) => MyBmi())));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(141, 30, 23, 1),
                                        Color.fromRGBO(141, 30, 23, 0.5)
                                      ]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Update weight',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Tajwal',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Card(
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 40, top: 10),
                              child: Chart(),
                            )
                          ],
                        );
                      }),
                ),
              ),
              loadingBmi
                  ? Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(141, 30, 23, 1),
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(12))),
                                  child: Icon(Icons.more_horiz),
                                )
                              ],
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Reusable(
                                      cardChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Weight',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),
                                              fontFamily: 'Tajwal',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                weight.toString(),
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1),
                                                  fontFamily: 'Tajwal',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'kg',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1),
                                                  fontFamily: 'Tajwal',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: Color.fromRGBO(
                                                        146, 168, 189, 1),
                                                  ),
                                                  child: Icon(Icons.remove),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    weight = weight! - 1;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: Color.fromRGBO(
                                                        146, 168, 189, 1),
                                                  ),
                                                  child: Icon(Icons.add),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    weight = weight! + 1;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      colour: kActive,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                update();
                                currentUserInfo();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Weight Updated')));
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: kWrighting,
                                  ),
                                ),
                                height: 80,
                                padding: EdgeInsets.only(top: 10),
                                margin: EdgeInsets.only(top: 10),
                                color: Color.fromRGBO(213, 67, 60, 1),
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          );
  }
}
// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width / 4),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // // margin: EdgeInsets.symmetric(
//     // //   horizontal:
//     // //       MediaQuery.of(context).size.width / 4,
//     // ),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'FirstWeight:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         Text(
//           initialWeight!,
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         )
//       ],
//     ),
//   ),
// ),
// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width * 0.2,
//       vertical: 10),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4,
//     //     vertical: 10),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'currentWeight:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         Text(
//           currentWeight!,
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         )
//       ],
//     ),
//   ),
// ),

// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width * 0.14,
//       vertical: 10),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4,
//     //     vertical: 10),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Target weight:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         Text(
//           '${targetWeight!}kg',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         )
//       ],
//     ),
//   ),
// ),

// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width / 4,
//       vertical: 10),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4,
//     //     vertical: 10),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Goal: ',
//           style: TextStyle(
//               fontFamily: 'Tajwal',
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         Text(
//           targetBodyType!,
//           style: TextStyle(
//               fontFamily: 'Tajwal',
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         )
//       ],
//     ),
//   ),
// ),

//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width * 0.11),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'WeightDiff:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         if (int.parse(currentWeight!) -
//                 int.parse(initialWeight!) <=
//             0)
//           Text(
//             '${(int.parse(initialWeight!) - int.parse(currentWeight!)).toString()}kg lost',
//             style: TextStyle(
//                 fontFamily: 'Tajwal',
//                 color:
//                     Color.fromRGBO(36, 51, 72, 1),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20),
//           ),
//         if (int.parse(currentWeight!) -
//                 int.parse(initialWeight!) >
//             0)
//           Text(
//             '${(int.parse(currentWeight!) - int.parse(initialWeight!)).toString()}kg gained',
//             style: TextStyle(
//                 fontFamily: 'Tajwal',
//                 color:
//                     Color.fromRGBO(36, 51, 72, 1),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20),
//           )
//       ],
//     ),
//   ),
// ),
// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width * 0.18),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'GoalDiff:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         if (int.parse(currentWeight!) -
//                 int.parse(targetWeight!) >=
//             0)
//           Text(
//             '${(int.parse(currentWeight!) - int.parse(targetWeight!)).toString()}kg to lose',
//             style: TextStyle(
//                 fontFamily: 'Tajwal',
//                 color:
//                     Color.fromRGBO(36, 51, 72, 1),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20),
//           )
//         else
//           Text(
//             '${(int.parse(targetWeight!) - int.parse(currentWeight!)).toString()}kg to gain',
//             style: TextStyle(
//                 fontFamily: 'Tajwal',
//                 color:
//                     Color.fromRGBO(36, 51, 72, 1),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20),
//           )
//       ],
//     ),
//   ),
// ),
// Card(
//   elevation: 10,
//   margin: EdgeInsets.symmetric(
//       horizontal:
//           MediaQuery.of(context).size.width / 4),
//   color: Color.fromRGBO(146, 168, 189, 1),
//   child: Container(
//     // margin: EdgeInsets.symmetric(
//     //     horizontal:
//     //         MediaQuery.of(context).size.width / 4),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white),
//         color: Color.fromRGBO(36, 51, 72, 0.4)),
//     padding: const EdgeInsets.only(
//         left: 5, top: 2, right: 5),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'BMI Score:',
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         ),
//         Text(
//           BmiBrain(int.parse(height!),
//                   int.parse(currentWeight!))
//               .bmiCalculation(),
//           style: TextStyle(
//               color: Color.fromRGBO(36, 51, 72, 1),
//               fontFamily: 'Tajwal',
//               fontWeight: FontWeight.w600,
//               fontSize: 20),
//         )
//       ],
//     ),
//   ),
// ),
