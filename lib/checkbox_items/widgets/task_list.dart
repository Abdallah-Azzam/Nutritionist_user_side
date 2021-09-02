// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:new_template/checkbox_items/widgets/task_tile.dart';
// import 'package:new_template/constants/constants.dart';
//
// class TaskList extends StatefulWidget {
//   final String uid;
//   TaskList(this.uid);
//   @override
//   _TaskListState createState() => _TaskListState();
// }
//
// class _TaskListState extends State<TaskList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 15),
//           child: Text(
//             'Breakfast',
//             style: TextStyle(color: Colors.blueGrey),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: DottedLine(),
//         ),
//         SingleChildScrollView(
//             physics: ScrollPhysics(),
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: userCollection.doc(widget.uid).snapshots(),
//                 builder: (context, AsyncSnapshot snapshot) {
//                   if (!snapshot.hasData)
//                     return Center(
//                       child: Container(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: snapshot.data['week1 Day1 Breakfast Num'] ?? 0,
//                       itemBuilder: (BuildContext context, var index) {
//                         int? g = snapshot.data['week1 Day1 Breakfast Num'] ?? 0;
//                         //  DocumentSnapshot userDoc = snapshot.data![index];
//                         return Column(
//                           children: [
//                             for (int i = 1; i <= g!; i++)
//                               TaskTile(
//                                   snapshot.data['week1 BreakFast $i Day1']),
//                           ],
//                         );
//                       });
//                 })),
//         Padding(
//           padding: const EdgeInsets.only(left: 15),
//           child: Text(
//             'Lunch',
//             style: TextStyle(color: Colors.blueGrey),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: DottedLine(),
//         ),
//         SingleChildScrollView(
//           physics: ScrollPhysics(),
//           child: StreamBuilder<DocumentSnapshot>(
//               stream: userCollection.doc(widget.uid).snapshots(),
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData)
//                   return Center(
//                     child: Container(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data['week1 Day1 Lunch Num'] ?? 1,
//                     itemBuilder: (BuildContext context, var index) {
//                       int? g = snapshot.data['week1 Day1 Lunch Num'] ?? 1;
//
//                       return Column(
//                         children: [
//                           for (int i = 1; i <= g!; i++)
//                            // TaskTile(snapshot.data['week1 Lunch $i Day1']),
//                         ],
//                       );
//                     });
//               }),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 15),
//           child: Text(
//             'Dinner',
//             style: TextStyle(color: Colors.blueGrey),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: DottedLine(),
//         ),
//         SingleChildScrollView(
//           physics: ScrollPhysics(),
//           child: StreamBuilder<DocumentSnapshot>(
//               stream: userCollection.doc(widget.uid).snapshots(),
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData)
//                   return Center(
//                     child: Container(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data['week1 Day1 dinner Num'] ?? 1,
//                     itemBuilder: (BuildContext context, var index) {
//                       int? g = snapshot.data['week1 Day1 dinner Num'] ?? 1;
//
//                       return Column(
//                         children: [
//                           for (int i = 1; i <= g!; i++)
//                             Row(
//                               children: [
//                               //  TaskTile(snapshot.data['week1 dinner $i Day1']),
//                               ],
//                             ),
//                         ],
//                       );
//                     });
//               }),
//         ),
//       ],
//     );
//   }
// }
