import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/search/view_profile/view_nutristionist.dart';
import 'package:new_template/screens/search/view_profile/view_user.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? search;
  String? post;
  List numberOfPosts = [];
  List numberOfCommentsPages = [];
  TextEditingController? _controller;
  bool loading = true;
  void initState() {
    _controller = TextEditingController();
    // Comments();
    getStream();
    super.initState();
  }

  getStream() async {
    setState(() {
      nutritionistStream = nutritionistCollection.snapshots();
    });
  }

  Future<QuerySnapshot>? nutristionistSearchResult;
  Future<QuerySnapshot>? searchResult;
  searchUser(String s) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await userCollection.doc(fireBaseUser.uid).get();
    var users = userCollection
        .where('username',
            isGreaterThanOrEqualTo: s, isNotEqualTo: doc['username'])
        .get();
    var nutristionistUsers = nutritionistCollection
        .where('username', isGreaterThanOrEqualTo: s)
        .get();
    setState(() {
      if (s == '') {
        searchResult = null;
        nutristionistSearchResult = null;
      } else
        searchResult = users;
      nutristionistSearchResult = nutristionistUsers;
    });
  }

  late Stream<QuerySnapshot> nutritionistStream;
  @override
  Widget build(BuildContext context) {
    List<int> numberList = [];
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                    size: 1,
                  ),
                  floating: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 13, right: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(32),
                                  right: Radius.circular(32),
                                ),
                                border:
                                    Border.all(width: 1, color: Colors.white)),
                            child: TextField(
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionColor),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'Search',
                              ),
                              textAlign: TextAlign.center,
                              controller: _controller,
                              onChanged: (value) {
                                try {
                                  setState(() {
                                    search = value;
                                  });

                                  searchUser(search!);
                                } catch (e) {}
                              },
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            heroTag: '5',
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.search,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              searchUser(search!);
                            }),
                      ],
                    );
                  }),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      search == ''
                          ? Container()
                          : FutureBuilder<QuerySnapshot>(
                              future: nutristionistSearchResult,
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(),
                                  );
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot user =
                                          snapshot.data!.docs[index];
                                      return InkWell(
                                        child: Card(
                                          elevation: 9,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              foregroundImage: NetworkImage(
                                                  user['profilePic']),
                                            ),
                                            title: Text(user['username']),
                                          ),
                                        ),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewNutritionist(
                                                        user['uid']))),
                                      );
                                    });
                              }),
                      search == ''
                          ? Container()
                          : FutureBuilder<QuerySnapshot>(
                              future: searchResult,
                              builder: (BuildContext context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(),
                                  );
                                }
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot user =
                                          snapshot.data!.docs[index];
                                      return InkWell(
                                        child: Card(
                                          elevation: 9,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              foregroundImage: NetworkImage(
                                                  user['profilePic']),
                                            ),
                                            title: Text(user['username']),
                                          ),
                                        ),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewUser(user['uid']))),
                                      );
                                    });
                              }),

                      StreamBuilder<QuerySnapshot>(
                          stream: nutritionistStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: Container(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length > 3
                                    ? 3
                                    : snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  print(numberList);
                                  var random = Random();
                                  int length = snapshot.data!.docs.length;
                                  int randomNum = random.nextInt(length);
                                  DocumentSnapshot? doc;

                                  if (numberList.contains(randomNum) &&
                                      numberList.length != 1)
                                    while (numberList.contains(randomNum)) {
                                      randomNum = random.nextInt(length);
                                      if (!numberList.contains(randomNum)) {
                                        print(numberList);
                                        numberList.add(randomNum);
                                        doc = snapshot.data!.docs[randomNum];
                                        break;
                                      }
                                    }
                                  else {
                                    print(numberList);
                                    doc = snapshot.data!.docs[randomNum];
                                    numberList.add(randomNum);
                                  }
                                  // if (!numberList.contains(randomNum)) {
                                  //   randomNum = random.nextInt(5);
                                  //   numberList.add(randomNum);
                                  // }

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewNutritionist(
                                                          doc!['uid'])));
                                        },
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.white,
                                              foregroundImage: NetworkImage(
                                                  doc?['profilePic']),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              doc?['username'],
                                              style: TextStyle(
                                                  fontFamily: 'Tajwal',
                                                  color: Color.fromRGBO(
                                                      36, 51, 72, 1),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                    ],
                                  );
                                });
                          })

                      // if (numberOfPosts.isNotEmpty)
                      //   for (int i = 0; i < numberOfPosts.length; i++)
                      //     Column(
                      //       children: [
                      //         Divider(),
                      //         Posts(post!),
                    ],
                  ),
                )
              ],
            ),
            // ],
          ),
        ));
    //   ),
    // );
  }
}
