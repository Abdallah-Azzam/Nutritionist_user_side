import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/feeds/post/add_post.dart';
import 'package:new_template/feeds/post/comments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_template/screens/search/view_profile/view_nutristionist.dart';
import 'package:new_template/screens/search/view_profile/view_user.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'Home Screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int i = 0;
  String? newComment;
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

  publicPostLiked(String documentId) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot document =
        await nutritionistPublicPost.doc(documentId).get();
    if (document['likes'].contains(fireBaseUser.uid)) {
      nutritionistPublicPost.doc(documentId).update({
        'likes': FieldValue.arrayRemove([fireBaseUser.uid]),
      });
    } else {
      nutritionistPublicPost.doc(documentId).update({
        'likes': FieldValue.arrayUnion([fireBaseUser.uid]),
      });
    }
  }

  privatePostLiked(String documentId) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot document = await nutritionistPost.doc(documentId).get();
    if (document['likes'].contains(fireBaseUser.uid)) {
      nutritionistPost.doc(documentId).update({
        'likes': FieldValue.arrayRemove([fireBaseUser.uid]),
      });
    } else {
      nutritionistPost.doc(documentId).update({
        'likes': FieldValue.arrayUnion([fireBaseUser.uid]),
      });
    }
  }

  String? newPost;
  int? commentPages;
  String? uid;
  @override
  void initState() {
    getCurrentUserUID();
    getSubscriptions();
    getStream();
    super.initState();
  }

  getCurrentUserUID() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      uid = fireBaseUser.uid;
    });
  }

  Stream<QuerySnapshot>? stream;
  //List subscriptions = [];
  getSubscriptions() async {}

  getStream() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await userCollection.doc(fireBaseUser.uid).get();
    setState(() {
      String g = doc['subscriptions'][0].toString();
      stream = nutritionistPost.where('uid', isEqualTo: g).snapshots();
    });
  }

  int view = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: view == 1
                                  ? Color.fromRGBO(146, 168, 189, 0.3)
                                  : Colors.white),
                          child: Center(
                              child: Text(
                            'Users',
                            style: TextStyle(
                                fontFamily: 'Tajwal',
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(36, 51, 72, 1)),
                          ))),
                      onTap: () {
                        setState(() {
                          view = 1;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: view == 2
                                  ? Color.fromRGBO(146, 168, 189, 0.3)
                                  : Colors.white),
                          child: Center(
                              child: Text(
                            'Nutritionists',
                            style: TextStyle(
                                fontFamily: 'Tajwal',
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(36, 51, 72, 1)),
                          ))),
                      onTap: () {
                        setState(() {
                          view = 2;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: view == 3
                                  ? Color.fromRGBO(146, 168, 189, 0.3)
                                  : Colors.white),
                          child: Center(
                              child: Text(
                            'subscriptions',
                            style: TextStyle(
                                fontFamily: 'Tajwal',
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(36, 51, 72, 1)),
                          ))),
                      onTap: () {
                        setState(() {
                          view = 3;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton(
              heroTag: '7',
              child: Icon(
                Icons.add,
                color: Color.fromRGBO(141, 30, 23, 1),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              focusElevation: 5,
              onPressed: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddPost();
                  }));
                });
              },
            ),
            Expanded(
                child: view == 1
                    ? StreamBuilder<QuerySnapshot>(
                        stream: postCollection
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 6),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
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
                                                            InkWell(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 18,
                                                                  foregroundImage:
                                                                      NetworkImage(
                                                                          postDoc[
                                                                              'profilePic']),
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                              ),
                                                              onTap: () {
                                                                if (uid !=
                                                                    postDoc[
                                                                        'uid'])
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ViewUser(postDoc['uid'])));
                                                              },
                                                            ),
                                                            Text(
                                                              postDoc[
                                                                  'username'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textSelectionTheme
                                                                      .selectionColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            ),
                                                          ],
                                                        ),
                                                        if (postDoc['type'] ==
                                                            1)
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Divider(
                                                                color: Theme.of(
                                                                        context)
                                                                    .dividerColor,
                                                                thickness: 1,
                                                              ),
                                                              Text(
                                                                postDoc['post'],
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textSelectionTheme
                                                                        .selectionColor),
                                                              ),
                                                            ],
                                                          ),
                                                        if (postDoc['type'] ==
                                                            2)
                                                          Column(
                                                            children: [
                                                              Divider(
                                                                thickness: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .dividerColor,
                                                              ),
                                                              Image(
                                                                image: NetworkImage(
                                                                    postDoc[
                                                                        'image']),
                                                              ),
                                                            ],
                                                          ),
                                                        Divider(
                                                          thickness: 1,
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                        ),
                                                        if (postDoc['type'] ==
                                                            3)
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image(
                                                                image: NetworkImage(
                                                                    postDoc[
                                                                        'image']),
                                                              ),
                                                              Divider(
                                                                thickness: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .dividerColor,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      '${postDoc['username']}:'),
                                                                  SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Text(postDoc[
                                                                      'post']),
                                                                ],
                                                              ),
                                                              Divider(
                                                                thickness: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .dividerColor,
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
                                                                  onTap: () {
                                                                    postLiked(
                                                                        postDoc[
                                                                            'id']);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                          postDoc['likes'].contains(uid)
                                                                              ? Icons
                                                                                  .thumb_up
                                                                              : Icons
                                                                                  .thumb_up_off_alt,
                                                                          color: postDoc['likes'].contains(uid)
                                                                              ? Colors.blue
                                                                              : Theme.of(context).iconTheme.color),
                                                                      Text(
                                                                          'Likes(${postDoc['likes'].length.toString()})'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .textsms,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .iconTheme
                                                                        .color),
                                                                GestureDetector(
                                                                  child: Text(
                                                                      'Comment(${postDoc['commentCount'].toString()})',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .textSelectionTheme
                                                                              .selectionColor)),
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return Comments(
                                                                          postDoc[
                                                                              'id'],
                                                                          uid!,
                                                                          false);
                                                                    }));
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.only(
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
                                  ),
                                ],
                              );
                            },
                          );
                        })
                    : view == 2
                        ? StreamBuilder<QuerySnapshot>(
                            stream: nutritionistPublicPost
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: Container(
                                        child: CircularProgressIndicator()));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
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
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
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
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      InkWell(
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          18,
                                                                      foregroundImage:
                                                                          NetworkImage(
                                                                              postDoc['profilePic']),
                                                                    ),
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ViewNutritionist(postDoc['uid'])));
                                                                    },
                                                                  ),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                ),
                                                                Text(
                                                                  postDoc[
                                                                      'username'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textSelectionTheme
                                                                          .selectionColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
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
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  Text(
                                                                    postDoc[
                                                                        'post'],
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .textSelectionTheme
                                                                            .selectionColor),
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
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                  ),
                                                                  Image(
                                                                    image: NetworkImage(
                                                                        postDoc[
                                                                            'image']),
                                                                  ),
                                                                ],
                                                              ),
                                                            Divider(
                                                              thickness: 1,
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
                                                                    image: NetworkImage(
                                                                        postDoc[
                                                                            'image']),
                                                                  ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          '${postDoc['username']}:'),
                                                                      SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Text(postDoc[
                                                                          'post']),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
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
                                                                        publicPostLiked(
                                                                            postDoc['id']);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                              postDoc['likes'].contains(uid) ? Icons.thumb_up : Icons.thumb_up_off_alt,
                                                                              color: postDoc['likes'].contains(uid) ? Colors.blue : Theme.of(context).iconTheme.color),
                                                                          Text(
                                                                            'Likes(${postDoc['likes'].length.toString()})',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .textsms,
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color),
                                                                    GestureDetector(
                                                                      child: Text(
                                                                          'Comment(${postDoc['commentCount'].toString()})',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).textSelectionTheme.selectionColor,
                                                                              fontWeight: FontWeight.w600)),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder:
                                                                                (context) {
                                                                          return Comments(
                                                                              postDoc['id'],
                                                                              uid!,
                                                                              true);
                                                                        }));
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
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
                                        margin: EdgeInsets.only(bottom: 35),
                                      ),
                                    ],
                                  );
                                },
                              );
                            })
                        : stream == null
                            ? Container(
                                child: Text('nothing to show'),
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: stream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: Container(
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    reverse: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot privatePostDoc =
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
                                                        shape:
                                                            BoxShape.rectangle,
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
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              18,
                                                                          foregroundImage:
                                                                              NetworkImage(privatePostDoc['profilePic']),
                                                                        ),
                                                                        margin:
                                                                            const EdgeInsets.all(10),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ViewNutritionist(privatePostDoc['uid'])));
                                                                      },
                                                                    ),
                                                                    Text(
                                                                      privatePostDoc[
                                                                          'username'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .textSelectionTheme
                                                                              .selectionColor,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (privatePostDoc[
                                                                        'type'] ==
                                                                    1)
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Divider(
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
                                                                        thickness:
                                                                            1,
                                                                      ),
                                                                      Text(
                                                                        privatePostDoc[
                                                                            'post'],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).textSelectionTheme.selectionColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                if (privatePostDoc[
                                                                        'type'] ==
                                                                    2)
                                                                  Column(
                                                                    children: [
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
                                                                      ),
                                                                      Image(
                                                                        image: NetworkImage(
                                                                            privatePostDoc['image']),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                Divider(
                                                                  thickness: 1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .dividerColor,
                                                                ),
                                                                if (privatePostDoc[
                                                                        'type'] ==
                                                                    3)
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Image(
                                                                        image: NetworkImage(
                                                                            privatePostDoc['image']),
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '${privatePostDoc['username']}:'),
                                                                          SizedBox(
                                                                            width:
                                                                                12,
                                                                          ),
                                                                          Text(privatePostDoc[
                                                                              'post']),
                                                                        ],
                                                                      ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
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
                                                                            privatePostLiked(privatePostDoc['id']);
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(privatePostDoc['likes'].contains(uid) ? Icons.thumb_up : Icons.thumb_up_off_alt, color: privatePostDoc['likes'].contains(uid) ? Colors.blue : Theme.of(context).iconTheme.color),
                                                                              Text(
                                                                                'Likes(${privatePostDoc['likes'].length.toString()})',
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
                                                                            Icons
                                                                                .textsms,
                                                                            color:
                                                                                Theme.of(context).iconTheme.color),
                                                                        GestureDetector(
                                                                          child: Text(
                                                                              'Comment(${privatePostDoc['commentCount'].toString()})',
                                                                              style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w600)),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) {
                                                                              return Comments(privatePostDoc['id'], privatePostDoc['uid']!.trim(), false);
                                                                            }));
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
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
                                            margin: EdgeInsets.only(bottom: 35),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                })),
          ],
        ),
      ),
    );
  }
}
