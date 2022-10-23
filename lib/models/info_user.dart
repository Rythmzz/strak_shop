import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart.dart';

class InfoUser{
  String _uid;
  String _fullName;
  String _gender;
  String _birthDay;
  String _imageURL;
  String _imageName;
  String _email;
  String _phone;
  List<int> _favorite;
  List<Object> _cart;

  InfoUser(this._uid,this._fullName,this._gender,this._birthDay,this._imageURL,this._imageName,this._email,this._phone,this._favorite,this._cart);


  String get fullName => _fullName;

  factory InfoUser.fromDocument(DocumentSnapshot doc){
    return InfoUser(
        doc.data().toString().contains('uid') ? doc.get('uid'): '\$',
        doc.data().toString().contains('fullname') ? doc.get('fullname'): '\$',
        doc.data().toString().contains('gender') ? doc.get('gender') : '\$',
        doc.data().toString().contains('birthday') ? doc.get('birthday') : '\$',
        doc.data().toString().contains('imageURL') ? doc.get('imageURL') : '\$',
        doc.data().toString().contains('imageName') ? doc.get('imageName') :'\$',
        doc.data().toString().contains('email') ? doc.get('email') : '\$',
        doc.data().toString().contains('phone') ? doc.get('phone') : '\$',
        doc.data().toString().contains('favorite') ? (doc.get('favorite') as List).map((e) => e as int).toList() : [],
        doc.data().toString().contains('cart') ? (doc.get('cart') as List).map((e) => e as Map<String,dynamic>).toList() : []);
  }

  String get gender => _gender;

  String get birthDay => _birthDay;

  String get email => _email;

  String get phone => _phone;

  String get imageUrls => _imageURL;

  String get imageName => _imageName;

  String get uid => _uid;

  List<int> get favorite => _favorite;

  List<Object> get cart => _cart;

  void printUser(){
    print(_uid);
    print(_fullName);
    print(_email);
    print(_gender);
    print(_birthDay);
    print(_phone);
    print(_imageURL);
    print(_imageName);
  }
}