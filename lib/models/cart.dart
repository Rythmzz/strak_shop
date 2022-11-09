import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  int? _idProduct;
  int? _amount;
  double? _price;
  String? _size;
  String? _color;

  Cart(this._idProduct,this._amount,this._price,this._size,this._color);

  Map<String,dynamic> toJson() =>
      {
        'idProduct' : _idProduct,
        'amount' : _amount,
        'price' : _price,
        'size' : _size,
        'color' : _color,
      };

   factory Cart.fromJson(dynamic json){
    return Cart(json['idProduct'] as int, json['amount'] as int, json['price'] as double, json['size'] as String, json['color'] as String);
  }

  @override
  String toString() {
    return super.toString();
  }
  double get total => (_price! * _amount!);

  double? get getPrice => _price;

  set price(double value) {
    _price = value;
  }

  int? get getAmount => _amount;

  set amount(int value) {
    _amount = value;
  }

  int? get getIdProduct => _idProduct;

  set idProduct(int value) {
    _idProduct = value;
  }

  String? get getColor => _color;

  set color(String value) {
    _color = value;
  }

  String? get getSize => _size;

  set size(String value) {
    _size = value;
  }
}