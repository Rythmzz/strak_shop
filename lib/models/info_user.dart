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

  InfoUser.createDefault(this._uid,this._fullName,this._email) : _gender ="male", _birthDay ="01/01/2022",_imageURL ="",_imageName="",_phone="",_favorite=[],_cart=[];


  String get fullName => _fullName;

  factory InfoUser.fromDocument(DocumentSnapshot doc, Map docdata){
    return InfoUser(
         docdata['uid'] ?? '\$',
        docdata['fullname'] ?? '\$',
         docdata['gender'] ?? '\$',
         docdata['birthday'] ?? '\$',
        docdata['imageURL'] ??  '\$',
        docdata['imageName'] ?? '\$',
        docdata['email'] ?? '\$',
        docdata['phone'] ??'\$',
        (docdata['favorite'] as List).map((e) => e as int).toList() ?? [],
        (docdata['cart'] as List).map((e) => e as Map<String,dynamic>).toList() ?? []);
  }

  Map<String,dynamic> toJson() => {
    'uid' : _uid,
    'fullname' : _fullName,
    'email' : _email,
    'birthday' : _birthDay,
    'imageURL' : _imageURL,
    'imageName': _imageName,
    'gender' : _gender,
    'phone' : _phone,
    'favorite' : _favorite,
    'cart' : _cart
  };

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