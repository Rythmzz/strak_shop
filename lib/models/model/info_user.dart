

import 'cart.dart';

class InfoUser {
  String uid;
  String fullName;
  String gender;
  String birthDay;
  String imageURL;
  String imageName;
  String email;
  String phone;
  List<int> favorite;
  List<Cart> cart;

  InfoUser(
      {required this.uid,
      required this.fullName,
      required this.email,
      this.gender = 'male',
      this.birthDay = '01/01/2022',
      this.imageURL = ' ',
      this.imageName = ' ',
      this.phone = ' ',
      this.favorite = const [],
      this.cart = const []});

  String get getFullName => fullName;

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
        uid: json['uid'] ?? ' ',
        fullName: json['fullname'] ?? ' ',
        email: json['email'] ?? ' ',
        gender: json['gender'] ?? ' ',
        birthDay: json['birthday'] ?? ' ',
        imageURL: json['imageURL'] ?? ' ',
        phone: json['phone'] ?? ' ',
        favorite: (json['favorite'].cast<int>()) ?? const [],
        cart: Cart.fromListJson(json['cart']));
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullname': fullName,
        'email': email,
        'birthday': birthDay,
        'imageURL': imageURL,
        'imageName': imageName,
        'gender': gender,
        'phone': phone,
        'favorite': favorite,
        'cart': cart
      };

  @override
  String toString() {
    return '''
    uid $uid \n
    fullName $fullName \n
    email $email \n
    gender $gender \n,
    birthDay $birthDay \n
    phone $phone \n 
    imageURL $imageURL \n
    imageName $imageName \n
    favourite $favorite \n
    cart $cart \n
    ''';
  }

  String get getGender => gender;

  String get getBirthDay => birthDay;

  String get getEmail => email;

  String get getPhone => phone;

  String get getImageURL => imageURL;

  String get getImageName => imageName;

  String get getUid => uid;

  List<int> get getFavorite => favorite;

  List<Cart> get getCart => cart;
}
