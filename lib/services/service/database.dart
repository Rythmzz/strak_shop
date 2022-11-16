import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strak_shop_project/services/service/storage_repository.dart';
import 'package:strak_shop_project/models/model.dart';


class DatabaseService {
  final String? _uid;

  DatabaseService([this._uid]);

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // User Management Features

  Future updateInfoUser(InfoUser infoUser) async {
    return await _firebaseFirestore
        .collection('list_user')
        .doc(_uid)
        .set(infoUser.toJson());
  }

  Future updateGenderUser(String gender) async {
    return await _firebaseFirestore
        .collection('list_user')
        .doc(_uid)
        .update({'gender': gender});
  }

  Future updateBirthDayUser(DateTime date) async {
    return await _firebaseFirestore
        .collection('list_user')
        .doc(_uid)
        .update({'birthday': "${date.day}/${date.month}/${date.year}"});
  }

  Future updatePhoneNumberUser(List<String> phone) async {
    return await _firebaseFirestore
        .collection('list_user')
        .doc(_uid)
        .update({'phone': "(${phone[0]}) ${phone[1]}"});
  }

  Future<InfoUser?> getInfoUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('list_user').doc(_uid).get();
    final String data = jsonEncode(snapshot.data());
    return InfoUser.fromJson(json.decode(data));
  }

  Future<void> updateAvatarUser(XFile image) async {
    String downloadURL = await StorageRepository()
        .getDownloadURLImageUser(image.name, 'user', _uid!);
    return _firebaseFirestore
        .collection('list_user')
        .doc(_uid!)
        .update({'imageURL': downloadURL, 'imageName': image.name});
  }

  // Product Management Features

  Future updateAddIdProduct(int id) async {
    return await _firebaseFirestore.collection('list_user').doc(_uid).update({
      'favorite': FieldValue.arrayUnion([id])
    });
  }

  Future updateRemoveIdProduct(int id) async {
    return await _firebaseFirestore.collection('list_user').doc(_uid).update({
      'favorite': FieldValue.arrayRemove([id])
    });
  }

  Future updateViewProduct(int id) async {
    return await _firebaseFirestore
        .collection('list_product')
        .doc(id.toString())
        .update({'view': FieldValue.increment(1)});
  }

  Future<void> updateImageProduct(XFile image, int id, int index) async {
    String downloadURL =
        await StorageRepository().getDownloadURLProduct(image.name, id, index);
    return _firebaseFirestore
        .collection('list_product')
        .doc(id.toString())
        .update({
      'imageURL': FieldValue.arrayUnion([downloadURL]),
      'imageName': FieldValue.arrayUnion([image.name])
    });
  }

  Future<void> createNewProduct(List<XFile?> listXFilePicked,
      List<String> listIndexImageName, Product product, int currentID) async {
    await _firebaseFirestore
        .collection('list_product')
        .doc(currentID.toString())
        .set(product.toJson())
        .then((val) async {
      for (int i = 0; i < listXFilePicked.length; i++) {
        if (listXFilePicked[i] != null) {
          await StorageRepository().uploadFileImageProduct(
              listXFilePicked[i]!, currentID, i, listIndexImageName[i]);
        }
      }
    });
  }

  Future<List<Product>> getListProduct() async {
    QuerySnapshot snapshot =
        await _firebaseFirestore.collection('list_product').get();
    return snapshot.docs.map((doc) {
      final String data = jsonEncode(doc.data());
      return Product.fromJson(json.decode(data));
    }).toList();
  }

  Future<List<Product>> getProductWithFlashSale(
      {required int page, required int limit}) async {
    if (limit <= 0) return [];
    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for (var x in value) {
        if (x.promotionPercent() >= 50 && x.getSalePrice != 0) {
          listProduct.add(x);
        }
      }
    });
    return listProduct.skip((page - 1) * limit).take(limit).toList();
  }

  Future<List<Product>> getProductWithView(
      {required int page, required int limit}) async {
    if (limit < 0) return [];
    List<Product> listProduct = await getProductMaxView();
    return listProduct.skip((page - 1) * limit).take(limit).toList();
  }

  Future<List<Product>> getProductWithFavorite({required List<int> id}) async {
    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for (int i = 0; i < id.length; i++) {
        for (var x in value) {
          if (x.getId == id[i]) {
            listProduct.add(x);
          }
        }
      }
    });
    return listProduct;
  }

  Future<List<Product>> getPageProducts({required page, required limit}) async {
    if (limit <= 0) return [];
    await Future.delayed(const Duration(seconds: 2));
    final List<Product> listProduct = await DatabaseService().getListProduct();
    return listProduct.skip((page - 1) * limit).take(limit).toList();
  }

  Future<List<Product>> getProductWithChar(String char) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<Product> listProduct = [];
    await DatabaseService().getListProduct().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].getName.toLowerCase().contains(char.toLowerCase())) {
          listProduct.add(value[i]);
        }
      }
    });
    return listProduct;
  }

  Future<List<Product>> getProductMaxView() async {
    List<Product> listProduct = await DatabaseService().getListProduct();
    for (int i = 0; i < listProduct.length; i++) {
      for (int j = i + 1; j < listProduct.length; j++) {
        if (listProduct[i].getView < listProduct[j].getView) {
          Product temp = listProduct[i];
          listProduct[i] = listProduct[j];
          listProduct[j] = temp;
        }
      }
    }
    return listProduct;
  }

  Future<List<Product>> getProductWithCategory(
      {required int idCategory,
      required int itemsPage,
      required int limitPage}) async {
    List<Product> listProduct = [];
    await Future.delayed(const Duration(milliseconds: 500));
    await DatabaseService().getListProduct().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (idCategory == value[i].getIdCategory) {
          listProduct.add(value[i]);
        }
      }
    });
    return listProduct
        .skip((itemsPage - 1) * limitPage)
        .take(limitPage)
        .toList();
  }

  // Cart Management Features

  Future<void> updateCart(Cart cart) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart': FieldValue.arrayUnion([cart.toJson()])
      });
    });
  }

  Future<void> updateIndexCart(Cart cart, int index) async {
    cart.amount = cart.getAmount! + index;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart': FieldValue.arrayUnion([cart.toJson()])
      });
    });
  }

  Future removeCart(Cart cart) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      return await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart': FieldValue.arrayRemove([cart.toJson()])
      });
    });
  }

  Future removeIndexCart(Cart cart, int index) async {
    await Future.delayed(const Duration(milliseconds: 100));
    cart.amount = cart.getAmount! - index;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      return await _firebaseFirestore.collection('list_user').doc(_uid).update({
        'cart': FieldValue.arrayRemove([cart.toJson()])
      });
    });
  }

  Future removeAllCart() async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      return await _firebaseFirestore
          .collection('list_user')
          .doc(_uid)
          .update({'cart': []});
    });
  }

  Future<List<Cart>> getListCartFromUser(InfoUser snapshot) async {
    List<Cart> listCart = [];
    for (var element in snapshot.cart) {
      String data = json.encode(element);
      listCart.add(Cart.fromJson(jsonDecode(data)));
    }
    if (listCart != []) {
      for (int i = 0; i < listCart.length; i++) {
        for (int j = i + 1; j < listCart.length; j++) {
          if (listCart[i].getIdProduct! > listCart[j].getIdProduct! ||
              (listCart[i].getIdProduct == listCart[j].getIdProduct &&
                  (listCart[i].getSize!.compareTo(listCart[j].getSize!) == 1 ||
                      listCart[i].getColor!.compareTo(listCart[j].getColor!) ==
                          1))) {
            Cart temp = listCart[i];
            listCart[i] = listCart[j];
            listCart[j] = temp;
          }
        }
      }
    }
    return listCart;
  }

  // Category Management Features

  Future<List<Category>> getListCategory() async {
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection('list_category').get();
    return querySnapshot.docs.map((doc) {
      final String data = jsonEncode(doc.data());
      return Category.fromJson(json.decode(data));
    }).toList();
  }

  Future createNewCategory(Category category) async {
    await _firebaseFirestore
        .collection('list_category')
        .doc(category.id.toString())
        .set(category.toJson());
  }

  // Order Management Features

  Future<List<Cart>> getListCartFromOrder(Order snapshot) async {
    List<Cart> listCart = [];
    for (var element in snapshot.getOrderDetail) {
      String data = json.encode(element);
      listCart.add(Cart.fromJson(jsonDecode(data)));
    }
    return listCart;
  }

  Future<List<Order>> getListOrder() async {
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection('list_order').get();
    return querySnapshot.docs.map((doc) {
      final String data = jsonEncode(doc.data());
      return Order.fromJson(json.decode(data));
    }).toList();
  }

  Future createNewOrder(Order order) async {
    await _firebaseFirestore
        .collection('list_order')
        .doc(order.id.toString())
        .set(order.toJson());
  }
}
