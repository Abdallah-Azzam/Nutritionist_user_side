import 'package:flutter/cupertino.dart';
import 'package:new_template/models/nutrition_items/dinner_items.dart';

class Dinner with ChangeNotifier {
  List<ItemDinner> _item = [
    ItemDinner(
        id: 'salad',
        title: 'Salad',
        price: '73',
        imageUrl:
            'https://www.jennycancook.com/wp-content/uploads/2016/08/Dinner_Salad.jpg',
        quantity: 0),
  ];
  List<ItemDinner> get item {
    return _item;
  }
}
