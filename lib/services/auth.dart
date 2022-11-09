import 'package:firebase_auth/firebase_auth.dart';
import 'package:strak_shop_project/services/database.dart';

import '../models/account.dart';
import '../models/info_user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;


  Stream<Account?> get getStateAccount{
     return  _auth.authStateChanges().map((User? user) => convertAccount(user));
  }


  Account? convertAccount(User? user){
    return user?.uid != null ? Account(uid: user?.uid) : null;

  }
  Future loginAccount(String email, String password) async{
    try{
      final UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      return convertAccount(user);
    }
    catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future registerAccount(String fullName,String email,String password) async{
    try{
      final UserCredential result = await _auth.createUserWithEmailAndPassword(email: email , password: password);
      final User? user = result.user;
      InfoUser infoUser = InfoUser(user!.uid, fullName, "male", "01/01/2022","","", email, "0", [], []);
      DatabaseService(user!.uid).updateInfoUser(infoUser);
      return convertAccount(user);
    }
    catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future loginWithAsynonmous() async{
    try{
     final UserCredential result = await _auth.signInAnonymously();
     final User? user = result.user;
     return convertAccount(user!);
    }
    catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

}