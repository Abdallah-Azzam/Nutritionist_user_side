import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/feeds/post/comments_page.dart';
import 'package:new_template/screens/user/user_profile/settings.dart';

class UserScreen extends StatefulWidget {
  static String name = 'abdallah azzam';
  static bool newValue = false;
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Stream<QuerySnapshot> userStream;
  String? uid;
  getCurrentUser() {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      uid = fireBaseUser.uid;
    });
  }

  postLiked(String documentId) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot document = await postCollection.doc(documentId).get();
    if (document['likes'].contains(fireBaseUser.uid)) {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayRemove([fireBaseUser.uid]),
      });
    } else {
      postCollection.doc(documentId).update({
        'likes': FieldValue.arrayUnion([fireBaseUser.uid]),
      });
    }
  }

  late int following;
  late int followers;
  bool? isFollowing;
  String? username;
  String? profilePic;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    var followersCount = await userCollection
        .doc(fireBaseUser.uid)
        .collection('followers')
        .get();
    var followingCount = await userCollection
        .doc(fireBaseUser.uid)
        .collection('following')
        .get();
    userCollection
        .doc(fireBaseUser.uid)
        .collection('followers')
        .doc(fireBaseUser.uid)
        .get()
        .then((document) => {
              if (document.exists)
                {
                  setState(() {
                    isFollowing = true;
                  })
                }
              else
                {
                  setState(() {
                    isFollowing = false;
                  })
                }
            });

    setState(() {
      // bio = documentSnapshot['Bio'][fireBaseUser.uid].toString();
      username = userDoc['username'];
      following = followingCount.docs.length;
      followers = followersCount.docs.length;
      profilePic = userDoc['profilePic'];

      loading = false;
    });
  }

  String? bio;
  getStream() {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      userStream =
          postCollection.where('uid', isEqualTo: fireBaseUser.uid).snapshots();
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getUserInfo();
    getStream();
    super.initState();
  }

  bool loading = true;
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: loading == false
          ? Stack(children: [
              StreamBuilder<QuerySnapshot>(
                  stream: userCollection.snapshots(),
                  builder: (context, snapshot) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          leading: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                            size: 1,
                          ),
                          expandedHeight: 200,
                          flexibleSpace: StreamBuilder<QuerySnapshot>(
                            stream: userCollection.snapshots(),
                            builder: (context, snapshot) {
                              return LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                top = constraints.biggest.height;
                                return Container(
                                  color: Color.fromRGBO(146, 168, 189, 1),
                                  child: FlexibleSpaceBar(
                                    collapseMode: CollapseMode.parallax,
                                    centerTitle: true,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AnimatedOpacity(
                                          opacity: top <= 110 ? 1 : 0,
                                          duration: Duration(milliseconds: 300),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                height: kToolbarHeight / 1.8,
                                                width: kToolbarHeight / 1.8,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      blurRadius: 1,
                                                    ),
                                                  ],
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fitHeight,
                                                    image: NetworkImage(
                                                        profilePic!),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                username.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    background: Image(
                                      image: NetworkImage(profilePic!),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    following.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingsScreen())).whenComplete(
                                      () => Navigator.pop(context));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(colors: [
                                        Colors.blue,
                                        Colors.lightBlueAccent
                                      ])),
                                  child: Center(
                                      child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ),
                              ),
                              Text(bio ?? ''),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'User Posts',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: DottedLine(
                                    dashColor: Theme.of(context).dividerColor,
                                  )),
                              StreamBuilder<QuerySnapshot>(
                                  stream: userStream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot postDoc =
                                            snapshot.data!.docs[index];
                                        return Column(
                                          children: [
                                            Divider(
                                              color: Colors.transparent,
                                            ),
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              18,
                                                                          foregroundImage:
                                                                              NetworkImage(postDoc['profilePic']),
                                                                        ),
                                                                        margin:
                                                                            const EdgeInsets.all(10),
                                                                      ),
                                                                      Text(
                                                                        postDoc[
                                                                            'username'],
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).textSelectionTheme.selectionColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if (postDoc[
                                                                          'type'] ==
                                                                      1)
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Divider(
                                                                          color:
                                                                              Theme.of(context).dividerColor,
                                                                          thickness:
                                                                              1,
                                                                        ),
                                                                        Text(
                                                                          postDoc[
                                                                              'post'],
                                                                          style:
                                                                              TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  if (postDoc[
                                                                          'type'] ==
                                                                      2)
                                                                    Column(
                                                                      children: [
                                                                        Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              Theme.of(context).dividerColor,
                                                                        ),
                                                                        Image(
                                                                          image:
                                                                              NetworkImage(postDoc['image']),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                  ),
                                                                  if (postDoc[
                                                                          'type'] ==
                                                                      3)
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Image(
                                                                          image:
                                                                              NetworkImage(postDoc['image']),
                                                                        ),
                                                                        Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              Theme.of(context).dividerColor,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text('${postDoc['username']}:'),
                                                                            SizedBox(
                                                                              width: 12,
                                                                            ),
                                                                            Text(postDoc['post']),
                                                                          ],
                                                                        ),
                                                                        Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              Theme.of(context).dividerColor,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              postLiked(postDoc['id']);
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Icon(postDoc['likes'].contains(uid) ? Icons.thumb_up : Icons.thumb_up_off_alt, color: postDoc['likes'].contains(uid) ? Colors.blue : Theme.of(context).iconTheme.color),
                                                                                Text(
                                                                                  'Likes(${postDoc['likes'].length.toString()})',
                                                                                  style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.textsms,
                                                                              color: Theme.of(context).iconTheme.color
                                                                              // Theme.of(
                                                                              //         context)
                                                                              //     .iconTheme
                                                                              //     .color,
                                                                              ),
                                                                          GestureDetector(
                                                                            child:
                                                                                Text('Comment(${postDoc['commentCount'].toString()})', style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w600)),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                return Comments(postDoc['id'], uid!, false);
                                                                              }));
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      left: 8,
                                                                      right: 8),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              margin:
                                                  EdgeInsets.only(bottom: 35),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ],
                          ),
                        )
                      ],
                    );
                  })
            ])
          : Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
