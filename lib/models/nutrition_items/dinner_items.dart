import 'package:flutter/cupertino.dart';

class ItemDinner with ChangeNotifier {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  late final int quantity;

  ItemDinner(
      {required this.id,
      required this.title,
      required this.price,
      required this.imageUrl,
      required this.quantity});
}
