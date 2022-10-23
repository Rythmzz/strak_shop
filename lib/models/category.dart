import 'package:cloud_firestore/cloud_firestore.dart';

class Category{
  int _id;
  String _name;
  String _imageURL;
  String _imageName;

  Category(this._id,this._name,this._imageURL,this._imageName);

  factory Category.fromDocument(DocumentSnapshot doc){
    return Category(doc.data().toString().contains('id') ? doc.get('id') : null,
        doc.data().toString().contains('name') ? doc.get('name') : "",
        doc.data().toString().contains('imageURL') ? doc.get('imageURL') : "",
      doc.data().toString().contains('imageName') ? doc.get('imageName') : "",);
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
}