import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strak_shop_project/models/category.dart';
import 'package:strak_shop_project/models/info_user.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/services/storage_repository.dart';

import '../models/cart.dart';
import '../models/order.dart';

class DatabaseService{
  final String? _uid;
  DatabaseService([this._uid]);
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  // Trích xuất dữ liệu của User
  Future updateInfoUser(String fullname, String email, String birthDay,String imageURL,String imageName, String gender, String phoneNumber, List<int> favorite, List<Cart> cart) async{
    return await _firebaseFirestore.collection('list_user').doc(_uid).set({
      'uid' : _uid,
      'fullname' : fullname,
      'email' : email,
      'birthday' : birthDay,
      'imageURL' : imageURL,
      'imageName': imageName,
      'gender' : gender,
      'phone' : phoneNumber,
      'favorite' : favorite,
      'cart' : cart
    });
  }
  Future updateAddIdProduct(int id) async {
    return await _firebaseFirestore.collection('list_user').doc(_uid).update({
      'favorite' : FieldValue.arrayUnion([id])
    });
  }
  Future updateRemoveIdProduct(int id) async {
    return await _firebaseFirestore.collection('list_user').doc(_uid).update({
      'favorite' : FieldValue.arrayRemove([id])
    });
  }
  Future<void> updateCart(Cart cart) async{
    // await Future.delayed(Duration(seconds: 2));
    FirebaseFirestore.instance.runTransaction((transaction)async{
      var result = await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart' : FieldValue.arrayUnion([cart.toJson()])
      });
    });

  }
  Future<void> updateIndexCart(Cart cart, int index) async{
    cart.amount = cart.getAmount! + index;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart' : FieldValue.arrayUnion([cart.toJson()])
      });
    });
  }
  Future removeCart(Cart cart) async{
    FirebaseFirestore.instance.runTransaction((transaction)async{
      return await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart' : FieldValue.arrayRemove([cart.toJson()])
      });
    });

  }
  Future removeIndexCart(Cart cart,int index) async{
    await Future.delayed(Duration(milliseconds: 100));
    cart.amount = cart.getAmount! - index;
    FirebaseFirestore.instance.runTransaction((transaction)async{
      return await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart' : FieldValue.arrayRemove([cart.toJson()])
      });
    });

  }


  Future updateViewProduct(int id) async{
    return await _firebaseFirestore.collection('list_product').doc(id.toString()).update({
      'view' : FieldValue.increment(1)
    });
  }

  // Get List User From Firestore
  Stream<List<InfoUser>> get getListUser {
    return _firebaseFirestore.collection('list_user').snapshots().map(getListUserFromFirestore);
     }
  List<InfoUser> getListUserFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      return InfoUser.fromDocument(data);
    }).toList();
  }

  // Stream<List<Category>> get streamListCategoryFirestore{
  //   return _firebaseFirestore.collection('list_category').snapshots().map(transformCategory);
  // }
  // List<Category> transformCategory(QuerySnapshot snapshot){
  //   return snapshot.docs.map((doc) {
  //     return Category.fromDocument(doc);
  //   }).toList();
  // }



// Get Current User With UID
  Future<InfoUser>  currentUserFromFirestore() async {
    DocumentSnapshot snap = await _firebaseFirestore.collection('list_user').doc(_uid).get();
    return InfoUser.fromDocument(snap);
  }
  Stream<InfoUser> getUser(){
      return _firebaseFirestore.collection('list_user')
          .doc(_uid)
          .snapshots()
          .map((snap) => InfoUser.fromDocument(snap));
  }
  Future<InfoUser> getInfoUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore.collection('list_user')
        .doc(_uid)
        .get();

    final data = InfoUser.fromDocument(snapshot);

    return data;


  }

  Future<void> updateAvatarUser(XFile image) async{
    String downloadURL = await StorageRepository().getDownloadURL(image.name,'user',_uid!);
    return _firebaseFirestore.collection('list_user').doc(_uid!).update({
      'imageURL' : downloadURL,
      'imageName' : image.name
    });
  }


  Future<void> updateImageProduct(XFile image,int id,int index) async{
    String downloadURL = await StorageRepository().getDownloadURLProduct(image.name, id, index);
    return _firebaseFirestore.collection('list_product').doc(id.toString()).update({
      'imageURL' : FieldValue.arrayUnion([downloadURL]),
      'imageName' : FieldValue.arrayUnion([image.name])
    });
  }

  // Trích xuất dữ liệu của Products
  Future createNewProduct(List<XFile?> listXFilePicked, List<String> listIndexImageName ,int id,String name, double price, double salePrice,
      List<String> color, List<String> size,
      int idCategory,int view, String description) async {
   // final int documentLength = await _firebaseFirestore.collection('list_product').snapshots().length;
    _firebaseFirestore.collection('list_product').doc(id.toString()).set({
      'id' : id,
      'name' : name,
      'price' : price,
      'salePrice' : salePrice,
      'color' : color,
      'size' : size,
      'idCategory' : idCategory,
      'view' : view,
      'description' : description
    }).then((value) async {
      for(int i = 0 ; i < listXFilePicked.length;i++){
        if( listXFilePicked[i] != null){
          await  StorageRepository().uploadFileImageProduct(listXFilePicked[i]!, id, i, listIndexImageName[i]);
          print(listXFilePicked[i]!.name);
          print(id);
          print(i);
          print(listIndexImageName[i]);
        }
      }
    });
    
  }
  Future<List<Product>> getListProduct() async {
    QuerySnapshot snapshot = await _firebaseFirestore.collection('list_product').get();
    final allData = snapshot.docs.map((doc) {
      return Product.fromDocument(doc);
    }).toList();
    return allData;
  }


  Future<List<Product>> getProductWith50Percent({required int page, required int limit}) async{
    if (limit <=0 ) return [];
    await Future.delayed(Duration(seconds: 2));

    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value){
       for(var x in value){
         if((100 - (x.getSalePrice!/x.getPrice!)*100).round() >= 50 && x.getSalePrice != 0){
           listProduct.add(x);
         }
       }
    });

    return await listProduct.skip((page - 1) * limit).take(limit).toList();
  }

  Future<List<Product>> getProductWithFlashSale({required int page, required int limit}) async{
    if( limit < 0 ) return [];
    await Future.delayed(Duration(seconds: 2));

    final List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for(int i = 0 ; i < value.length ; i++){
        if(value[i].getSalePrice != 0){
          listProduct.add(value[i]);
        }
      }
    });

    return listProduct.skip((page - 1)*limit).take(limit).toList();
  }



  Future<List<Product>> getProductWithFavorite({required List<int> id}) async{
    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for(int i = 0 ; i < id.length ; i++){
        for(var x in value){
          if(x.getId == id[i]){
            listProduct.add(x);
          }
        }
      }
    });
    return listProduct;
  }
  Future<List<Product>> getProductWithChar(String char) async {
    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for(int i = 0 ; i < value.length ; i++){
        if(value[i].getName!.toLowerCase().contains(char.toLowerCase())){
          listProduct.add(value[i]);
        }
      }
    });
    return listProduct;
  }

  Future<List<Product>> getProductMaxView() async{
    List<Product> listProduct = await DatabaseService().getListProduct();

    for (int i = 0 ; i< listProduct.length ; i++){
      for(int j = i + 1 ; j < listProduct.length ; j++){
        if(listProduct[i].getView! < listProduct[j].getView!){
          Product temp = listProduct[i];
          listProduct[i] = listProduct[j];
          listProduct[j] = temp;
        }
      }
    }
    return listProduct.take(5).toList();
  }

  // Future<Product> getProductInCart(Cart cart) async{
  //   Product? product;
  //   await DatabaseService().getListProduct().then((value) {
  //     for(int i = 0 ; i < value.length ; i++){
  //       if(value[i].getId == cart.getIdProduct){
  //         print(value[i].getId);
  //         product = value[i];
  //         break;
  //       }
  //     }
  //   });
  //   return product!;
  // }

  Future<List<Cart>> getListCartFromUser(InfoUser snapshot) async{
    List<Cart> _listCart = [];
    snapshot.cart.forEach((element) {
      String data = json.encode(element);
      _listCart.add(Cart.fromJson(jsonDecode(data)));
    });
    if(_listCart != []){
      for(int i = 0 ; i < _listCart.length ; i++){
        for(int j = i + 1; j < _listCart.length ; j++){
          if(_listCart[i].getIdProduct! > _listCart[j].getIdProduct! ||
              (_listCart[i].getIdProduct == _listCart[j].getIdProduct &&
                  (_listCart[i].getSize!.compareTo(_listCart[j].getSize!) == 1 ||
                  _listCart[i].getColor!.compareTo(_listCart[j].getColor!) == 1))){
            Cart temp = _listCart[i];
            _listCart[i] = _listCart[j];
            _listCart[j] = temp;
          }
        }
      }
    }
    return _listCart;
  }




  Future<List<Category>> getListCategory() async{
    QuerySnapshot querySnapshot = await _firebaseFirestore.collection('list_category').get();
    final allData = querySnapshot.docs.map((doc) {
      return Category.fromDocument(doc);
    }).toList();
    return allData;
  }
  
  Future createNewCategory(int id, String name,String downloadURL, String imageName,) async{
    await _firebaseFirestore.collection('list_category').doc(id.toString()).set({
      'id':id,
      'name' : name ,
      'imageURL' : downloadURL,
      'imageName' : imageName,
    });
  }


  Future<List<Cart>> getListCartFromOrder(Order snapshot) async {
    List<Cart> _listCart = [];
    snapshot.getOrderDetail.forEach((element) {
      String data = json.encode(element);
      _listCart.add(Cart.fromJson(jsonDecode(data)));
    });
    return _listCart;
  }

  Future<List<Order>> getListOrder() async{
    QuerySnapshot querySnapshot = await _firebaseFirestore.collection('list_order').get();
    final allData = querySnapshot.docs.map((doc) {
      return Order.fromDocument(doc);
    }).toList();
    return allData;

  }

  Future createNewOrder(int id,String orderDate,String orderCode,String orderNote,double totalPrice,String address,List<Object> currentCart) async {
    await _firebaseFirestore.collection('list_order').doc(id.toString()).set({
      'id' : id,
      'uid' : _uid,
      'orderDate' : orderDate,
      'orderCode' : orderCode,
      'orderNote' : orderNote,
      'totalPrice' : totalPrice,
      'address' : address,
      'orderDetail' : currentCart
    });

  }





}