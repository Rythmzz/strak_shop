import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage_firebase;
import 'package:image_picker/image_picker.dart';
import 'package:strak_shop_project/models/model/category.dart';
import 'package:strak_shop_project/services/service/database.dart';

class StorageRepository {
  final storage_firebase.FirebaseStorage _storage =
      storage_firebase.FirebaseStorage.instance;

  // User Photo Storage

  Future<void> uploadFileImageAvatar(
      XFile image, String path, String uid, String imageNameOld) async {
    if (imageNameOld != "") {
      await _storage.ref('$path/${path}_$uid/').child(imageNameOld).delete();
    }
    try {
      await _storage
          .ref('$path/${path}_$uid/${image.name}')
          .putFile(File(image.path))
          .then((p0) => DatabaseService(uid).updateAvatarUser(image));
    } catch (e) {
      return;
    }
  }

  Future<String> getDownloadURLImageUser(
      String imageName, String path, String uid) async {
    String downloadURL =
        await _storage.ref('$path/${path}_$uid/$imageName').getDownloadURL();
    return downloadURL;
  }

  // Product Photo Storage

  Future<void> uploadFileImageProduct(
      XFile image, int id, int index, String imageNameOld) async {
    try {
      await _storage
          .ref('product/product_$id/$index/${image.name}')
          .putFile(File(image.path))
          .then((p0) {
        DatabaseService().updateImageProduct(image, id, index);
      });
    } catch (e) {
      return;
    }
  }

  Future<String> getDownloadURLProduct(
      String currentImageName, int id, int index) async {
    String downloadURL = await _storage
        .ref('product/product_$id/$index/$currentImageName')
        .getDownloadURL();
    return downloadURL;
  }

  Future<void> deleteImageURLProduct(
      String currentImageName, String path, int id, int index) async {
    _storage.ref('$path/${path}_$id/$index/').child(currentImageName).delete();
  }

  // Category Photo Storage

  Future<void> uploadFileImageCategory(XFile image, Category category) async {
    if (category.imageName != "") {
      await _storage
          .ref('category/category_${category.id}/')
          .child(category.imageName)
          .delete();
    }
    try {
      await _storage
          .ref('category/category_${category.id}/${image.name}')
          .putFile(File(image.path))
          .then((p0) async {
        return DatabaseService().createNewCategory(category);
      });
    } catch (e) {
      return;
    }
  }
}
