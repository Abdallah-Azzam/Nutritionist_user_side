import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/screens/user/navigation.dart';
import 'package:new_template/screens/user/user_Auth/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .whenComplete(() => setState(() {
                NavigationPage.isSigned = true;
              }));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NavigationPage();
      })).whenComplete(() => Navigator.pop(context));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool obscure = true;
  final snackBar = SnackBar(content: Text('email or password is invalid'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(36, 51, 72, 1),
                        fontFamily: 'Tajwal'),
                  ),
                  // Container(
                  //   height: 60,
                  //   width: 60,
                  //   child: Image(
                  //     image: AssetImage('images/1_5-aoK8IBmXve5whBQM90GA.png'),
                  //   ),
                  // ),
                  // Divider(),
                  Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Tajwal',
                        color: Color.fromRGBO(36, 51, 72, 1),
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextField(
                      controller: _emailController,
                      cursorColor: Colors.black,
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
                                child: Icon(Icons.remove_red_eye_outlined),
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
                              ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Signing in')));
                      return login();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(33))),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color.fromRGBO(36, 51, 72, 1),
                              fontSize: 20,
                              fontFamily: 'Tajwal',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Signup();
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(33))),
                      child: Center(
                        child: Text(
                          'Sign Up',
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
          ),
        ),
      ),
    );
  }
}
