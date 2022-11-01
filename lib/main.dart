import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/category_model.dart';
import 'package:strak_shop_project/models/info_user_model.dart';
import 'package:strak_shop_project/models/order_model.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/models/product_model.dart';
import 'package:strak_shop_project/services/auth.dart';
import 'package:strak_shop_project/views/home_view.dart';
import 'package:strak_shop_project/views/login_view.dart';
import 'package:strak_shop_project/views/router_view.dart';

import 'models/account.dart';

main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());

}

class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Account?>.value(initialData: null,value: AuthService().getStateAccount),
        ChangeNotifierProvider(create: (context) => ProductModel()),
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => InfoUserModel()),
        ChangeNotifierProvider(create: (context) => OrderModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(builder: (context,constraint){
           String? currentUID = Provider.of<Account?>(context)?.uid;
             return currentUID == null ? LoginPage(uid: currentUID,) : HomePage(uid: currentUID,);
        })
        ),
    );
  }

}


