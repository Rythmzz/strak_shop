import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  int? _id;
  String? _name;
  double? _price;
  double? _salePrice;
  List<String> _color;
  List<String> _size;
  List<String> _imageURL;
  List<String> _imageName;
  int? _idCategory;
  int? _view;
  String? _description;
  
  Product(this._id,this._name,this._price,
      this._salePrice,this._color,
      this._size,this._imageURL,this._imageName,
      this._idCategory,this._view,this._description);

  int promotionPercent(){
    return (100 - (_salePrice!/_price!) * 100).round();
  }
  
  
  factory Product.fromDocument(DocumentSnapshot doc){
    return Product(
        doc.data().toString().contains('id') ? doc.get('id') : -1,
        doc.data().toString().contains('name') ? doc.get('name') : "",
        doc.data().toString().contains('price') ? doc.get('price') : "",
        doc.data().toString().contains('salePrice') ? doc.get('salePrice') : "",
        doc.data().toString().contains('color') ? (doc.get('color') as List).map((e) => e as String).toList() : [],
        doc.data().toString().contains('size') ? (doc.get('size') as List).map((e) => e as String).toList() : [],
        doc.data().toString().contains('imageURL') ? (doc.get('imageURL') as List).map((e) => e as String).toList() : [],
        doc.data().toString().contains('imageName') ? (doc.get('imageName') as List).map((e) => e as String).toList() : [],
        doc.data().toString().contains('idCategory') ? doc.get('idCategory') : -1,
        doc.data().toString().contains('view') ? doc.get('view') : -1,
        doc.data().toString().contains('description') ? doc.get('description') : "");
  }

  void printProduct(){
    print(_id);
    print(_name);
    print(_price);
    print(_salePrice);
    _size?.forEach((element) {
      print(element);
    });
    _color?.forEach((element) {
      print(element);
    });
    _imageURL?.forEach((element) {
      print(element);
    });
    _imageName?.forEach((element) {
      print(element);
    });
    print(_idCategory);
    print(_view);
    print(_description);

  }

  void printName(){
    print(_name);
  }


  String? get getDescription => _description;

  set setDescription(String value) {
    _description = value;
  }

  double? get getSalePrice => _salePrice;

  set setSalePrice(double value) {
    _salePrice = value;
  }

  double? get getPrice => _price;

  set setPrice(double value) {
    _price = value;
  }

  String? get getName => _name;

  set setName(String value) {
    _name = value;
  }

  List<String>? get getListImageURL => _imageURL;


  int? get getId => _id;

  set setId(int value) {
    _id = value;
  }

  List<String>? get getImageName => _imageName;

  List<String>? get getImageURL => _imageURL;

  set setImageName(List<String> value) {
    _imageName = value;
  }
  void setValueOfIndexImageName(int index, String value){
    _imageName?[index] = value;
  }
  void setValueOfIndexImageURL(int index, String value){
    _imageURL?[index] = value;
  }

  List<String>? get getListColor => _color;

  set color(List<String> value) {
    _color = value;
  }
  void addColor(String color){
    _color?.add(color);
  }
  void deleteChipColor(String color){
    _color?.remove(color);
  }
  void deleteChipSize(String textSize){
    if(_size!.contains(textSize)){
      _size?.remove(textSize);
    }
  }

  int? get getIdCategory => _idCategory;

  set setIdCategory(int value) {
    _idCategory = value;
  }

  String? getSize(int index){
    return _size?[index];
  }


  List<String> get getListSize => _size;


  void setIndexSize(int index, String textSize){
    _size?[index] = textSize;
  }

  void addSize(String textSize){
    _size?.add(textSize);
  }

  void setIndexImageName(int index, String imageName){
    _imageName?[index] = imageName;
  }

  String? getIndexImageName (int index ){
    return _imageName?[index];
  }

  List<String>? get getListImageName => _imageName;

  int? get getView => _view;

  set setView(int view){
    _view = view;
  }


}