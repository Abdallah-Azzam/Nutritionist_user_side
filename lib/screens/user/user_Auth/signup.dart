import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:new_template/constants/constants.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _foodPrefController = TextEditingController();
  TextEditingController _targetWeightController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _allergyController = TextEditingController();
  TextEditingController _healthController = TextEditingController();
  void removeSnackBarCallsBeforeNavigation() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  signup() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then(
          (signedUser) => userCollection.doc(signedUser.user?.uid).set(
            {
              'username': _userNameController.text,
              'initialWeight': _weightController.text,
              'Health': _healthController.text == ''
                  ? 'none'
                  : _healthController.text,
              'currentWeight': _weightController.text,
              'targetWeight': _targetWeightController.text,
              'targetBodyType': selectedBodyType,
              'height': _heightController.text,
              'allergies': _allergyController.text == ''
                  ? 'none'
                  : _allergyController.text,
              'gender': gender,
              'foodPreference': _foodPrefController.text == ''
                  ? 'none'
                  : _foodPrefController.text,
              'password': _passwordController.text,
              'email': _emailController.text,
              'uid': signedUser.user!.uid,
              'profilePic':
                  'https://www.kindpng.com/picc/m/105-1055656_account-user-profile-avatar-avatar-user-profile-icon.png'
            },
          ).then((value) => userCollection
                  .doc(signedUser.user?.uid.toString())
                  .collection('progress')
                  .doc('09-08')
                  .set({
                'weight': FieldValue.arrayUnion([_weightController.text])
              })),
        );
    Navigator.pop(context);
  }

  SnackBar snackBar = SnackBar(
    content: Text('One moment please'),
  );
  String selectedBodyType = 'Bulk';
  bool obscure = true;
  String gender = 'female';
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Scaffold(
          backgroundColor: Color.fromRGBO(146, 168, 189, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text('page 1 of 4'),
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'User information',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Tajwal',
                                color: Color.fromRGBO(36, 51, 72, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: TextField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _userNameController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: TextField(
                              controller: _passwordController,
                              style: TextStyle(color: Colors.black),
                              obscureText: obscure,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: !obscure
                                      ? InkWell(
                                          child: Icon(
                                              Icons.remove_red_eye_outlined),
                                          onTap: () {
                                            setState(() {
                                              obscure = true;
                                            });
                                          },
                                        )
                                      : InkWell(
                                          child: Icon(Icons.remove_red_eye),
                                          onTap: () {
                                            setState(() {
                                              obscure = false;
                                            });
                                          },
                                        )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Color.fromRGBO(146, 168, 189, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text('page 2 of 4'),
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Personal information',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Tajwal',
                                color: Color.fromRGBO(36, 51, 72, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: TextField(
                              controller: _heightController,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Height cm',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.height,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _weightController,
                              keyboardType: TextInputType.numberWithOptions(),
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Current Weight kg',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  FontAwesome5.weight,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    color: gender == 'male'
                                        ? Colors.black12
                                        : Color.fromRGBO(146, 168, 189, 100),
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Icon(
                                          Icons.male,
                                          size: 80,
                                          color: Color.fromRGBO(36, 51, 72, 1),
                                        ),
                                        Text('Male',
                                            style: TextStyle(
                                              fontFamily: 'Tajwal',
                                              fontSize: 20,
                                              color:
                                                  Color.fromRGBO(36, 51, 72, 1),

                                              // color: gender == 'male'
                                              //     ? Colors.lightBlue
                                              //     : Colors.black,
                                            )),
                                      ],
                                    )),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      gender = 'male';
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    color: gender == 'female'
                                        ? Colors.black12
                                        : Color.fromRGBO(146, 168, 189, 100),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.female,
                                            size: 80,
                                            color: Color.fromRGBO(
                                                213, 67, 70, 0.8),
                                          ),
                                          Text(
                                            'Female',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    213, 67, 70, 0.8),
                                                fontFamily: 'Tajwal',
                                                fontSize: 20
                                                //color: gender == 'female'
                                                //  ? Colors.lightBlue
                                                //: Colors.black,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      gender = 'female';
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Color.fromRGBO(146, 168, 189, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text('page 3 of 4'),
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'What is your target?',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Tajwal',
                                color: Color.fromRGBO(36, 51, 72, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _targetWeightController,
                              keyboardType: TextInputType.numberWithOptions(),
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Target Weight kg',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  FontAwesome5.weight,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 150,
                          //   alignment: Alignment.center,
                          //   padding: const EdgeInsets.only(bottom: 30),
                          //   color: Color.fromRGBO(146, 168, 189, 100),
                          //   child: CupertinoPicker(
                          //     itemExtent: 32,
                          //     onSelectedItemChanged: (selectedIndex) {
                          //       setState(() {
                          //         selectedBodyType =
                          //             targetBodyType[selectedIndex];
                          //       });
                          //     },
                          //     children: [
                          //       for (String c in targetBodyType)
                          //         Text(
                          //           c,
                          //           style: TextStyle(color: Colors.black),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          for (int x = 0; x < targetBodyType.length; x++)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedBodyType = targetBodyType[x];
                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 3,
                                color: selectedBodyType == targetBodyType[x]
                                    ? Colors.black12
                                    : Color.fromRGBO(146, 168, 189, 100),
                                child: Center(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(child: targetBodyIcon[x]),
                                        Text(
                                          targetBodyType[x],
                                          style: TextStyle(
                                            fontFamily: 'Tajwal',
                                            fontSize: 20,
                                            color:
                                                Color.fromRGBO(36, 51, 72, 1),

                                            // color: gender == 'male'
                                            //     ? Colors.lightBlue
                                            //     : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Color.fromRGBO(146, 168, 189, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text('page 4 of 4'),
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Additional information',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Tajwal',
                                color: Color.fromRGBO(36, 51, 72, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _foodPrefController,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'food pref: vegan,vegetarian,etc',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _allergyController,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'allergies',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: _healthController,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Health issues',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.medical_services_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBar,
                              );

                              removeSnackBarCallsBeforeNavigation();
                              return signup();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(33))),
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontFamily: 'Tajwal',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
