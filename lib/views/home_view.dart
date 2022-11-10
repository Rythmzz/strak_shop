import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strak_shop_project/models/bloc_search.dart';
import 'package:strak_shop_project/models/category_model.dart';
import 'package:strak_shop_project/models/info_user.dart';
import 'package:strak_shop_project/models/order_model.dart';
import 'package:strak_shop_project/models/product_model.dart';
import 'package:strak_shop_project/services/auth.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/services/storage_repository.dart';
import 'package:strak_shop_project/views/category_view.dart';
import 'package:strak_shop_project/views/create_product_view.dart';
import 'package:strak_shop_project/views/notification_view.dart';
import 'package:strak_shop_project/views/product_category_view.dart';
import 'package:strak_shop_project/views/product_detail_view.dart';
import 'package:strak_shop_project/views/product_favorite_view.dart';
import 'package:strak_shop_project/views/product_flashsale_view.dart';
import 'package:strak_shop_project/views/product_top_search_view.dart';
import 'package:strak_shop_project/views/product_view.dart';
import 'package:strak_shop_project/views/search_product_view.dart';
import 'package:strak_shop_project/views/user_detail_view.dart';

import '../models/account.dart';
import '../models/cart.dart';
import '../models/info_user_model.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'cart_detail_view.dart';
import 'explore_detail_view.dart';
import 'home_detail_view.dart';
import 'order_detail_view.dart';

class HomePage extends StatefulWidget{
  String? uid;
  HomePage({required this.uid});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearch = true;
  String _labelPage = "";
  late List<Widget> _selectPage;
  bool _isExit = false;



  @override
  void initState() {
   _selectPage = [
     Consumer<CategoryModel>(builder: (context,snapshot,_){
       return Navigator(
         onGenerateRoute: (setting){
           Widget page = DetailHomePage();
           for(int i = 0 ; i < snapshot.getListCategory.length ; i++){
             if(setting.name == "category/${snapshot.getListCategory[i].getId}"){
               page = ProductCategoryView(idCategory: snapshot.getListCategory[i].getId, nameCategory: snapshot.getListCategory[i].getName);
               break;
             }
           };
           return MaterialPageRoute(builder: (context) => page);
         },
       );
     }),
     DetailExplorePage(),
     DetailCartPage(),
     DetailUserPage(),
   ];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return WillPopScope(
        onWillPop: () async{
          if(_isExit == false){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Press again to exit the screen")));
            _isExit = true;
            return false;
          }
          else {
            return true;}
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: _isSearch ? AppBar(
            backgroundColor: Colors.white,
            title: SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchProductView()));
                    _isExit = false;
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Search Product",
                      prefixIcon: Icon(Icons.search,color: Theme.of(context).primaryColor,size: 24,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: StrakColor.colorTheme6,width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: StrakColor.colorTheme6,width: 3)
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 14
                    ),
                  ),
                )
            ) ,
            toolbarHeight: 80,
            actions: [
              IconButton(icon: Badge(
                child: Icon(Icons.favorite_border_outlined),
                showBadge: snapshot.getListInfoUser?.favorite.length == 0 ? false : true,
              ),color: Colors.grey,onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductFavoriteView(listID: snapshot.getListInfoUser?.favorite == null ? [] :  snapshot.getListInfoUser!.favorite ,)));
                _isExit = false;
              },),
              IconButton(icon: Badge(
                child: Icon(Icons.notifications_none_outlined),
              ),color: Colors.grey,onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPageView()));
                _isExit = false;
              },),
            ],

          ) : AppBar(
            backgroundColor: Colors.white,
            actions: [
             Container(
               width: 50,
               height: 50,
               decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: StrakColor.colorTheme6,width: 2)),image: DecorationImage(image: AssetImage("assets/images_app/logo_strak_red.png"),fit: BoxFit.fitWidth)),
             ),
              SizedBox(width: 30,)
            ],
            title: Container(
              alignment: Alignment.centerLeft,
              height: 50,
              child: Text("$_labelPage",style: TextStyle(
                  color: StrakColor.colorTheme7,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
            ),
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: Visibility(
            visible:  snapshot.getListInfoUser?.uid ==  "vepLb8PezZPJfAMbVpDNkePTOef1" ? true : false,
            child: FloatingActionButton(backgroundColor: StrakColor.colorTheme6,onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (contextr) => CreateNewProducts()));
              _isExit = false;
            },child: Icon(Icons.add_business_outlined,size: 30,color: Colors.blueAccent,)),
          ),
          body: SafeArea(
            child:_selectPage.elementAt(snapshot.getSelectIndex) ,
          ),
          bottomNavigationBar: BottomNavigationBar(type:BottomNavigationBarType.fixed,items:<BottomNavigationBarItem> [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 24),label: "Home",),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined,size: 24),label: "Explore"),
            BottomNavigationBarItem(icon: Badge(badgeContent: Text("${snapshot.getListCart.length}",style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),),child: Icon(Icons.shopping_cart_outlined),showBadge: snapshot.getListCart.length == 0 ? false : true,),label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined,size: 24),label: "Account")
          ],currentIndex: snapshot.getSelectIndex,selectedItemColor: Theme.of(context).primaryColor,onTap:(val) => handleClickMenu(val,snapshot) ,),
        ),
      );
    });
  }
  void handleClickMenu(int val, InfoUserModel snapshot){
    snapshot.setSelectIndex = val;
    setState(() {
      if(val == 2 || val == 3){
        setState(() {
          _isSearch = false;
          if(val == 2){_labelPage = "Your Cart";}
          else {_labelPage = "Your Account";}
        });
      }
      else {
        setState(() {
          _isSearch = true;
        });
      }
    });
  }

}

class SliderLabel extends StatefulWidget{
  @override
  State<SliderLabel> createState() => _SliderLabelState();
}

class _SliderLabelState extends State<SliderLabel> {
  DateTime now = DateTime.now();
  late Duration _countDownDuration;
  Duration _duration = Duration();
  Timer? timer;
  bool _isCountDown = false;


  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) => addTime());
  }

  void addTime() {
    final addSeconds = _isCountDown ? -1 : 1;
    setState(() {
      final seconds = _duration.inSeconds + addSeconds;
      if(seconds < 0 ){
        timer?.cancel();
      }
      else {
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() {
    setState(() {
      _duration = _countDownDuration;
    });

  }

  @override
  void initState() {
    _countDownDuration = Duration(hours: now.hour,minutes: now.minute,seconds: now.second);
    super.initState();
    startTimer();
    reset();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildTimeCard({required String time}){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    String twoDits(int n) =>  n.toString().padLeft(2,'0');
    String hours = twoDits(_duration.inHours).toString();
    String minutes = twoDits(_duration.inMinutes.remainder(60)).toString();
    String seconds = twoDits(_duration.inSeconds.remainder(60)).toString();

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Super Flash Sale 50% Off",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
                Row(
                  children: [
                    buildTimeCard(time: hours),
                    Padding(padding: EdgeInsets.all(8),child: Text(":",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white
                    ),),),
                    buildTimeCard(time: minutes),
                    Padding(padding: EdgeInsets.all(8),child: Text(":",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white
                    ),),),
                    buildTimeCard(time: seconds)
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(child: SizedBox())
      ],
    );
  }
}













