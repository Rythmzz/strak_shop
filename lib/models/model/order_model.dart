import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:strak_shop_project/services/service/database.dart';

import 'order.dart';

class OrderModel extends ChangeNotifier {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('list_order');

  List<Order> _listOrder = [];

  List<Order> get getListOrder => _listOrder;

  OrderModel() {
    listenToOrder();
  }

  void listenToOrder() {
    _reference.snapshots().listen((_) async {
      _listOrder = await DatabaseService().getListOrder();
      notifyListeners();
    });
  }
}
