import 'package:flutter/material.dart';

class Reusable extends StatelessWidget {
  Reusable({required this.cardChild, required this.colour});
  final Widget cardChild;
  final Color colour;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: cardChild);
  }
}
