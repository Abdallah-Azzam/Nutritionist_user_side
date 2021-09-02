import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  final bool isChecked;
  final String task;
  CheckList({
    required this.task,
    required this.isChecked,
  });
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.isChecked;
    return Row(children: [
      Text(widget.task),
      Checkbox(
          value: isChecked,
          onChanged: (value) {
            isChecked = value!;
          }),
    ]);
  }
}
