
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strak_shop_project/models/bloc_search.dart';
import 'package:strak_shop_project/models/category_model.dart';
import 'package:strak_shop_project/models/info_user.dart';
import 'package:strak_shop_project/models/product_model.dart';
import 'package:strak_shop_project/services/auth.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/services/storage_repository.dart';
import 'package:strak_shop_project/views/create_product_view.dart';
import 'package:strak_shop_project/views/notification_view.dart';
import 'package:strak_shop_project/views/product_detail_view.dart';
import 'package:strak_shop_project/views/product_favorite_view.dart';
import 'package:strak_shop_project/views/product_flashsale_view.dart';
import 'package:strak_shop_project/views/product_view.dart';
import 'package:strak_shop_project/views/search_product_view.dart';

import '../models/account.dart';
import '../models/cart.dart';
import '../models/info_user_model.dart';
import '../models/product.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _auth = AuthService();
  int _selectIndex = 0;
  bool _isCart = false;
  bool _canCreateProc = false;



  @override
  Widget build(BuildContext context) {
    final _account = Provider.of<Account?>(context);
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _isCart ? AppBar(
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text("Your Cart",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),),
          ),
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
        ): AppBar(
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
            IconButton(icon: Icon(Icons.favorite_border_outlined),color: Colors.grey,onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductFavoriteView(listID: snapshot.getListInfoUser?.favorite == null ? [] :  snapshot.getListInfoUser!.favorite ,)));
            },),
            IconButton(icon: Icon(Icons.notifications_none_outlined),color: Colors.grey,onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPageView()));
            },),
          ],

        ),
        floatingActionButton: Visibility(
          visible: _canCreateProc ? true : false,
          child: FloatingActionButton(backgroundColor: StrakColor.colorTheme6,onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (contextr) => CreateNewProducts()));
          },child: Icon(Icons.add_business_outlined,size: 30,color: Colors.blueAccent,)),
        ),
        body: SafeArea(
          child:_selectPage.elementAt(_selectIndex) ,
        ),
        bottomNavigationBar: BottomNavigationBar(type:BottomNavigationBarType.fixed,items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 24),label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined,size: 24),label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined,size: 24),label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined,size: 24),label: "Offer"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined,size: 24),label: "Account")
        ],currentIndex: _selectIndex,selectedItemColor: Theme.of(context).primaryColor,onTap:handleClickMenu ,),
      );
    });
  }
  void handleClickMenu(int val){
    setState(() {
      if(val == 2){

        setState(() {
          _isCart = true;
        });
      }
      else {
        setState(() {
          _isCart = false;
        });
      }
      _selectIndex = val;
    });
  }

  List<Widget> _selectPage = [
    DetailHomePage(),
    DetailExplorePage(),
    DetailCartPage(),
    SelectPage(select: "Offer" ),
    DetailUserPage(),
  ];

}

class DetailCartPage extends StatefulWidget{
  @override
  State<DetailCartPage> createState() => _DetailCartPageState();
}

class _DetailCartPageState extends State<DetailCartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 325,
                  child: Padding(
                    padding: EdgeInsets.all(16), child: ListView.separated(
                    itemCount: snapshot.getListCart.length,
                    itemBuilder: (context,i) => ProductCartView(currentCart: snapshot.getListCart[i],currentUser: snapshot,),
                    separatorBuilder: (context,i) => SizedBox(height: 10,),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                  child: Card(elevation: 8,
                    child: Padding(
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
                                  ),onPressed: (){

                                  }, child: Text("Buy Now")),
                                )
                              ],
                            )

                          ],)
                        ],
                      ),
                    ),
                  ),
                )
              ]));
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
            backgroundImage: NetworkImage(image),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Category",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),),
          ),
          Consumer<CategoryModel>(builder: (context,snapshot,_){
            return Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for(var x in snapshot.getListCategory)
                  CircleCategory(x.getImageURL, x.getName)
                ],
              ),
            );
          })
        ],
      )
    );
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

  static const int _itemPageMegaSale = 3;
  int _nextPageMegaSale = 1;
  bool _loadingMoreMegaSale = true;
  bool _loadingMegaSale = true;
  List<Product> _currentListProductMegaSale = [];
  final ScrollController _scrollControllerMegaSale = ScrollController();


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
                _buildListMegaSale(),
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

    _scrollControllerMegaSale.addListener(() {
      if(!_scrollControllerMegaSale.hasClients || _loadingMegaSale) return;


      final threholdReached = _scrollControllerMegaSale.position.extentAfter < _endReachedThreshold;

      if(threholdReached){
        getProductMegaSale();
      }
    });
    getProductMegaSale();


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
   _scrollControllerMegaSale.dispose();
    super.dispose();
  }
  Future<void> getProductMegaSale() async  {
    _loadingMegaSale = true;

    final listProduct = await DatabaseService().getProductWith50Percent(page: _nextPageFlashSale, limit: _itemPageMegaSale);

    if (!mounted) return;

    setState(() {
      _currentListProductMegaSale.addAll(listProduct);
      _nextPageMegaSale++;

      if(listProduct.length < _itemPageMegaSale){
        _loadingMoreMegaSale = false;
      }
      _loadingMegaSale = false;
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
    final newProducts = await  getPageProducts(page : _nextPage, limit: _itemsPerPage);

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

  Future<List<Product>> getPageProducts({required page, required limit})  async {
    if(limit <= 0) return [];

    await Future.delayed(Duration(seconds: 2));

    final List<Product> listProduct = await DatabaseService().getListProduct();

    return listProduct.skip((page - 1) * limit).take(limit).toList();

  }
  Widget _buildProductItem(BuildContext context,int index){
    return InkWell(
      onTap: () {
        DatabaseService().updateViewProduct(_currentListProduct[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailView(currentProduct: _currentListProduct[index])));
      },
      child: ProductView(id: _currentListProduct[index].getId!,image: _currentListProduct[index].getImageURL![0],
          name: _currentListProduct[index].getName!,
          price: _currentListProduct[index].getPrice!,
          salePrice: _currentListProduct[index].getSalePrice!,
          promotion:  _currentListProduct[index].promotionPercent(),
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
            backgroundImage: NetworkImage(image),
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
              )),onTap: (){},)
            ],
          ),
        ),
        Consumer<CategoryModel>(builder: (context,snapshot,_){
          return Container(
            height: 120,
            child: ListView.builder(itemBuilder: (context,index){
              return CircleCategory(snapshot.getListCategory[index].getImageURL, snapshot.getListCategory[index].getName);
            },itemCount: snapshot.getListCategory.length,padding: EdgeInsets.all(16),scrollDirection: Axis.horizontal),
          );
        })
      ],
    );
  }
  Widget _buildProductItemFlashSale(BuildContext context, int index){
    return InkWell(
      onTap: (){
        DatabaseService().updateViewProduct(_currentListProductFlashSale[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: _currentListProductFlashSale[index])));
      },
      child: ProductView(id: _currentListProductFlashSale[index].getId!,image: _currentListProductFlashSale[index].getImageURL![0],
        name: _currentListProductFlashSale[index].getName!,
        price: _currentListProductFlashSale[index].getPrice!,
        salePrice: _currentListProductFlashSale[index].getSalePrice!,
        promotion: _currentListProductFlashSale[index].promotionPercent(),
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
              )),onTap: (){},)
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
                  ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,scrollDirection: Axis.horizontal,itemBuilder: _buildProductItemFlashSale, separatorBuilder: (context, index) => SizedBox(width: 15), itemCount: _currentListProductFlashSale.length),
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

  Widget _buildProductItemMegaSale(BuildContext context, int index){
    return InkWell(
      onTap: (){
        DatabaseService().updateViewProduct(_currentListProductMegaSale[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: _currentListProductMegaSale[index])));
      },
      child: ProductView(id: _currentListProductMegaSale[index].getId!,image: _currentListProductMegaSale[index].getImageURL![0],
        name: _currentListProductMegaSale[index].getName!,
        price: _currentListProductMegaSale[index].getPrice!,
        salePrice: _currentListProductMegaSale[index].getSalePrice!,
        promotion:  _currentListProductMegaSale[index].promotionPercent(),
        isFavoriteView: false,),
    );
  }

  Widget _buildListMegaSale(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mega Sale",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),),
              InkWell(child: Text("See More",style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              )),onTap: (){},)
            ],
          ),
        ),
        Container(
            height: 250,
            padding: EdgeInsets.all(14),
            child: Container(
              child: ListView(
                controller: _scrollControllerMegaSale,
                scrollDirection: Axis.horizontal,
                children: [
                  ListView.separated(physics: NeverScrollableScrollPhysics(),shrinkWrap: true,scrollDirection: Axis.horizontal,itemBuilder: _buildProductItemMegaSale, separatorBuilder: (context, index) => SizedBox(width: 15), itemCount: _currentListProductMegaSale.length),
                  _loadingMoreMegaSale ? Container(
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
    delegate: SliverChildBuilderDelegate(_buildProductItem,childCount: _currentListProduct.length),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(onTap: () async{
            final ImagePicker _picked = ImagePicker();
            final XFile? image =await _picked.pickImage(source: ImageSource.gallery);
            if(image?.name != null){
              StorageRepository().uploadFileImageAvatar(image!, 'user', snapshot.getListInfoUser!.uid,snapshot.getListInfoUser!.imageName);

            }
          },
              child: snapshot.getListInfoUser?.imageUrls == "" ? CircleAvatar(
                child: Icon(Icons.account_circle_outlined),
              ) : CircleAvatar(backgroundImage: CachedNetworkImageProvider(snapshot.getListInfoUser?.imageUrls ?? "https://us.123rf.com/450wm/yehorlisnyi/yehorlisnyi2104/yehorlisnyi210400016/167492439-no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-comin.jpg?ver=6"),)
          ),
          ElevatedButton(onPressed: () async{
            _authService.signOut();
          }, child: Text("Sign Out"))

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