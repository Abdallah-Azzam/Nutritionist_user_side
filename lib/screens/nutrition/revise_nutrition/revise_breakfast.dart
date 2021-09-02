// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:new_template/constants/constants.dart';
// import 'package:new_template/widgets/bottom_bar.dart';
//
// class ReviseBreakFast extends StatefulWidget {
//   final String uid;
//   final DateTime day;
//   final List<String> addedItems;
//
//   ReviseBreakFast(this.uid, this.day, this.addedItems);
//
//   @override
//   _ReviseBreakFastState createState() => _ReviseBreakFastState();
// }
//
// class _ReviseBreakFastState extends State<ReviseBreakFast> {
//   List breakfast = [];
//   List finalLunch = [];
//   List finalDinner = [];
//   getDataBase() async {
//     var fireBaseUser = FirebaseAuth.instance.currentUser!;
//     DocumentSnapshot doc = await userCollection
//         .doc(fireBaseUser.uid)
//         .collection('schedule')
//         .doc(DateFormat("dd-MM").format(DateTime.now()).toString())
//         .get();
//     print(DateFormat('dd-MM').format(DateTime.now()));
//     print(widget.uid);
//     breakfast = List.from(doc['Breakfast']);
//     finalLunch = List.from(doc['Lunch']);
//     finalDinner = List.from(doc['Dinner']);
//
//     print(breakfast);
//     print(finalLunch);
//     print(finalDinner);
//   }
//
//   updateDataBase() async {
//     breakfast.addAll(widget.addedItems);
//     print(breakfast);
//     await userCollection
//         .doc(widget.uid)
//         .collection('schedule')
//         .doc(DateFormat('dd-MM').format(widget.day))
//         .delete();
//     await userCollection
//         .doc(widget.uid)
//         .collection('schedule')
//         .doc(DateFormat("dd-MM").format(DateTime.now()))
//         .set({
//           'Breakfast': breakfast,
//           'Lunch': finalLunch,
//           'Dinner': finalDinner
//         })
//         .whenComplete(() => ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Items Added'))))
//         .whenComplete(
//             () => widget.addedItems.removeRange(0, widget.addedItems.length))
//         .whenComplete(() => Navigator.push(
//             context, MaterialPageRoute(builder: (context) => BottomBar())));
//   }
//
//   int quantity = 0;
//   @override
//   void initState() {
//     getDataBase();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(widget.addedItems);
//     // for (int i = 0; i < widget.addedItems.length; i++)
//     //   for (int j = 0; j < i; j++)
//     //     if (widget.addedItems[j] == widget.addedItems[i]) {
//     //       setState(() {
//     //         quantity++;
//     //         widget.addedItems.removeAt(i);
//     //       });
//     //     }
//     // final itemProvider = Provider.of<Item>(context);
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               for (String i in widget.addedItems)
//                 Row(
//                   children: [
//                     Text(i),
//                     InkWell(
//                       child: Icon(Icons.remove),
//                       onTap: () {
//                         setState(() {
//                           widget.addedItems.remove(i);
//                         });
//                       },
//                     )
//                   ],
//                 ),
//               InkWell(
//                 onTap: () {
//                   updateDataBase();
//                 },
//                 child: Icon(Icons.done),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
