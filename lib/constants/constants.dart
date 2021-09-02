import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_reference;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTextStyleInteraction = TextStyle(fontSize: 12);

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
CollectionReference postCollection =
    FirebaseFirestore.instance.collection('posts');
CollectionReference nutritionistPublicPost =
    FirebaseFirestore.instance.collection('Nutritionist_Public_Post');
CollectionReference nutritionistCollection =
    FirebaseFirestore.instance.collection('Nutritionist_Users');
firebase_reference.Reference postPicture =
    firebase_reference.FirebaseStorage.instance.ref().child('postPicture');
CollectionReference nutritionistPost =
    FirebaseFirestore.instance.collection('Nutritionist_post');
const List<String> targetBodyType = [
  'Bulk',
  'Shred',
  'Lose weight',
];
List<Image> targetBodyIcon = [
  Image.asset('images/bulk.png'),
  Image.asset('images/noun_Core_61691 (1).png'),
  Image.asset('images/weight_lose.png'),
];
