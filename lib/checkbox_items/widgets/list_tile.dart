import 'package:flutter/material.dart';

class ListTileContent extends StatelessWidget {
  final IconData icon;
  final String mainTitle;
  final String subTitle;
  final Function() ontap;
  ListTileContent(
      {required this.icon,
      required this.mainTitle,
      required this.subTitle,
      required this.ontap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        mainTitle,
        style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionHandleColor),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionColor),
      ),
    );
  }
}
