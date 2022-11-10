import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strak_shop_project/views/product_category_view.dart';
import 'package:strak_shop_project/views/product_detail_view.dart';
import 'package:strak_shop_project/views/product_flashsale_view.dart';
import 'package:strak_shop_project/views/product_top_search_view.dart';
import 'package:strak_shop_project/views/product_view.dart';

import '../models/category_model.dart';
import '../models/product.dart';
import '../services/colors.dart';
import '../services/database.dart';
import 'category_view.dart';
import 'home_view.dart';

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
        autoPlay: true,
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
          return _listCatergory(context, snapshot);
        })
      ],
    );
  }
  Widget _listCatergory(BuildContext context,CategoryModel snapshot){
    return Container(
      height: 120,
      child: ListView.builder(itemBuilder: (context,index){
        return InkWell(onTap: (){
          Navigator.of(context).pushNamed('category/${snapshot.getListCategory[index].getId}');
        },child: index <= 10 ? CircleCategory(snapshot.getListCategory[index].getImageURL, snapshot.getListCategory[index].getName) : SizedBox());
      },itemCount: snapshot.getListCategory.length,padding: EdgeInsets.all(16),scrollDirection: Axis.horizontal),
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