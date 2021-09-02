// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:new_template/constants/constants.dart';
// import 'package:new_template/widgets/bottom_bar.dart';
//
// class ReviseDinner extends StatefulWidget {
//   final String uid;
//   final DateTime day;
//   final List<String> addedItems;
//
//   ReviseDinner(this.uid, this.day, this.addedItems);
//
//   @override
//   _ReviseDinnerState createState() => _ReviseDinnerState();
// }
//
// class _ReviseDinnerState extends State<ReviseDinner> {
//   List finalBreakfast = [];
//   List finalLunch = [];
//   List dinner = [];
//   getDataBase() async {
//     var fireBaseUser = FirebaseAuth.instance.currentUser!;
//     DocumentSnapshot doc = await userCollection
//         .doc(fireBaseUser.uid)
//         .collection('schedule')
//         .doc(DateFormat("dd-MM").format(DateTime.now()).toString())
//         .get();
//     print(DateFormat('dd-MM').format(DateTime.now()));
//     print(widget.uid);
//     finalBreakfast = List.from(doc['Breakfast']);
//     finalLunch = List.from(doc['Lunch']);
//     dinner = List.from(doc['Dinner']);
//
//     print(finalBreakfast);
//     print(finalLunch);
//     print(dinner);
//   }
//
//   updateDataBase() async {
//     dinner.addAll(widget.addedItems);
//     print(dinner);
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
//           'Breakfast': finalBreakfast,
//           'Lunch': finalLunch,
//           'Dinner': dinner
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
//
//   @override
//   void initState() {
//     getDataBase();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//               for (int i = 0; i < widget.addedItems.length; i++)
//                 Row(
//                   children: [
//                     Text(widget.addedItems[i]),
//                     InkWell(
//                       child: Icon(Icons.remove),
//                       onTap: () {
//                         setState(() {
//                           widget.addedItems.removeAt(i);
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
