
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
  bool _canCreateProc = false;
  late List<Widget> _selectPage;


  @override
  void initState() {
   _selectPage = [
     DetailHomePage(),
     DetailExplorePage(),
     DetailCartPage(),
     DetailUserPage(),
   ];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: _isSearch ? AppBar(
          backgroundColor: Colors.white,
          title: SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchProductView()));
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
              showBadge: snapshot.getListInfoUser?.favorite.length == null ? false : true,
            ),color: Colors.grey,onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductFavoriteView(listID: snapshot.getListInfoUser?.favorite == null ? [] :  snapshot.getListInfoUser!.favorite ,)));
            },),
            IconButton(icon: Badge(
              child: Icon(Icons.notifications_none_outlined),
            ),color: Colors.grey,onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPageView()));
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
      );
    });
  }
  void handleClickMenu(int val, InfoUserModel snapshot){
    snapshot.setSelectIndex = val;
    setState(() {
      if(val == 2 || val == 3){
        setState(() {
          _isSearch = false;
          if(val == 2){
            _labelPage = "Your Cart";
          }
          else {
            _labelPage = "Your Account";
          }
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
class DetailCartPage extends StatefulWidget{



  @override
  State<DetailCartPage> createState() => _DetailCartPageState();
}

class _DetailCartPageState extends State<DetailCartPage> {
  Order _order = Order(0,"","","","",0.0,"",[]);



  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Consumer<OrderModel>(builder:(context,snapshotOr,_){
        return snapshot.getListCart.isNotEmpty ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16), child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.getListCart.length,
                    itemBuilder: (context,i) => ProductCartView(currentCart: snapshot.getListCart[i],currentUser: snapshot,isOrder: false),
                    separatorBuilder: (context,i) => SizedBox(height: 10,),
                  ),),SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                    child: Card(elevation: 8,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text("Items (${snapshot.getListCart.length})",style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12
                              ),),
                              Text("\$${snapshot.totalPrice().toStringAsFixed(2)}",style: TextStyle(
                                  fontSize: 12
                              ),)

                            ],),
                            SizedBox(height: 15,),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text("Shipping",style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12
                              ),),
                              Text("\$0",style: TextStyle(
                                  fontSize: 12
                              ),)

                            ],),
                            SizedBox(height: 15,),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text("Import Charges",style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12
                              ),),
                              Text("\$0",style: TextStyle(
                                  fontSize: 12
                              ),)

                            ],),
                            SizedBox(height: 15,),
                            Divider(height: 10,color: StrakColor.colorTheme7,),
                            SizedBox(height: 5,),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text("Total Price",style: TextStyle(
                                  color: StrakColor.colorTheme7,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                              Row(
                                children: [
                                  Text("\$${snapshot.totalPrice().toStringAsFixed(2)}",style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 15,),
                                  Container(
                                    height: 20,
                                    child: ElevatedButton(style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(StrakColor.colorTheme7)
                                    ),onPressed: () {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          title: Text("Order Confirmation"),
                                          content: Container(
                                            width: 250,
                                            height: 250,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextField(onChanged: (val){
                                                    _order.address = val;
                                                  },
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width:3)
                                                      ),
                                                      hintText: "Enter Your Address",
                                                    ),style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  SizedBox(height: 12,)
                                                  ,
                                                  TextField(
                                                    onChanged: (val) {
                                                      _order.orderNote = val;
                                                    },
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(width:3),
                                                      ),
                                                      hintText: "Note",
                                                    ),
                                                    style: TextStyle(fontSize: 12),
                                                    keyboardType: TextInputType.multiline,
                                                    minLines: 5,
                                                    maxLines: 5,
                                                    maxLength: 100,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(onPressed: () {
                                                        Navigator.of(context).pop();
                                                      }, child: Text("Cancel")),
                                                      SizedBox(width: 15,),
                                                      ElevatedButton(onPressed: () async {
                                                        if(snapshotOr.getListOrder != []){
                                                          _order.id = snapshotOr.getListOrder.last.getId + 1;
                                                        }
                                                        _order.uid = snapshot.getListInfoUser!.uid;
                                                        _order.orderCode = "#TM${_order.getId}";
                                                        _order.orderDate = DateFormat.yMEd().add_jms().format(DateTime.now());
                                                        _order.totalPrice = double.tryParse(snapshot.totalPrice().toStringAsFixed(2))!;
                                                        snapshot.getListCart.forEach((element) {
                                                          String data = json.encode(element);
                                                          _order.addObject(jsonDecode(data));
                                                        });
                                                        await DatabaseService(_order.getUid).createNewOrder(_order.getId, _order.getOrderDate, _order.getOrderCode, _order.getOrderNote, _order.getTotalPrice, _order.getAddress, _order.getOrderDetail);
                                                        await DatabaseService(_order.getUid).removeAllCart();
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Buy Success")));
                                                        Navigator.of(context).pop();
                                                      }, child: Text("Confirm"))
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                      },);





                                    }, child: Text("Buy Now")),
                                  )
                                ],
                              )

                            ],)
                          ],
                        ),
                      ),
                    ),
                  ),

                ])) : Center(
                  child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: ShapeDecoration(shape:CircleBorder(),color: Colors.blue),
              child: Icon(Icons.clear,color: Colors.white,size: 30) ,
            ),
            SizedBox(height: 15,),
            Text("Cart is empty",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: StrakColor.colorTheme7
            ),),
            SizedBox(height: 15,),
            ElevatedButton(style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(StrakColor.colorTheme7)
            ),onPressed: (){
                snapshot.setSelectIndex = 0;

            }, child: Text("Back To Shopping",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white
            ),))

          ],
        ),
                );
      });
    });
  }


}



class DetailExplorePage extends StatelessWidget{

  Widget CircleCategory(String image , String textCategory ){
    return Container(
      width: 60,
      height:100,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: StrakColor.colorTheme6,
            backgroundImage: CachedNetworkImageProvider(image),
            foregroundColor: StrakColor.colorTheme6,
            maxRadius: 28.0,
          ),
          SizedBox(height: 5,),
          FittedBox(child: Text(textCategory,style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          )),fit: BoxFit.fitWidth)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(builder: (context,snapshot,_){
      return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Man Fashion",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),),
          ),
             Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  for(var x in snapshot.getListCategory)
                    if(x.getGenderStyle == "male") InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductCategoryView(idCategory: x.getId, nameCategory: x.getName)));
                    },child: CircleCategory(x.getImageURL, x.getName))
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Woman Fashion",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for(var x in snapshot.getListCategory)
                  if(x.getGenderStyle == "female") InkWell(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductCategoryView(idCategory: x.getId, nameCategory: x.getName)));
                  },child: CircleCategory(x.getImageURL, x.getName))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Other",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for(var x in snapshot.getListCategory)
                  if(x.getGenderStyle == "both") InkWell(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductCategoryView(idCategory: x.getId, nameCategory: x.getName)));
                  },child: CircleCategory(x.getImageURL, x.getName))
              ],
            ),
          )

        ],
      )
    );});
  }
  
}
class DetailHomePage extends StatefulWidget{
  @override
  State<DetailHomePage> createState() => _DetailHomePageState();
}

class _DetailHomePageState extends State<DetailHomePage> {
  int _indexActive = 0;

  static const int _endReachedThreshold = 200;


  static const int _itemPageFlashSale = 3;
  int _nextPageFlashSale = 1;
  bool _loadingMoreFlashSale = true;
  bool _loadingFlashSale = true;
  List<Product> _currentListProductFlashSale = [];
  final ScrollController _scrollControllerFlashSale = ScrollController();

  static const int _itemPageTopView = 3;
  int _nextPageTopView = 1;
  bool _loadingMoreTopView = true;
  bool _loadingTopView = true;
  List<Product> _currentListProductTopView = [];
  final ScrollController _scrollControllerTopView = ScrollController();


  static const int _itemsPerPage = 4;
  final ScrollController _scrollController = ScrollController();
  List<Product> _currentListProduct = [];
  int _nextPage = 1;
  bool _loading = true;
  bool _canLoadMore = true;



  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(delegate: SliverChildListDelegate([
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildImageTransition(),
                _buildIndicator(),
                _buildListCategory(),
                _buildListFlashSale(),
                _buildListTopView(),
                _buildImageRecommendProduct(),])])),

        _buildGridLoadDataProduct(),
        _buildLoading(),
      ],
    );
  }

  @override
  void initState() {
    _scrollControllerFlashSale.addListener(() {
      if(!_scrollControllerFlashSale.hasClients || _loadingFlashSale) return;

      final thresholdReached = _scrollControllerFlashSale.position.extentAfter < _endReachedThreshold;

      if(thresholdReached){
        getProductFlashSale();
      }
    });
    getProductFlashSale();

    _scrollControllerTopView.addListener(() {
      if(!_scrollControllerTopView.hasClients || _loadingTopView) return;


      final threholdReached = _scrollControllerTopView.position.extentAfter < _endReachedThreshold;

      if(threholdReached){
        getProductTopView();
      }
    });
    getProductTopView();


    _scrollController.addListener(() {
      if(!_scrollController.hasClients || _loading ) return;

      final thresholdReached = _scrollController.position.extentAfter < _endReachedThreshold;

      if(thresholdReached){
        _getProducts();
      }
    });
    _getProducts();
    super.initState();
  }
  @override
  void dispose() {
   _scrollController.dispose();
   _scrollControllerFlashSale.dispose();
   _scrollControllerTopView.dispose();
    super.dispose();
  }
  Future<void> getProductTopView() async  {
    _loadingTopView = true;

    final listProduct = await DatabaseService().getProductWithView(page: _nextPageTopView, limit: _itemPageTopView);

    if (!mounted) return;

    setState(() {
      _currentListProductTopView.addAll(listProduct);
      _nextPageTopView++;

      if(listProduct.length < _itemPageTopView){
        _loadingMoreTopView = false;
      }
      _loadingTopView= false;
    });
  }


  Future<void> getProductFlashSale() async {
    _loadingFlashSale = true;
    final listProduct = await DatabaseService().getProductWithFlashSale(page: _nextPageFlashSale, limit: _itemPageFlashSale);

    if(!mounted) return;

    setState(() {

      _currentListProductFlashSale.addAll(listProduct);
      _nextPageFlashSale++;

      if(listProduct.length < _itemPageFlashSale){
        _loadingMoreFlashSale = false;
      }
      _loadingFlashSale = false;
    });

  }




  Future<void> _getProducts() async {



    _loading = true;
    final newProducts = await  DatabaseService().getPageProducts(page : _nextPage, limit: _itemsPerPage);

    if(!mounted) return;
    setState(() {

      _currentListProduct.addAll(newProducts);

      _nextPage++;

      if(newProducts.length < _itemsPerPage){
        _canLoadMore = false;
      }

      _loading = false;

    });



  }

  Widget _buildItemProduct(BuildContext context,int index){
    return InkWell(
      onTap: () {
        DatabaseService().updateViewProduct(_currentListProduct[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailView(currentProduct: _currentListProduct[index])));
      },
      child: ProductView(currentProduct: _currentListProduct[index],
          isFavoriteView: false,),
    );
  }

  Widget CircleCategory(String image , String textCategory ){
    return Container(
      width: 60,
      height:60,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(image),
            foregroundColor: StrakColor.colorTheme6,
          ),
          SizedBox(height: 5,),
          FittedBox(child: Text(textCategory,style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          )),fit: BoxFit.fitWidth)
        ],
      ),
    );
  }

  Widget _buildImageTransition() {
    return CarouselSlider(items:[1,2,3,4,5,6,7].map((i) {
      return Builder(builder: (BuildContext context){
        return Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: i != 1 ? Image.asset("assets/images_wallpaper/slider_image$i.png",fit: BoxFit.fill,):
            Stack(
              children: [
                InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductFlashSaleView(sliderTime: SliderLabel()))),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/images_wallpaper/slider_image$i.png"),fit: BoxFit.fill,opacity: 0.85)
                    ),
                  ),
                ),
                SliderLabel(),
                SizedBox(height: 8,),
              ],
            ),
          ),
        );
      });
    }).toList() , options: CarouselOptions( height: 206,
        viewportFraction: 1,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index,reason) {
          setState(() {
            _indexActive = index;
          });
        }));
  }



  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(activeIndex: _indexActive, count:7,effect: JumpingDotEffect(
        dotWidth: 6,
        dotHeight: 6,
        dotColor: StrakColor.colorTheme6,activeDotColor: Theme.of(context).primaryColor
    ));
  }



  Widget _buildListCategory(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Category",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),),
              InkWell(child: Text("More Category",style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              )),onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryView()));
              },)
            ],
          ),
        ),
        Consumer<CategoryModel>(builder: (context,snapshot,_){
          return Container(
            height: 120,
            child: ListView.builder(itemBuilder: (context,index){
              return InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductCategoryView(idCategory: snapshot.getListCategory[index].getId, nameCategory: snapshot.getListCategory[index].getName)));
              },child: index <= 10 ? CircleCategory(snapshot.getListCategory[index].getImageURL, snapshot.getListCategory[index].getName) : SizedBox());
            },itemCount: snapshot.getListCategory.length,padding: EdgeInsets.all(16),scrollDirection: Axis.horizontal),
          );
        })
      ],
    );
  }
  Widget _buildProductItemFlashSale(BuildContext context, int index){
    return InkWell(
      onTap: () async {
        await DatabaseService().updateViewProduct(_currentListProductFlashSale[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: _currentListProductFlashSale[index])));
      },
      child: ProductView(currentProduct: _currentListProductFlashSale[index],
        isFavoriteView: false,),
    );
  }

  Widget _buildListFlashSale(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Flash Sale",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),),
              InkWell(child: Text("See More",style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              )),onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductFlashSaleView(sliderTime: _buildImageTransition())));

              },)
            ],
          ),
        ),
        Container(
            height: 250,
            padding: EdgeInsets.all(14),
            child: Container(
              child: ListView(
                controller: _scrollControllerFlashSale,
                scrollDirection: Axis.horizontal,
                children: [
                  ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,scrollDirection: Axis.horizontal,itemBuilder: (context,index) =>index <= 10 ? _buildProductItemFlashSale(context,index) : SizedBox(),
                      separatorBuilder: (context, index) => SizedBox(width: 15), itemCount: _currentListProductFlashSale.length),
                  _loadingMoreFlashSale ? Container(
                    padding: EdgeInsets.only(left: 16),
                    alignment: Alignment.center,
                    child: SpinKitChasingDots(
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ) : SizedBox()
                ],
              ),
            )
        )
      ],
    );
  }

  Widget _buildProductItemTopView(BuildContext context, int index){
    return InkWell(
      onTap: (){
        DatabaseService().updateViewProduct(_currentListProductTopView[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: _currentListProductTopView[index])));
      },
      child: ProductView(currentProduct: _currentListProductTopView[index],
        isFavoriteView: false,),
    );
  }

  Widget _buildListTopView(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Top Search",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),),
              InkWell(child: Text("See More",style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              )),onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductTopSearchView()));

              },)
            ],
          ),
        ),
        Container(
            height: 250,
            padding: EdgeInsets.all(14),
            child: Container(
              child: ListView(
                controller: _scrollControllerTopView,
                scrollDirection: Axis.horizontal,
                children: [
                  ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,scrollDirection: Axis.horizontal,itemBuilder: (context,index) => index <= 10 ? _buildProductItemTopView(context,index) : SizedBox(), separatorBuilder: (context, index) => SizedBox(width: 15), itemCount: _currentListProductTopView.length),
                  _loadingMoreTopView ? Container(
                    padding: EdgeInsets.only(left: 16),
                    alignment: Alignment.center,
                    child: SpinKitChasingDots(
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ) : SizedBox()
                ],
              ),
            )
        )
      ],
    );
  }

  Widget _buildImageRecommendProduct(){
    return Container(
      height: 206,
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images_wallpaper/slider_image8.png"),fit: BoxFit.fill,opacity: 0.85)
            ),
          ),
          Row(
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recommend Product",style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),),
                      Text("We recommend the best for you",style: TextStyle(
                          fontSize: 14,
                          color: Colors.white
                      ),),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox())
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGridLoadDataProduct(){
    return SliverPadding(padding: EdgeInsets.all(16),sliver:
    SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 165/258,crossAxisSpacing: 16,mainAxisSpacing: 16),
    delegate: SliverChildBuilderDelegate(_buildItemProduct,childCount: _currentListProduct.length),
    ));
  }

  Widget _buildLoading(){
    return SliverToBoxAdapter(
        child: _canLoadMore ? Container(
          padding: EdgeInsets.only(bottom: 16),
          alignment: Alignment.center,
          child: SpinKitChasingDots(
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ) : SizedBox()
    );
  }


}

class DetailUserPage extends StatelessWidget{
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailView()));
            },
            child: ListTile(
              title: Text("Profile",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.account_circle,color: Colors.lightBlueAccent,),
            ),
          ),
          Divider(height: 3,color: StrakColor.colorTheme6),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderView(currentUserUid: snapshot.getListInfoUser!.uid,)));
            },
            child: ListTile(
              title: Text("Order",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.sticky_note_2_outlined,color: Colors.lightBlueAccent,),
            ),
          ),
          Divider(height: 3,color: StrakColor.colorTheme6),
          InkWell(
            onTap: (){
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text("Log out"),
                content: Container(
                  width: 100,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Are you sure you want to log out?"),
                      SizedBox(height: 10,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         ElevatedButton(onPressed: (){
                           Navigator.of(context).dispose();
                         }, child: Text("Cancel")),
                         ElevatedButton(onPressed: (){
                            Navigator.of(context).pop();
                            _authService.signOut();
                         }, child: Text("OK"))
                       ],
                     )
                    ],
                  ),
                ),

              ));
            },
            child: ListTile(
              title: Text("Sign Out",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              leading: Icon(Icons.exit_to_app,color: Colors.lightBlueAccent,),
            ),
          ),


        ],
      );
    });
  }

}



class SelectPage extends StatelessWidget{
  final String select;
  SelectPage({required this.select});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("$select"));
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
  void initState() {
   _countDownDuration = Duration(hours: now.hour,minutes: now.minute,seconds: now.second);
    super.initState();
    startTimer();
    reset();
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
}

















//   class CurrentUser extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     final currentUser = Provider.of<InfoUser?>(context);
//     currentUser!.printUser();
//     return Center(
//       child: Text("Hoppy"),
//     );
//   }
//
//   }
//
// class ListUser  extends StatefulWidget{
//   @override
//   State<ListUser> createState() => _ListUserState();
// }
//
// class _ListUserState extends State<ListUser> {
//
//   @override
//   Widget build(BuildContext context) {
// print("Rebuild 1");
//     final listUser = Provider.of<List<InfoUser>>(context);
//    if(listUser != null){
//      listUser.forEach((element) {
//        element.printUser();
//      });
//    }
//     return Text("Hello");
//   }
// }