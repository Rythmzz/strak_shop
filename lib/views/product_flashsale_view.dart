import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/product_view.dart';

import '../models/product.dart';

class ProductFlashSaleView extends StatefulWidget{

  Widget sliderTime;


  ProductFlashSaleView({required this.sliderTime});

  @override
  State<ProductFlashSaleView> createState() => _ProductFlashSaleViewState();
}

class _ProductFlashSaleViewState extends State<ProductFlashSaleView> {
  static const int _itemPage = 4;
  static const int _reachedLimit = 100;

  int _nextPage = 1;
  List<Product> _currentListProduct = [];


  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isLoadingMore = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients || _isLoading) return;

      final thresholdReached = _scrollController.position.extentAfter < _reachedLimit;

      if(thresholdReached){
        _getProduct();
      };


    });

    _getProduct();
    super.initState();
  }
  
  Widget _buildItemProduct(BuildContext context, int index){
    return ProductView(id: _currentListProduct[index].getId!,isFavoriteView: false,image: _currentListProduct[index].getImageURL![0],
        name: _currentListProduct[index].getName!,
        price: _currentListProduct[index].getPrice!,
        salePrice: _currentListProduct[index].getSalePrice!,
        promotion:  _currentListProduct[index].promotionPercent());
  }


  @override
  void dispose() {
   _scrollController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Flash Sale",style: TextStyle(
          color: StrakColor.colorTheme7
        ),),
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child: Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SafeArea(child:  CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(delegate: SliverChildListDelegate([
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                      height: 200,
                    child: Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images_wallpaper/slider_image1.png"),fit: BoxFit.fill,opacity: 0.85),
                        ),
                      ),
                      Container(
                        child: widget.sliderTime,
                      ),
                    ],),
                  ),
                ),
                SizedBox(height: 8,),
              ],
            )
          ])),
        SliverPadding(padding: EdgeInsets.all(16),sliver: SliverGrid(delegate: SliverChildBuilderDelegate(_buildItemProduct,childCount: _currentListProduct.length), gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 165/258,crossAxisCount: 2,mainAxisSpacing: 16,crossAxisSpacing: 16),),)
          ,SliverToBoxAdapter(
              child: _isLoadingMore ? Container(
                padding: EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: SpinKitChasingDots(
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ) : SizedBox()
          )
        ],
      )),
    );
  }

  Future<void> _getProduct() async {
    _isLoading = true;

    final List<Product>  listProduct = await DatabaseService().getProductWith50Percent(page: _nextPage , limit: _itemPage);

    if(!mounted) return;

   setState(() {
     _currentListProduct.addAll(listProduct);

     if(listProduct.length < _itemPage){
        _isLoadingMore = false;
     }

     _nextPage++;
     _isLoading = false;
   });



  }

}