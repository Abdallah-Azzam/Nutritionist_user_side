import 'package:flutter/material.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen_day1.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen_by_week.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen_day2.dart';

class NutritionScreenMain extends StatefulWidget {
  const NutritionScreenMain({Key? key}) : super(key: key);
  static bool value = false;
  @override
  _NutritionScreenMainState createState() => _NutritionScreenMainState();
}

class _NutritionScreenMainState extends State<NutritionScreenMain> {
  PageController? _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color.fromRGBO(146, 168, 189, 0.65),
      body: NutritionScreenMain.value == false
          ? PageView(
              controller: _pageController,
              children: [
                SafeArea(
                  child: Container(
                      decoration: BoxDecoration(
                          //     gradient: LinearGradient(colors: [
                          //   Color.fromRGBO(255, 244, 162, 1),
                          //   Color.fromRGBO(253, 209, 58, 1),
                          // ], begin: Alignment.topCenter)),
                          color: Colors.white),
                      child: NutritionScreenByDay1()),
                ),
                SafeArea(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: NutritionScreenByDay2()),
                )
              ],
            )
          : NutritionScreenByWeek(),
    );
  }
}
