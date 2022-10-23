import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage_firebase;
import 'package:image_picker/image_picker.dart';
import 'package:strak_shop_project/services/database.dart';


class StorageRepository{
  final storage_firebase.FirebaseStorage _storage = storage_firebase.FirebaseStorage.instance;
  @override
  Future<void> uploadFileImageAvatar(XFile image, String path,String uid,String imageNameOld) async {
    if(imageNameOld != ""){
      await _storage.ref('$path/${path}_$uid/').child(imageNameOld).delete();
    }
    try{
      print(image.name);
      await  _storage.ref('$path/${path}_$uid/${image.name}').putFile(File(image.path)).then((p0) =>
      DatabaseService(uid).updateAvatarUser(image));
    }
    catch(e){
      print("Error ${e.toString()}");
    }
  }
  Future<String> getDownloadURL(String imageName, String path, String uid) async {
   String downloadURL = await _storage.ref('$path/${path}_$uid/$imageName').getDownloadURL();
    return downloadURL;
  }


  // Future<void> uploadFileImageProduct(XFile image, String path,int id, String imageNameOld, int index) async{
  //   if (imageNameOld != ""){
  //     await _storage.ref('$path/${path}_${id}/$index/').child(imageNameOld).delete();
  //   }
  //   try {
  //     print(image.name);
  //     await _storage.ref('$path/${path}_${id}/$index/${image.name}').putFile(File(image.path));
  //   }
  //   catch(e){
  //     print("Error ${e.toString()}");
  //   }
  // }

  Future<void> uploadFileImageProduct(XFile image, int id, int index, String imageNameOld) async{
    // if(imageNameOld != ""){
    //   await _storage.ref('product/product_$id/$index/').child(imageNameOld).delete();
    // }
    try{
      await _storage.ref('product/product_$id/$index/${image.name}').putFile(File(image.path)).then((p0) {
        DatabaseService().updateImageProduct(image, id, index);
      });
    }
    catch(e){
      print("Error :${e.toString()}");
    }
  }



  Future<String> getDownloadURLProduct(String currentImageName, int id, int index) async{
    String downloadURL  = await _storage.ref('product/product_${id}/$index/$currentImageName').getDownloadURL();
    return downloadURL;
  }

  Future<void> deleteImageURLProduct(String currentImageName,String path, int id, int index) async{
    _storage.ref('$path/${path}_${id}/$index/').child(currentImageName).delete();
  }




  Future<void> uploadFileImageCategory(XFile image, int id, String name, String imageNameOld) async{
    if (imageNameOld != ""){
      await _storage.ref('category/category_$id/').child(imageNameOld).delete();
    }
    try{
      await _storage.ref('category/category_$id/${image.name}').putFile(File(image.path)).then((p0) async {
        String downloadURL = await _storage.ref('category/category_$id/${image.name}').getDownloadURL();
        return DatabaseService().createNewCategory(id, name, downloadURL, image.name);
      });
    }
    catch(e){
      print("Error :${e.toString()}");
    }
  }






}