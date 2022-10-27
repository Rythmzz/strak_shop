import 'package:cloud_firestore/cloud_firestore.dart';

class Category{
  int _id;
  String _name;
  String _imageURL;
  String _imageName;
  String _genderStyle;

  Category(this._id,this._name,this._imageURL,this._imageName,this._genderStyle);

  factory Category.fromDocument(DocumentSnapshot doc){
    return Category(doc.data().toString().contains('id') ? doc.get('id') : null,
        doc.data().toString().contains('name') ? doc.get('name') : "",
        doc.data().toString().contains('imageURL') ? doc.get('imageURL') : "",
        doc.data().toString().contains('imageName') ? doc.get('imageName') : "",
        doc.data().toString().contains('genderStyle') ? doc.get('genderStyle') : "");
  }

  String get getImageName => _imageName;

  set imageName(String value) {
    _imageName = value;
  }

  String get getImageURL => _imageURL;

  set imageURL(String value) {
    _imageURL = value;
  }


  String get getName => _name;

  set name(String value) {
    _name = value;
  }

  int get getId => _id;

  set id(int value) {
    _id = value;
  }

  String get getGenderStyle => _genderStyle;

  set genderStyle(String value) {
    _genderStyle = value;
  }
}