import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_template/constants/constants.dart';

class Bio extends StatefulWidget {
  const Bio({Key? key}) : super(key: key);

  @override
  _BioState createState() => _BioState();
}

class _BioState extends State<Bio> {
  updateUserBio() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser!;

    await userCollection
        .doc(fireBaseUser.uid)
        .collection('Bio')
        .doc(fireBaseUser.uid)
        .get()
        .then((document) => {
              if (document.exists)
                {
                  userCollection
                      .doc(fireBaseUser.uid)
                      .collection('Bio')
                      .doc(fireBaseUser.uid)
                      .update({
                    'Bio': bioController.text,
                  })
                }
              else
                userCollection
                    .doc(fireBaseUser.uid)
                    .collection('Bio')
                    .doc(fireBaseUser.uid)
                    .set({
                  'Bio': bioController.text,
                })
            });
    // .set({'Bio': bioController.text});
  }

  TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              TextField(
                controller: bioController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Type in new bio'),
                onSubmitted: (value) {
                  updateUserBio();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
