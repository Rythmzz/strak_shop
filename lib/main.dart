// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Account?>.value(
            initialData: null, value: AuthService().getStateAccount),
        ChangeNotifierProvider(create: (context) => ProductModel()),
        ChangeNotifierProvider(create: (context) => CategoryModel()),
        ChangeNotifierProvider(create: (context) => InfoUserModel()),
        ChangeNotifierProvider(create: (context) => OrderModel()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LayoutBuilder(builder: (context, constraint) {
            String? currentUID = Provider.of<Account?>(context)?.uid;
            return currentUID == null
                ? LoginPage(
                    uid: currentUID,
                  )
                : HomePage(
                    uid: currentUID,
                  );
          })),
    );
  }
}
