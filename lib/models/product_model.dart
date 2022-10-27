import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/services/database.dart';

class ProductModel extends ChangeNotifier{

  CollectionReference _reference = FirebaseFirestore.instance.collection("list_product");

  List<Product> _listProduct = [];
  List<Product> get getListProduct => _listProduct;





  ProductModel(){
    _listenToListProduct();
  }




  void _listenToListProduct() async {
    _reference.snapshots().listen((_) async {
      _listProduct =await DatabaseService().getListProduct();
      notifyListeners();
    });

  }








}