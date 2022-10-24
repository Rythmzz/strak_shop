import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:strak_shop_project/services/database.dart';

import 'cart.dart';
import 'order.dart';

class OrderModel extends ChangeNotifier{

  CollectionReference _reference = FirebaseFirestore.instance.collection('list_order');

  List<Order> _listOrder = [];

  List<Order> get getListOrder => _listOrder;

  // List<Cart> _listOrderDetail = [];
  //
  // List<Cart> get getListOrderDetail => _listOrderDetail;


  OrderModel(){
    listenToOrder();
  }

  void listenToOrder() {
    _reference.snapshots().listen((_) async {
      _listOrder = await DatabaseService().getListOrder();
      notifyListeners();
    });
  }



}