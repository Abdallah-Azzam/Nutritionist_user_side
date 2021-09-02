import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/feeds/post/comments_page.dart';

class ViewNutritionist extends StatefulWidget {
  final String uid;
  ViewNutritionist(this.uid);

  @override
  _ViewNutritionistState createState() => _ViewNutritionistState();
}

class _ViewNutritionistState extends State<ViewNutritionist> {
  bool? isFollowing;
  late int following;
  late int followers;
  late String degree;
  late String school;
  late String certification;
  late String expertise;
  late String experience;
  late Stream<QuerySnapshot> nutritionistStream;
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

  late Stream<QuerySnapshot> nutritionistPublicStream;
  String? onlineUserUid;
  getCurrentUser() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    setState(() {
      onlineUserUid = fireBaseUser.uid;
    });
    var followersCount = await nutritionistCollection
        .doc(widget.uid)
        .collection('followers')
        .get();
    var followingCount = await nutritionistCollection
        .doc(widget.uid)
        .collection('following')
        .get();
    nutritionistCollection
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
      following = followingCount.docs.length;
      followers = followersCount.docs.length;
    });
  }

  followUser() async {
    var document = await nutritionistCollection
        .doc(widget.uid)
        .collection('followers')
        .doc(onlineUserUid)
        .get();
    if (!document.exists) {
      nutritionistCollection
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineUserUid)
          .set({
        'username': userUsername.toString(),
        'profilePic': userprofilePic.toString(),
        'userId': onlineUserUid.toString(),
      });

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
      nutritionistCollection
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

  late bool isSubscribed;
  postLiked(String documentId) async {
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

  bool loading = true;
  late int subscribers;
  String? username;
  String? profilePic;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc =
        await nutritionistCollection.doc(widget.uid).get();
    var subscribersCount = await nutritionistCollection
        .doc(widget.uid)
        .collection('subscribers')
        .get();

    await nutritionistCollection
        .doc(widget.uid)
        .collection('subscribers')
        .doc(fireBaseUser.uid)
        .get()
        .then((document) => {
              if (document.exists)
                {
                  setState(() {
                    isSubscribed = true;
                  })
                }
              else
                {
                  setState(() {
                    isSubscribed = false;
                  })
                }
            });
    setState(() {
      username = userDoc['username'];
      subscribers = subscribersCount.docs.length;
      profilePic = userDoc['profilePic'];
      degree = userDoc['degree'];
      school = userDoc['school'];
      certification = userDoc['other certification'];
      expertise = userDoc['area of expertise'];
      experience = userDoc['years of experience'];
      loading = false;
    });
  }

  getStream() {
    setState(() {
      nutritionistStream = nutritionistPost
          .where('uid', isEqualTo: widget.uid.trim())
          .snapshots();

      nutritionistPublicStream = nutritionistPublicPost
          .where('uid', isEqualTo: widget.uid.trim())
          .snapshots();
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getCurrentUserInfo();
    getUserInfo();
    getStream();
    super.initState();
  }

  String? allergies;
  String? foodPref;
  String? height;
  String? currentWeight;
  String? targetWeight;
  String? targetBody;
  String? userUsername;
  String? userprofilePic;

  getCurrentUserInfo() async {
    DocumentSnapshot currentUser =
        await userCollection.doc(onlineUserUid).get();

    setState(() {
      allergies = currentUser['allergies'];
      foodPref = currentUser['foodPreference'];
      height = currentUser['height'];
      currentWeight = currentUser['currentWeight'];
      targetWeight = currentUser['targetWeight'];
      targetBody = currentUser['targetBodyType'];
      userUsername = currentUser['username'];
      userprofilePic = currentUser['profilePic'];
    });
  }

  int view = 1;
  subscribeToUser() async {
    var document = await nutritionistCollection
        .doc(widget.uid)
        .collection('subscribers')
        .doc(onlineUserUid)
        .get();
    if (!document.exists) {
      userCollection.doc(onlineUserUid).update({
        'subscriptions': [widget.uid]
      });
      nutritionistCollection
          .doc(widget.uid)
          .collection('subscribers')
          .doc(onlineUserUid)
          .set({
        'allergies': allergies.toString(),
        'foodPreference': foodPref.toString(),
        'height': height.toString(),
        'currentWeight': currentWeight.toString(),
        'targetWeight': targetWeight.toString(),
        'targetBody': targetBody.toString(),
        'username': userUsername.toString(),
        'profilePic': userprofilePic.toString(),
        'userId': onlineUserUid.toString(),
      });

      setState(() {
        subscribers++;

        isSubscribed = true;

        userCollection
            .doc(onlineUserUid)
            .collection('subscriptions')
            .doc(widget.uid)
            .set({'isSubscribed': isSubscribed});
      });
    } else {
      nutritionistCollection
          .doc(widget.uid)
          .collection('subscribers')
          .doc(onlineUserUid)
          .delete();
      userCollection
          .doc(onlineUserUid)
          .update({'subscriptions': [].remove(widget.uid)});
      userCollection
          .doc(onlineUserUid)
          .collection('subscriptions')
          .doc(widget.uid)
          .delete();

      setState(() {
        subscribers--;
        isSubscribed = false;

        userCollection
            .doc(onlineUserUid)
            .collection('subscriptions')
            .doc(widget.uid)
            .set({'isSubscribed': isSubscribed});
      });
    }
  }

  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    username.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Following',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          following.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Column(children: [
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionTheme
                                                .selectionColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        followers.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionTheme
                                                .selectionColor,
                                            fontSize: 14),
                                      )
                                    ]),

                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Subscribers',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          subscribers.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.spaceEvenly,
                                    //   children: [
                                    //
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nutritionist credentials:',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Icon(Icons.school),
                                          Text(
                                            ' Degree: ',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionTheme
                                                    .selectionColor,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'Tajwal'),
                                          ),
                                          Text(
                                            degree,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionTheme
                                                    .selectionColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Tajwal'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.apartment_outlined),
                                        Text(
                                          ' School: ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Tajwal'),
                                        ),
                                        Text(
                                          school,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Tajwal'),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.work_outline),
                                        Text(
                                          ' Years of experience: ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Tajwal'),
                                        ),
                                        Text(
                                          experience,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Tajwal'),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.badge),
                                        Text(
                                          ' Expertise: ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Tajwal'),
                                        ),
                                        Text(
                                          expertise,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .selectionColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Tajwal'),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        subscribeToUser();
                                        if (isFollowing == false) followUser();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(141, 30, 23, 1),
                                              Color.fromRGBO(141, 30, 23, 0.3),
                                            ])),
                                        child: Center(
                                            child: Text(
                                          isSubscribed == false
                                              ? 'subscribe'
                                              : 'unsubscribe',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.030,
                                  ),
                                  isSubscribed
                                      ? Text('')
                                      : Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              followUser();
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color.fromRGBO(
                                                        141, 30, 23, 1),
                                                    Color.fromRGBO(
                                                        141, 30, 23, 0.3),
                                                  ])),
                                              child: Center(
                                                  child: Text(
                                                isFollowing == false
                                                    ? 'follow'
                                                    : 'unfollow',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Reviews',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionTheme
                                                .selectionColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        for (int i = 0; i < 5; i++)
                                          Icon(Icons.star_border)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        child: Text('Public post'),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          view = 2;
                                        });
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Text('Private post'),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          view = 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
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
                                  margin: const EdgeInsets.only(bottom: 0),
                                  child: DottedLine(
                                    dashColor: Theme.of(context).dividerColor,
                                  )),
                              view == 1
                                  ? isSubscribed
                                      ? StreamBuilder<QuerySnapshot>(
                                          stream: nutritionistStream,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CircularProgressIndicator();
                                            }
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          6),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .backgroundColor)),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.topLeft,
                                                                                child: CircleAvatar(
                                                                                  radius: 18,
                                                                                  foregroundImage: NetworkImage(postDoc['profilePic']),
                                                                                ),
                                                                                margin: const EdgeInsets.all(10),
                                                                              ),
                                                                              Text(
                                                                                postDoc['username'],
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          if (postDoc['type'] ==
                                                                              1)
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Divider(
                                                                                  color: Theme.of(context).dividerColor,
                                                                                  thickness: 1,
                                                                                ),
                                                                                Text(
                                                                                  postDoc['post'],
                                                                                  style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          if (postDoc['type'] ==
                                                                              2)
                                                                            Column(
                                                                              children: [
                                                                                Divider(
                                                                                  thickness: 1,
                                                                                  color: Theme.of(context).dividerColor,
                                                                                ),
                                                                                Image(
                                                                                  image: NetworkImage(postDoc['image']),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          Divider(
                                                                            thickness:
                                                                                1,
                                                                            color:
                                                                                Theme.of(context).dividerColor,
                                                                          ),
                                                                          if (postDoc['type'] ==
                                                                              3)
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Image(
                                                                                  image: NetworkImage(postDoc['image']),
                                                                                ),
                                                                                Divider(
                                                                                  thickness: 1,
                                                                                  color: Theme.of(context).dividerColor,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Text('${postDoc['username']}:'),
                                                                                    SizedBox(
                                                                                      width: 12,
                                                                                    ),
                                                                                    Text(postDoc['post']),
                                                                                  ],
                                                                                ),
                                                                                Divider(
                                                                                  thickness: 1,
                                                                                  color: Theme.of(context).dividerColor,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  // LikeButton(
                                                                                  //   likeBuilder:
                                                                                  //       (bool isLiked) {
                                                                                  //     return Row(
                                                                                  //       children: [
                                                                                  //         // postLiked(
                                                                                  //         //     postDoc[
                                                                                  //         //         'id']),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      postLiked(postDoc['id']);
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          postDoc['likes'].contains(onlineUserUid) ? Icons.thumb_up : Icons.thumb_up_off_alt,
                                                                                          color: postDoc['likes'].contains(onlineUserUid) ? Colors.blue : Theme.of(context).iconTheme.color,
                                                                                        ),
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
                                                                                  Icon(Icons.textsms, color: Theme.of(context).iconTheme.color),
                                                                                  GestureDetector(
                                                                                    child: Text('Comment(${postDoc['commentCount'].toString()})', style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w600)),
                                                                                    onTap: () {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                        return Comments(postDoc['id'], widget.uid.trim(), false);
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
                                                                          top:
                                                                              8,
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          bottom: 35),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          })
                                      : Center(
                                          child: Container(
                                            child: Text(
                                                'Subscribe to see user posts'),
                                          ),
                                        )
                                  : StreamBuilder<QuerySnapshot>(
                                      stream: nutritionistPublicStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .backgroundColor)),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
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
                                                                              radius: 18,
                                                                              foregroundImage: NetworkImage(postDoc['profilePic']),
                                                                            ),
                                                                            margin:
                                                                                const EdgeInsets.all(10),
                                                                          ),
                                                                          Text(
                                                                            postDoc['username'],
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                color: Theme.of(context).textSelectionTheme.selectionColor,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if (postDoc[
                                                                              'type'] ==
                                                                          1)
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Divider(
                                                                              color: Theme.of(context).dividerColor,
                                                                              thickness: 1,
                                                                            ),
                                                                            Text(
                                                                              postDoc['post'],
                                                                              style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      if (postDoc[
                                                                              'type'] ==
                                                                          2)
                                                                        Column(
                                                                          children: [
                                                                            Divider(
                                                                              thickness: 1,
                                                                              color: Theme.of(context).dividerColor,
                                                                            ),
                                                                            Image(
                                                                              image: NetworkImage(postDoc['image']),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      Divider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
                                                                      ),
                                                                      if (postDoc[
                                                                              'type'] ==
                                                                          3)
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Image(
                                                                              image: NetworkImage(postDoc['image']),
                                                                            ),
                                                                            Divider(
                                                                              thickness: 1,
                                                                              color: Theme.of(context).dividerColor,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text('${postDoc['username']}:'),
                                                                                SizedBox(
                                                                                  width: 12,
                                                                                ),
                                                                                Text(postDoc['post']),
                                                                              ],
                                                                            ),
                                                                            Divider(
                                                                              thickness: 1,
                                                                              color: Theme.of(context).dividerColor,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              // LikeButton(
                                                                              //   likeBuilder:
                                                                              //       (bool isLiked) {
                                                                              //     return Row(
                                                                              //       children: [
                                                                              //         // postLiked(
                                                                              //         //     postDoc[
                                                                              //         //         'id']),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  publicPostLiked(postDoc['id']);
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(postDoc['likes'].contains(onlineUserUid) ? Icons.thumb_up : Icons.thumb_up_off_alt, color: postDoc['likes'].contains(onlineUserUid) ? Colors.blue : Theme.of(context).iconTheme.color),
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
                                                                                color: Theme.of(context).iconTheme.color,
                                                                                // Theme.of(
                                                                                //         context)
                                                                                //     .iconTheme
                                                                                //     .color,
                                                                              ),
                                                                              GestureDetector(
                                                                                child: Text('Comment(${postDoc['commentCount'].toString()})', style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w600)),
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                    return Comments(postDoc['id'], onlineUserUid.toString(), true);
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
                                                                          top:
                                                                              8,
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 35),
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
