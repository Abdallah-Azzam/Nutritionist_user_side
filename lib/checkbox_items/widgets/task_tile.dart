// import 'package:flutter/material.dart';
//
// class TaskTile extends StatefulWidget {
//   final String text;
//   TaskTile(
//     this.text,
//   );
//   @override
//   _TaskTileState createState() => _TaskTileState();
// }
//
// class _TaskTileState extends State<TaskTile> {
//   bool isChecked = false;
//   void checkBoxCallBack(bool? checkBoxState) {
//     setState(() {
//       isChecked = checkBoxState!;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Padding(
//         padding: const EdgeInsets.only(left: 25.0),
//         child: Text(
//           widget.text,
//           style: TextStyle(
//               decoration: isChecked ? TextDecoration.lineThrough : null),
//         ),
//       ),
//       trailing: TaskCheckBox(isChecked, checkBoxCallBack),
//     );
//   }
// }
//
// class TaskCheckBox extends StatelessWidget {
//   final bool checkBoxState;
//   final Function(bool?) toggleCheckBoxState;
//   TaskCheckBox(this.checkBoxState, this.toggleCheckBoxState);
//   @override
//   Widget build(BuildContext context) {
//     return Checkbox(
//       value: checkBoxState,
//       activeColor: Colors.green,
//       onChanged: toggleCheckBoxState,
//     );
//   }
// }
