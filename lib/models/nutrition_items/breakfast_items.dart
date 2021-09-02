import 'package:flutter/cupertino.dart';

class ItemBreakfast with ChangeNotifier {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  late final int quantity;

  ItemBreakfast(
      {required this.id,
      required this.title,
      required this.price,
      required this.imageUrl,
      required this.quantity});
}
