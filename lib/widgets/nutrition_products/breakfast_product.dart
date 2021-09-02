import 'package:flutter/material.dart';
import 'package:new_template/models/nutrition_items/breakfast_items.dart';
import 'package:provider/provider.dart';

class BreakFastProducts extends StatefulWidget {
  static int quantity = 0;
  final String uid;
  final DateTime day;
  BreakFastProducts(this.uid, this.day);
  static List<String> addedItems = [];

  @override
  _BreakFastProductsState createState() => _BreakFastProductsState();
}

class _BreakFastProductsState extends State<BreakFastProducts> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemBreakfast>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 20,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
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

                                  BreakFastProducts.addedItems
                                      .remove('${itemProvider.id}');
                                  print(BreakFastProducts.addedItems);
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

                                  BreakFastProducts.addedItems
                                      .add('${itemProvider.id}');
                                  print(BreakFastProducts.addedItems);
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
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 3),
                //   child: Text(
                //     '${itemProvider.price} cal',
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 2,
                //     style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.black,
                //         fontWeight: FontWeight.w900),
                //   ),
                // ),

                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       BreakFastProducts.addedItems
                //           .add('${itemProvider.id} x$quantity');
                //     });
                //   },
                //   child: Card(
                //     child: ListTile(
                //       leading: Text('Add'),
                //       trailing: Icon(
                //         Icons.check,
                //         color: Colors.green,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
