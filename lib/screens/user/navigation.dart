import 'package:flutter/material.dart';
import 'package:new_template/widgets/bottom_bar.dart';

import 'user_Auth/login.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);
  static bool isSigned = false;
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  // @override
  // void initState() {
  //   FirebaseAuth.instance.authStateChanges().listen((userAccount) {
  //     if (userAccount != null)
  //       setState(() {
  //         isSigned = true;
  //       });
  //     else
  //       setState(() {
  //         isSigned = false;
  //       });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationPage.isSigned == false ? Login() : BottomBar(),
    );
  }
}
