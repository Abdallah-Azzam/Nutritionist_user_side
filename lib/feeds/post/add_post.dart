import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_template/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController? _postController;
  File? imagePath;
  bool uploading = false;
  imagePicker(ImageSource imgSource) async {
    final image = await ImagePicker().getImage(source: imgSource);
    setState(() {
      imagePath = File(image!.path);
    });
    Navigator.pop(context);
  }

  optionDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  return imagePicker(ImageSource.gallery);
                },
                child: Text('Pick from Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  return imagePicker(ImageSource.camera);
                },
                child: Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }

  uploadImage(String id) async {
    var storageUpload = await postPicture.child(id).putFile(imagePath!);
    TaskSnapshot storageTaskSnapshot = storageUpload;
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  newPost() async {
    setState(() {
      uploading = true;
    });
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    var documents = await postCollection.get();
    int length = documents.docs.length;

    if (_postController?.text != '' && imagePath == null) {
      postCollection.doc('Post $length').set({
        'username': userDoc['username'],
        'profilePic': userDoc['profilePic'],
        'uid': fireBaseUser.uid,
        'post': _postController!.text,
        'id': 'Post $length',
        'likes': [],
        'commentCount': 0,
        'type': 1,
        'timestamp': Timestamp.now()
      });
      Navigator.pop(context);
    }
    if (_postController?.text == '' && imagePath != null) {
      String imageURL = await uploadImage('Post $length');
      postCollection.doc('Post $length').set({
        'username': userDoc['username'],
        'profilePic': userDoc['profilePic'],
        'uid': fireBaseUser.uid,
        'image': imageURL,
        'id': 'Post $length',
        'likes': [],
        'commentCount': 0,
        'type': 2,
        'timestamp': Timestamp.now()
      });
      Navigator.pop(context);
    }
    if (_postController?.text != '' && imagePath != null) {
      String imageURL = await uploadImage('Post $length');
      postCollection.doc('Post $length').set({
        'username': userDoc['username'],
        'profilePic': userDoc['profilePic'],
        'uid': fireBaseUser.uid,
        'image': imageURL,
        'id': 'Post $length',
        'post': _postController!.text,
        'likes': [],
        'commentCount': 0,
        'type': 3,
        'timestamp': Timestamp.now()
      });
      Navigator.pop(context);
    }
    if (_postController?.text == '' && imagePath == null) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _postController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Add Post',
              style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor),
            ),
            actions: [
              InkWell(
                child: Icon(
                  Icons.image_outlined,
                  color: Theme.of(context).iconTheme.color,
                  size: 42,
                ),
                onTap: () {
                  return optionDialog();
                },
              ),
            ],
          ),
          body: uploading == false
              ? ListView(shrinkWrap: true, children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _postController,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: ('what\'s on ur mind?'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        child: FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            newPost();
                          },
                          child: Icon(
                            Icons.send_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      )
                    ],
                  ),
                  imagePath == null
                      ? Container()
                      : MediaQuery.of(context).viewInsets.bottom == 0
                          ? Expanded(
                              child: Container(
                                child: Image(
                                  image: FileImage(imagePath!),
                                ),
                              ),
                            )
                          : Container(),
                ])
              : Center(
                  child: Text(
                    'Uploading.....',
                    style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor),
                  ),
                )),
    );
  }
}
