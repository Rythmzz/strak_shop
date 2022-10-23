import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:strak_shop_project/services/database.dart';

import 'category.dart';

class CategoryModel extends ChangeNotifier{

  CollectionReference _reference = FirebaseFirestore.instance.collection("list_category");

  List<Category> _listCategory = [];

  List<Category> get getListCategory => _listCategory;

  CategoryModel(){
    _listenToCategory();
  }

  void _listenToCategory() async {
    _reference.snapshots().listen((_) async {
      _listCategory = await DatabaseService().getListCategory();
      notifyListeners();
    });

  }



}