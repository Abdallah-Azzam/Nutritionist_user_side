import 'package:flutter/cupertino.dart';
import 'package:new_template/models/nutrition_items/breakfast_items.dart';

class Breakfast with ChangeNotifier {
  List<ItemBreakfast> _item = [
    ItemBreakfast(
        id: 'egg',
        title: 'Egg',
        price: '73',
        imageUrl:
            'https://thumbs.dreamstime.com/z/one-egg-white-background-17710307.jpg',
        quantity: 0),
    ItemBreakfast(
        id: 'potato',
        title: 'potato',
        price: '58',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/close-up-of-two-potatoes-royalty-free-image-717382655-1536687937.jpg?crop=1.00xw:0.752xh;0,0.101xh&resize=1200:*',
        quantity: 0)
  ];
  List<ItemBreakfast> get item {
    return _item;
  }
}
