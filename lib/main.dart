import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_template/provider/nutrition_provider/breakfast.dart';
import 'package:new_template/provider/nutrition_provider/dinner.dart';
import 'package:new_template/provider/nutrition_provider/lunch.dart';
import 'package:new_template/screens/nutrition/view_tasks/add_food.dart';
import 'package:new_template/screens/user/navigation.dart';
import 'package:new_template/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import 'theme_data.dart';
import 'package:new_template/provider/dark_theme+provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkTHemeProvider tHemeProvider = DarkTHemeProvider();
  void getCurrentAppTheme() async {
    tHemeProvider.darkTheme = await tHemeProvider.themePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return tHemeProvider;
          }),
          ChangeNotifierProvider(create: (_) {
            return Breakfast();
          }),
          ChangeNotifierProvider(create: (_) {
            return Lunch();
          }),
          ChangeNotifierProvider(create: (_) {
            return Dinner();
          }),
        ],
        child: Consumer<DarkTHemeProvider>(
            builder: (BuildContext context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(tHemeProvider.darkTheme, context),
            home: NavigationPage(),
          );
        }));
  }
}
