import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_template/provider/dark_theme+provider.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:new_template/screens/bio.dart';
import 'package:provider/provider.dart';
import 'package:new_template/constants/constants.dart';
import 'package:new_template/screens/user/user_profile/user_screen.dart';
import 'package:new_template/checkbox_items/widgets/list_tile.dart';
import '../navigation.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  File? imagePath;

  imagePicker(ImageSource imgSource) async {
    final image = await ImagePicker().getImage(source: imgSource);
    setState(() async {
      imagePath = File(image!.path);
      await updateProfileImage(imagePath!);
    });
    Navigator.pop(context);
  }

  uploadImage() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    var storageUpload =
        await postPicture.child(fireBaseUser.uid).putFile(imagePath!);
    TaskSnapshot storageTaskSnapshot = storageUpload;
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  updateProfileImage(File imagePath) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    String imageURL = await uploadImage();
    await userCollection.doc(fireBaseUser.uid).update({'profilePic': imageURL});
    Navigator.pop(context);
  }

  optionDialogImage() {
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

  //
  // newPost() async {
  //   var fireBaseUser = FirebaseAuth.instance.currentUser!;
  //   DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
  //   var documents = await postCollection.get();
  //   int length = documents.docs.length;
  //   if (imagePath != null) {
  //     String imageURL = await uploadImage('Post $length');
  //     await userCollection.doc(userDoc.id).update(
  //       {
  //         'profilePic': imageURL,
  //       },
  //     );
  //     Navigator.pop(context);
  //   }
  // }
  //
  updateDatabaseUsername(String newUpdate) async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    await userCollection.doc(fireBaseUser.uid).update({
      'username': name,
    });
    setState(() {});
    Navigator.pop(context);
  }

  ScrollController? _scrollController;
  TextEditingController? _textEditingController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    getUserInfo();
    super.initState();
  }

  String? username;
  String? profilePic;
  getUserInfo() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userDoc = await userCollection.doc(fireBaseUser.uid).get();
    setState(() {
      username = userDoc['username'];
      profilePic = userDoc['profilePic'];
    });
  }

  String? name;
  optionDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {},
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Enter new name',
                      hintStyle: TextStyle(color: Colors.grey)),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  updateDatabaseUsername(email);
                },
                child: Text('Update'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<DarkTHemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            setState(() {});
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 80),
          child: Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        controller: _scrollController,
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'User info',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTileContent(
                    icon: Icons.library_books,
                    mainTitle: 'Bio',
                    subTitle: '',
                    ontap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bio(),
                      ),
                    ),
                  ),
                  ListTileContent(
                    icon: Icons.drive_file_rename_outline,
                    mainTitle: 'UserName',
                    subTitle: username.toString(),
                    ontap: () {
                      setState(() {
                        optionDialog();
                      });
                    },
                  ),
                  ListTileContent(
                    icon: Icons.email_outlined,
                    mainTitle: 'User Email',
                    subTitle:
                        FirebaseAuth.instance.currentUser!.email.toString(),
                    ontap: () {},
                  ),
                  ListTileContent(
                    icon: Icons.date_range_outlined,
                    mainTitle: 'Joined Date',
                    subTitle: 'date',
                    ontap: () {},
                  ),
                  ListTileContent(
                    icon: Icons.image_outlined,
                    mainTitle: 'Update Image',
                    subTitle: '',
                    ontap: () {
                      setState(() {
                        optionDialogImage();
                      });
                    },
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionHandleColor),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTileSwitch(
                    value: themeChanger.darkTheme,
                    onChanged: (value) {
                      setState(() {
                        themeChanger.darkTheme = value;
                        UserScreen.newValue = value;
                      });
                    },
                    visualDensity: VisualDensity.comfortable,
                    switchType: SwitchType.cupertino,
                    switchActiveColor: Colors.indigo,
                    title: ListTileContent(
                      mainTitle: 'DarkTheme',
                      subTitle: '',
                      icon: Icons.circle,
                      ontap: () {},
                    ),
                  ),
                  ListTileContent(
                    icon: Icons.exit_to_app_rounded,
                    mainTitle: 'Logout',
                    subTitle: '',
                    ontap: () {
                      setState(() {
                        NavigationPage.isSigned = false;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NavigationPage();
                        })).whenComplete(() => Navigator.pop(context));
                      });
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
