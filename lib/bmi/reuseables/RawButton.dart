import 'package:flutter/material.dart';

class RawButton extends StatelessWidget {
  RawButton({required this.icon, required this.tapped});
  final Function() tapped;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6,
      shape: CircleBorder(),
      fillColor: Color(0xff4c4e5e),
      constraints: BoxConstraints.tightFor(
        width: 50,
        height: 50,
      ),
      child: Icon(icon),
      onPressed: tapped,
    );
  }
}
