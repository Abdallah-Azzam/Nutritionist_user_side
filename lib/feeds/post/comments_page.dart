import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_template/screens/search/view_profile/view_nutristionist.dart';
import 'package:new_template/screens/search/view_profile/view_user.dart';
import 'package:new_template/screens/user/user_profile/user_screen.dart';
import 'dart:core';
import 'package:timeago/timeago.dart' as tAgo;
import 'package:new_template/constants/constants.dart';

class Comments extends StatefulWidget {
  final String documentId;
  final String uid;
  final bool publicNutritionistPost;
  Comments(this.documentId, this.uid, this.publicNutritionistPost);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController? _commentController;
  late bool isSubscribed;
  bool loadingComments = true;
  getSubscriptions() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot get = await userCollection
        .doc(fireBaseUser.uid)
        .collection('subscriptions')
        .doc(widget.uid)
        .get();
    if (get.exists) {
      setState(() {
        isSubscribed = true;
      });

      loadingComments = false;
    } else {
      setState(() {
        isSubscribed = false;
      });
      loadingComments = false;
    }
    print(isSubscribed);
  }

  addSubscribeComment() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    nutritionistPost.doc(widget.documentId).collection('comments').doc().set({
      'comment': _commentController!.text,
      'username': userDoc['username'],
      'profilePic': userDoc['profilePic'],
      'time': DateTime.now(),
      'uid': userDoc['uid']
    });
    DocumentSnapshot commentCount =
        await nutritionistPost.doc(widget.documentId).get();

    nutritionistPost.doc(widget.documentId).update({
      'commentCount': commentCount['commentCount'] + 1,
    });
    _commentController!.clear();
  }

  late DocumentSnapshot postDoc;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    postDoc = await userCollection.doc(fireBaseUser.uid).get();
  }

  addComment() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    postCollection.doc(widget.documentId).collection('comments').doc().set({
      'comment': _commentController!.text,
      'username': userDoc['username'],
      'profilePic': userDoc['profilePic'],
      'time': DateTime.now(),
      'uid': userDoc['uid']
    });
    DocumentSnapshot commentCount =
        await postCollection.doc(widget.documentId).get();

    postCollection.doc(widget.documentId).update({
      'commentCount': commentCount['commentCount'] + 1,
    });
    _commentController!.clear();
  }

  addPublicComment() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    nutritionistPublicPost
        .doc(widget.documentId)
        .collection('comments')
        .doc()
        .set({
      'comment': _commentController!.text,
      'username': userDoc['username'],
      'profilePic': userDoc['profilePic'],
      'time': DateTime.now(),
      'uid': userDoc['uid']
    });
    DocumentSnapshot commentCount =
        await nutritionistPublicPost.doc(widget.documentId).get();

    nutritionistPublicPost.doc(widget.documentId).update({
      'commentCount': commentCount['commentCount'] + 1,
    });
    _commentController!.clear();
  }

  ScrollController? _scrollController;
  @override
  void initState() {
    getUserInfo();
    getSubscriptions();
    _commentController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadingComments
        ? Center(child: Container(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            bottomSheet: BottomAppBar(
              child: BottomAppBar(
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor),
                        textAlign: TextAlign.center,
                        controller: _commentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).backgroundColor,
                                  width: 1)),
                          hintText: 'Add Comment',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      heroTag: '',
                      onPressed: () {
                        setState(() {
                          if (_commentController != null) {
                            isSubscribed
                                ? addSubscribeComment()
                                : widget.publicNutritionistPost
                                    ? addPublicComment()
                                    : addComment();
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 32,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: FloatingActionButton(
                  heroTag: '3',
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color,
                  )),
              title: Text(
                'Comments',
                style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionColor),
              ),
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: isSubscribed
                          ? nutritionistPost
                              .doc(widget.documentId)
                              .collection('comments')
                              .snapshots()
                          : widget.publicNutritionistPost
                              ? nutritionistPublicPost
                                  .doc(widget.documentId)
                                  .collection('comments')
                                  .snapshots()
                              : postCollection
                                  .doc(widget.documentId)
                                  .collection('comments')
                                  .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, int index) {
                              DocumentSnapshot commentDoc =
                                  snapshot.data!.docs[index];

                              return ListTile(
                                title: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            child: CircleAvatar(
                                              radius: 15,
                                              foregroundImage: NetworkImage(
                                                  commentDoc['profilePic']),
                                            ),
                                            onTap: () async {
                                              String uid = commentDoc['uid'];
                                              if (uid != postDoc['uid']) {
                                                DocumentSnapshot d =
                                                    await userCollection
                                                        .doc(uid)
                                                        .get();
                                                if (d.exists) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewUser(uid)));
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewNutritionist(
                                                                  uid)));
                                                }
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserScreen()));
                                              }

                                              //   if (nutritionistCollection
                                              //         .where(
                                              //             commentDoc['uid']) ==
                                              //     uid && uid!=postDoc['uid']) {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               ViewNutritionist(
                                              //                   uid)));
                                              // }
                                            }),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 5),
                                          child: Text(commentDoc['username'],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textSelectionTheme
                                                    .selectionColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Tajwal',
                                              )),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              commentDoc['comment'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textSelectionTheme
                                                      .selectionColor,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          tAgo
                                              .format(
                                                  commentDoc['time'].toDate())
                                              .toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DottedLine(
                                        dashColor:
                                            Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }),
                  Divider(),
                  ListTile(),
                ],
              ),
            ),
          );
  }
}
