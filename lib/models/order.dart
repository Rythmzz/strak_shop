import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  int _id;
  String _uid;
  String _orderDate;
  String _orderCode;
  String _orderNote;
  double _totalPrice;
  String _address;
  List<Object> _orderDetail;

  Order(this._id, this._uid,this._orderDate,this._orderCode,this._orderNote,this._totalPrice,this._address,this._orderDetail);

  factory Order.fromDocument(DocumentSnapshot doc){
    return Order(
      doc.data().toString().contains('id') ? doc.get('id') : -1,
      doc.data().toString().contains('uid') ? doc.get('uid') : "",
      doc.data().toString().contains('orderDate') ? doc.get('orderDate') : "",
      doc.data().toString().contains('orderCode') ? doc.get('orderCode') : "",
      doc.data().toString().contains('orderNote') ? doc.get('orderNote') : "",
      doc.data().toString().contains('totalPrice') ? doc.get('totalPrice') : -1.0,
      doc.data().toString().contains('address') ? doc.get('address') : "",
      doc.data().toString().contains('orderDetail') ? (doc.get('orderDetail') as List).map((e) => e as Map<String,dynamic>).toList() : [],
    );
  }


  void printOrder(){
    print(_id);
    print(_uid);
    print(_orderDate);
    print(_orderCode);
    print(_orderNote);
    print(_address);
  }


  String get getAddress => _address;

  set address(String value) {
    _address = value;
  }

  String get getOrderNote => _orderNote;

  set orderNote(String value) {
    _orderNote = value;
  }

  String get getOrderCode => _orderCode;

  set orderCode(String value) {
    _orderCode = value;
  }

  String get getOrderDate => _orderDate;

  set orderDate(String value) {
    _orderDate = value;
  }

  String get getUid => _uid;

  set uid(String value) {
    _uid = value;
  }

  int get getId => _id;

  set id(int value) {
    _id = value;
  }

  List<Object> get getOrderDetail => _orderDetail;

  set orderDetail(List<Object> value) {
    _orderDetail = value;
  }

  void addObject(Object order){
    _orderDetail.add(order);
  }


  double get getTotalPrice => _totalPrice;

  set totalPrice(double value) {
    _totalPrice = value;
  }
}