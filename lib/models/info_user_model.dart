import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strak_shop_project/services/database.dart';

import 'cart.dart';
import 'info_user.dart';

class InfoUserModel extends ChangeNotifier{


  CollectionReference _reference = FirebaseFirestore.instance.collection('list_user');

  final _auth = FirebaseAuth.instance;

  InfoUser? _listInfoUser;

 InfoUser? get getListInfoUser => _listInfoUser;

  List<Cart> _listCart = [];

  List<Cart> get getListCart => _listCart;


  InfoUserModel(){
    listenToInfoUser();
  }

  void listenToInfoUser() async {
     String? uid;
    _auth.authStateChanges().listen((firebaseUser) async {
      uid =  firebaseUser?.uid;
      print("UID :$uid");
      _listInfoUser = await DatabaseService(uid).getInfoUser();
      notifyListeners();
    });

    _reference.snapshots().listen((event) async {
      _listInfoUser = await DatabaseService(uid).getInfoUser();
      _listCart = await DatabaseService(uid).getListCart(_listInfoUser!);
      notifyListeners();
    });


  }




}