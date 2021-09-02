import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:new_template/screens/nutrition/progress.dart';
import 'package:new_template/screens/feeds/home_screen.dart';
import 'package:new_template/screens/nutrition/view_tasks/nutrition_screen.dart';
import 'package:new_template/screens/search/search_screen.dart';
import 'package:new_template/screens/user/user_profile/user_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // late List<Map<String, dynamic>> _pages;
  //
  // int _selectedIndex = 2;
  // void selectedPage(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   _pages = [
  //     {
  //       'page': HomeScreen(),
  //       'title': Text('Home'),
  //     },
  //     {
  //       'page': SubscriptionScreen(),
  //       'title': Text('Subscription'),
  //     },
  //     {
  //       'page': NutritionScreenMain(),
  //       'title': Text('Nutrition'),
  //     },
  //     {
  //       'page': Progress(),
  //     },
  //     {
  //       'page': UserScreen(),
  //       'title': Text('User Profile'),
  //     },
  //   ];
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          children: [
            NutritionScreenMain(),
            SearchScreen(),
            Progress(),
            HomeScreen(),
            UserScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Linecons.food),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.accessibility_new),
            ),
            Tab(
              icon: Icon(
                Icons.home,
              ),
            ),
            Tab(
              icon: Icon(Icons.person),
            ),
          ],
          labelColor: Color.fromRGBO(36, 51, 72, 1),
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 45),
              borderSide:
                  BorderSide(width: 3, color: Color.fromRGBO(141, 30, 23, 1))),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }
}
//return Scaffold(
//   backgroundColor: Theme.of(context).backgroundColor,
//   body: _pages[_selectedIndex]['page'],
//   bottomNavigationBar: BottomAppBar(
//     color: Theme.of(context).backgroundColor,
//     clipBehavior: Clip.antiAlias,
//     notchMargin: 5,
//     shape: CircularNotchedRectangle(),
//     child: Container(
//       child: BottomNavigationBar(
//         backgroundColor: Theme.of(context).backgroundColor,
//         elevation: 5,
//         onTap: selectedPage,
//         currentIndex: _selectedIndex,
//         unselectedItemColor: Colors.white,
//         selectedItemColor: Color.fromRGBO(146, 168, 189, 1),
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: '--home',
//               backgroundColor: Theme.of(context).backgroundColor),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.search),
//               label: 'search',
//               backgroundColor: Theme.of(context).backgroundColor),
//           //   BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'test'),
//           BottomNavigationBarItem(
//               icon: Icon(Linecons.food),
//               label: 'nutrition',
//               backgroundColor: Color.fromRGBO(36, 51, 72, 0.4)),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.accessibility_new),
//               label: 'Progress',
//               backgroundColor: Theme.of(context).backgroundColor),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'user',
//               backgroundColor: Theme.of(context).backgroundColor),
//         ],
//       ),
//     ),
//   ),
// );
