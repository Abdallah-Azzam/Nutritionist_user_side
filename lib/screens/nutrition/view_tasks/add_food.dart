import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/models/nutrition_items/breakfast_items.dart';
import 'package:new_template/models/nutrition_items/dinner_items.dart';
import 'package:new_template/models/nutrition_items/lunch_items.dart';
import 'package:new_template/provider/nutrition_provider/breakfast.dart';
import 'package:new_template/provider/nutrition_provider/dinner.dart';
import 'package:new_template/provider/nutrition_provider/lunch.dart';
import 'package:new_template/widgets/bottom_bar.dart';
import 'package:new_template/widgets/nutrition_products/breakfast_product.dart';
import 'package:new_template/widgets/nutrition_products/dinner_product.dart';
import 'package:new_template/widgets/nutrition_products/lunch_product.dart';
import 'package:provider/provider.dart';

class AddFood extends StatefulWidget {
  static String name = 'add food';
  final int i;
  final String uid;
  AddFood(this.uid, this.i);
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    return widget.i == 1
        ? BreakFastView(DateTime.now(), widget.uid)
        : widget.i == 2
            ? LunchView(DateTime.now(), widget.uid)
            : DinnerView(DateTime.now(), widget.uid);
  }
}

class BreakFastView extends StatefulWidget {
  final DateTime day;
  final String uid;
  BreakFastView(this.day, this.uid);

  @override
  _BreakFastViewState createState() => _BreakFastViewState();
}

class _BreakFastViewState extends State<BreakFastView> {
  @override
  void initState() {
    getDataBase();
    super.initState();
  }

  List finalBreakfast = [];
  List finalDinner = [];
  List finalLunch = [];
  List doneBreakfast = [];
  List finalDoneLunch = [];
  List finalDoneDinner = [];
  List finalDoneBreakfast = [];
  getDataBase() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()).toString())
        .get();
    print(DateFormat('dd-MM').format(DateTime.now()));
    print(widget.uid);
    try {
      doneBreakfast = List.from(doc['DoneBreakfast']);
    } catch (e) {}
    try {} catch (e) {}
    try {
      finalDoneLunch = List.from(doc['DoneLunch']);
    } catch (e) {}
    try {
      finalDoneDinner = List.from(doc['DoneDinner']);
    } catch (e) {}
    try {
      finalBreakfast = List.from(doc['Breakfast']);
    } catch (e) {}
    try {
      finalLunch = List.from(doc['Lunch']);
    } catch (e) {}
    try {
      finalDinner = List.from(doc['Dinner']);
    } catch (e) {}
    try {
      doneBreakfast = List.from(doc['DoneBreakfast']);
    } catch (e) {}
  }

  List userAddedBreakfast = [];
  updateDataBase() async {
    userAddedBreakfast.addAll(BreakFastProducts.addedItems);
    print(userAddedBreakfast);
    List compare = List.of(userAddedBreakfast);
    List finalUserAddedBreakfast = [];
    compare.sort();
    print(compare);
    //for (int i = 0; i < compare.length; i++) {
    int i = 1;
    while (compare.length > 0) {
      String g = compare[0];
      compare.removeAt(0);
      // while (compare.contains(g) && finalBreakfast.contains(g)) {
      //   compare.remove(g);
      //   print('[]$compare');
      // }
      if (!compare.contains(g) && !finalUserAddedBreakfast.contains(g)) {
        print(finalUserAddedBreakfast);
        compare.remove(g);

        finalUserAddedBreakfast.add('$g x$i');
        i = 1;
      } else {
        i++;
      }
    }
    doneBreakfast.addAll(finalUserAddedBreakfast);

    // List compare = List.of(doneBreakfast);
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
    //   if (!compare.contains(g) && !finalDoneBreakfast.contains(g)) {
    //     print(finalDoneBreakfast);
    //     compare.remove(g);
    //
    //     finalDoneBreakfast.add('$g x$i');
    //     i = 1;
    //   } else {
    //     i++;
    //   }
    // }

    // await userCollection
    //     .doc(widget.uid)
    //     .collection('schedule')
    //     .doc(DateFormat('dd-MM').format(widget.day))
    //     .delete();
    await userCollection
        .doc(widget.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()))
        .set({
          'Breakfast': finalBreakfast,
          'Lunch': finalLunch,
          'Dinner': finalDinner,
          'DoneBreakfast': doneBreakfast,
          'DoneDinner': finalDoneDinner,
          'DoneLunch': finalDoneLunch
        })
        .whenComplete(() => BreakFastProducts.addedItems
            .removeRange(0, BreakFastProducts.addedItems.length))
        .whenComplete(() => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Items Added'))))
        .whenComplete(() => Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomBar())))
        .whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<Breakfast>(context);
    List<ItemBreakfast> itemList = itemProvider.item;

    return Scaffold(
      appBar: AppBar(
        title: Text('Breakfast'),
      ),
      backgroundColor: Colors.white,
      bottomSheet: BottomAppBar(
        child: InkWell(
          onTap: () {
            updateDataBase();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(141, 30, 23, 1),
                    Color.fromRGBO(141, 30, 23, 0.3)
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add food',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: itemList[index],
                        child: Column(
                          children: [
                            BreakFastProducts(widget.uid, widget.day),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // StaggeredGridView.countBuilder(
                //   physics: NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   crossAxisCount: 4,
                //   itemCount: itemList.length,
                //   itemBuilder: (BuildContext context, int index) =>
                //       ChangeNotifierProvider.value(
                //     value: itemList[index],
                //     child: BreakFastProducts(widget.uid, widget.day),
                //   ),
                //   staggeredTileBuilder: (int index) =>
                //       new StaggeredTile.count(2, index.isEven ? 4 : 5),
                //   mainAxisSpacing: 1.0,
                //   crossAxisSpacing: 10.0,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LunchView extends StatefulWidget {
  final DateTime day;
  final String uid;
  LunchView(this.day, this.uid);
  @override
  _LunchViewState createState() => _LunchViewState();
}

class _LunchViewState extends State<LunchView> {
  @override
  void initState() {
    getDataBase();
    super.initState();
  }

  List userAddedLunch = [];
  List finalDinner = [];
  List finalLunch = [];
  List finalBreakfast = [];
  List finalDoneLunch = [];
  List finalDoneDinner = [];
  List finalDoneBreakfast = [];
  getDataBase() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()).toString())
        .get();
    print(DateFormat('dd-MM').format(DateTime.now()));
    print(widget.uid);
    try {
      finalDoneBreakfast = List.from(doc['DoneBreakfast']);
    } catch (e) {}
    try {
      finalDoneLunch = List.from(doc['DoneLunch']);
    } catch (e) {}
    try {
      finalDoneDinner = List.from(doc['DoneDinner']);
    } catch (e) {}
    try {
      finalBreakfast = List.from(doc['Breakfast']);
    } catch (e) {}
    try {
      finalLunch = List.from(doc['Lunch']);
    } catch (e) {}
    try {
      finalDinner = List.from(doc['Dinner']);
    } catch (e) {}
  }

  updateDataBase() async {
    userAddedLunch.addAll(LunchProducts.addedItems);
    List compare = List.of(userAddedLunch);
    List finalUserAddedLunch = [];
    compare.sort();
    print(compare);
    //for (int i = 0; i < compare.length; i++) {
    int i = 1;
    while (compare.length > 0) {
      String g = compare[0];
      compare.removeAt(0);
      // while (compare.contains(g) && finalBreakfast.contains(g)) {
      //   compare.remove(g);
      //   print('[]$compare');
      // }
      if (!compare.contains(g) && !finalUserAddedLunch.contains(g)) {
        print(finalUserAddedLunch);
        compare.remove(g);

        finalUserAddedLunch.add('$g x$i');
        i = 1;
      } else {
        i++;
      }
    }
    finalDoneLunch.addAll(finalUserAddedLunch);

    await userCollection
        .doc(widget.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()))
        .set({
          'Breakfast': finalBreakfast,
          'Lunch': finalLunch,
          'Dinner': finalDinner,
          'DoneBreakfast': finalDoneBreakfast,
          'DoneDinner': finalDoneDinner,
          'DoneLunch': finalDoneLunch
        })
        .whenComplete(() => LunchProducts.addedItems
            .removeRange(0, LunchProducts.addedItems.length))
        .whenComplete(() => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Items Added'))))
        .whenComplete(() => Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomBar())))
        .whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<Lunch>(context);
    List<ItemLunch> itemList = itemProvider.item;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunch'),
      ),
      backgroundColor: Colors.white,
      bottomSheet: InkWell(
        onTap: () {
          updateDataBase();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(141, 30, 23, 1),
                  Color.fromRGBO(141, 30, 23, 0.3)
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add food',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: itemList[index],
                  child: Column(
                    children: [
                      LunchProducts(widget.uid, widget.day),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DinnerView extends StatefulWidget {
  final DateTime day;
  final String uid;
  DinnerView(this.day, this.uid);
  @override
  _DinnerViewState createState() => _DinnerViewState();
}

class _DinnerViewState extends State<DinnerView> {
  @override
  void initState() {
    getDataBase();
    super.initState();
  }

  List finalDinner = [];
  List finalLunch = [];
  List finalBreakfast = [];
  List finalDoneLunch = [];
  List doneDinner = [];
  List finalDoneBreakfast = [];
  getDataBase() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await userCollection
        .doc(fireBaseUser.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()).toString())
        .get();
    print(DateFormat('dd-MM').format(DateTime.now()));
    print(widget.uid);
    try {
      finalDoneBreakfast = List.from(doc['DoneBreakfast']);
    } catch (e) {}
    try {
      finalDoneLunch = List.from(doc['DoneLunch']);
    } catch (e) {}
    try {
      doneDinner = List.from(doc['DoneDinner']);
    } catch (e) {}
    try {
      finalBreakfast = List.from(doc['Breakfast']);
    } catch (e) {}
    try {
      finalLunch = List.from(doc['Lunch']);
    } catch (e) {}
    try {
      finalDinner = List.from(doc['Dinner']);
    } catch (e) {}
  }

  updateDataBase() async {
    userAddedDinner.addAll(DinnerProducts.addedItems);
    print(doneDinner);
    userAddedDinner.addAll(LunchProducts.addedItems);
    List compare = List.of(userAddedDinner);
    List finalUserAddedDinner = [];
    compare.sort();
    print(compare);
    //for (int i = 0; i < compare.length; i++) {
    int i = 1;
    while (compare.length > 0) {
      String g = compare[0];
      compare.removeAt(0);
      // while (compare.contains(g) && finalBreakfast.contains(g)) {
      //   compare.remove(g);
      //   print('[]$compare');
      // }
      if (!compare.contains(g) && !finalUserAddedDinner.contains(g)) {
        print(finalUserAddedDinner);
        compare.remove(g);

        finalUserAddedDinner.add('$g x$i');
        i = 1;
      } else {
        i++;
      }
    }
    doneDinner.addAll(finalUserAddedDinner);

    await userCollection
        .doc(widget.uid)
        .collection('schedule')
        .doc(DateFormat("dd-MM").format(DateTime.now()))
        .set({
          'Breakfast': finalBreakfast,
          'Lunch': finalLunch,
          'Dinner': finalDinner,
          'DoneBreakfast': finalDoneBreakfast,
          'DoneDinner': doneDinner,
          'DoneLunch': finalDoneLunch
        })
        .whenComplete(() => DinnerProducts.addedItems
            .removeRange(0, DinnerProducts.addedItems.length))
        .whenComplete(() => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Items Added'))))
        .whenComplete(() => Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomBar()))
            .whenComplete(() => Navigator.pop(context)));
  }

  List userAddedDinner = [];
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<Dinner>(context);
    List<ItemDinner> itemList = itemProvider.item;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dinner'),
      ),
      bottomSheet: InkWell(
        onTap: () {
          updateDataBase();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(141, 30, 23, 1),
                  Color.fromRGBO(141, 30, 23, 0.3)
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add food',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: itemList[index],
                  child: Column(
                    children: [
                      DinnerProducts(widget.uid, widget.day),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
