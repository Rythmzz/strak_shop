import 'dart:convert';

import 'cart.dart';

class Order {
  int id;
  String uid;
  String orderDate;
  String orderCode;
  String orderNote;
  double totalPrice;
  String address;
  List<Cart> orderDetail;

  Order(
      {this.id = 0,
      this.uid = ' ',
      this.orderDate = ' ',
      this.orderCode = ' ',
      this.orderNote = ' ',
      this.totalPrice = 0.0,
      this.address = ' ',
      this.orderDetail = const []});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'] ?? 0,
        uid: json['uid'] ?? ' ',
        orderDate: json['orderDate'] ?? ' ',
        orderCode: json['orderCode'] ?? ' ',
        orderNote: json['orderNote'] ?? ' ',
        totalPrice: json['totalPrice'] ?? 0.0,
        address: json['address'] ?? ' ',
        orderDetail: Cart.fromListJson(json['orderDetail']));
  }

  Object toObject(Cart cart) {
    final String data = json.encode(cart);
    return jsonDecode(data);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'orderDate': orderDate,
        'orderCode': orderCode,
        'orderNote': orderNote,
        'totalPrice': totalPrice,
        'address': address,
        'orderDetail': orderDetail.map((e) {
          return toObject(e);
        }).toList()
      };

  @override
  String toString() {
    return '''
    id $id \n
    uid $uid \n
    orderDate $orderDate \n
    orderCode $orderCode \n,
    orderNote $orderNote \n
    totalPrice $totalPrice \n 
    address $address \n
    orderDetail $orderDetail \n
    ''';
  }

  String get getAddress => address;

  set setAddress(String value) {
    address = value;
  }

  String get getOrderNote => orderNote;

  set setOrderNote(String value) {
    orderNote = value;
  }

  String get getOrderCode => orderCode;

  set setOrderCode(String value) {
    orderCode = value;
  }

  String get getOrderDate => orderDate;

  set setOrderDate(String value) {
    orderDate = value;
  }

  String get getUid => uid;

  set setUid(String value) {
    uid = value;
  }

  int get getId => id;

  set setId(int value) {
    id = value;
  }

  List<Cart> get getOrderDetail => orderDetail;

  set setOrderDetail(List<Cart> value) {
    orderDetail = value;
  }

  double get getTotalPrice => totalPrice;

  set setTotalPrice(double value) {
    totalPrice = value;
  }

  void addCart(Cart cart) {
    orderDetail.add(cart);
  }
}
