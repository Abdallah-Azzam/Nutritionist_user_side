import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/feeds/post/comments_page.dart';

class ViewUser extends StatefulWidget {
  final String uid;
  ViewUser(this.uid);
  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late Stream<QuerySnapshot> userStream;
  String? onlineUserUid;
  getCurrentUser() {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      onlineUserUid = fireBaseUser.uid;
    });
  }

  bool? isFollowing;
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
  String? username;
  String? profilePic;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(widget.uid).get();
    var followersCount =
        await userCollection.doc(widget.uid).collection('followers').get();
    var followingCount =
        await userCollection.doc(widget.uid).collection('following').get();
    userCollection
        .doc(widget.uid)
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
      username = userDoc['username'];
      following = followingCount.docs.length;
      followers = followersCount.docs.length;
      profilePic = userDoc['profilePic'];
      loading = false;
    });
  }

  getStream() {
    setState(() {
      userStream =
          postCollection.where('uid', isEqualTo: widget.uid).snapshots();
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getUserInfo();
    getStream();
    super.initState();
  }

  followUser() async {
    var document = await userCollection
        .doc(widget.uid)
        .collection('followers')
        .doc(onlineUserUid)
        .get();
    if (!document.exists) {
      userCollection
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineUserUid)
          .set({});

      userCollection
          .doc(onlineUserUid)
          .collection('following')
          .doc(widget.uid)
          .set({});

      setState(() {
        followers++;

        isFollowing = true;
      });
    } else {
      userCollection
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineUserUid)
          .delete();

      userCollection
          .doc(onlineUserUid)
          .collection('following')
          .doc(widget.uid)
          .delete();

      setState(() {
        followers--;
        isFollowing = false;
      });
    }
  }

  bool loading = true;
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                                    fit: BoxFit.fill,
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
                                  followUser();
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
                                    isFollowing == false
                                        ? 'Follow'
                                        : 'unfollow',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  )),
                                ),
                              ),
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
                                                                            color: Theme.of(context)
                                                                                .textSelectionTheme
                                                                                .selectionColor,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                                                                Icon(postDoc['likes'].contains(onlineUserUid) ? Icons.thumb_up : Icons.thumb_up_off_alt, color: postDoc['likes'].contains(onlineUserUid) ? Colors.blue : Theme.of(context).iconTheme.color),
                                                                                Text(
                                                                                  'Likes(${postDoc['likes'].length.toString()})',
                                                                                  style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w700),
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
                                                                              color: Theme.of(context).iconTheme.color),
                                                                          GestureDetector(
                                                                            child:
                                                                                Text('Comment(${postDoc['commentCount'].toString()})', style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w600)),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                return Comments(postDoc['id'], widget.uid, false);
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
