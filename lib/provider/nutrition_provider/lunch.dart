import 'package:flutter/cupertino.dart';
import 'package:new_template/models/nutrition_items/lunch_items.dart';

class Lunch with ChangeNotifier {
  List<ItemLunch> _item = [
    ItemLunch(
        id: 'Chicken breast',
        title: 'Chicken Breast',
        price: '73',
        imageUrl:
            'https://www.shopifull.com/wp-content/uploads/2020/03/Chicken-breast.jpg',
        quantity: 0),
    ItemLunch(
        id: 'Steak',
        title: 'Steak',
        price: '58',
        imageUrl:
            'https://www.gannett-cdn.com/-mm-/6481cd397fb3ad7b3db48f7c545f5d4fc641e326/c=109-0-765-875/local/-/media/2017/01/03/TXGroup/CorpusChristi/636190635877766231-Saltgrass-Steak-House.JPG?width=600&height=802&fit=crop&format=pjpg&auto=webp',
        quantity: 0)
  ];
  List<ItemLunch> get item {
    return _item;
  }
}
