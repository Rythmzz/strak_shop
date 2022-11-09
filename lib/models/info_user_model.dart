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

  int _selectIndex = 0;

  int get getSelectIndex => _selectIndex;

  set setSelectIndex(int val){
    _selectIndex = val;
    notifyListeners();
  }

  double totalPrice(){
    return _listCart.fold(0.0, (total, cart) => total + cart.total);
  }

  InfoUserModel(){
    listenToInfoUser();
  }

  void listenToInfoUser() async {
     String? uid;
    _auth.authStateChanges().listen((firebaseUser) async {
      uid =  firebaseUser?.uid;
      try{
        _listInfoUser = await DatabaseService(uid).getInfoUser();
      }
      catch(e){
        print("InfoUser null");
      }
      _listCart = await DatabaseService(uid).getListCartFromUser(_listInfoUser!);
      _selectIndex = 0;
      notifyListeners();
    });

    _reference.snapshots().listen((event) async {
      _listInfoUser = await DatabaseService(uid).getInfoUser();
      _listCart = await DatabaseService(uid).getListCartFromUser(_listInfoUser!);
      notifyListeners();
    });

  }




}