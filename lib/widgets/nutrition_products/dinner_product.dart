import 'package:flutter/material.dart';
import 'package:new_template/models/nutrition_items/dinner_items.dart';
import 'package:provider/provider.dart';

class DinnerProducts extends StatefulWidget {
  static int quantity = 0;
  final String uid;
  final DateTime day;
  DinnerProducts(this.uid, this.day);
  static List<String> addedItems = [];
  @override
  _DinnerProductsState createState() => _DinnerProductsState();
}

class _DinnerProductsState extends State<DinnerProducts> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemDinner>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Container(
            // padding: const EdgeInsets.only(left: 5, top: 20),
            margin: const EdgeInsets.only(left: 5, bottom: 2, right: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemProvider.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                quantity--;

                                DinnerProducts.addedItems
                                    .remove('${itemProvider.id}');
                              });
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Text(quantity.toString()),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                quantity++;

                                DinnerProducts.addedItems
                                    .add('${itemProvider.id}');
                              });
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 3),
                //   child: Text(
                //     itemProvider.price,
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 2,
                //     style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.black,
                //         fontWeight: FontWeight.w900),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
