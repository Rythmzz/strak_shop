import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/product_detail_view.dart';
import 'package:strak_shop_project/views/product_view.dart';

import '../models/product.dart';
import '../services/colors.dart';

class ProductCategoryView extends StatefulWidget{
  final int idCategory;
  final String nameCategory;

  const ProductCategoryView({super.key, required this.idCategory, required this.nameCategory});

  @override
  State<ProductCategoryView> createState() => _ProductCategoryViewState();
}

class _ProductCategoryViewState extends State<ProductCategoryView> {
  static const int _itemPage = 6;
  static const int _reachedLimitPage = 200;

  int _nextPage = 1;
  List<Product> _currentListProduct = [];

  bool _loading = true;
  bool _loadingMore = true;

  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    _scrollController.addListener(() {
      if(!_scrollController.hasClients || _loading) return;

      final thresholdReached = _scrollController.position.extentAfter < _reachedLimitPage;

      if(thresholdReached){
        getProductCategory();
      }

    });

    getProductCategory();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getProductCategory() async{

    _loading = true;
    final listProduct = await DatabaseService().getProductWithCategory(idCategory: widget.idCategory, itemsPage: _nextPage, limitPage:_itemPage);

    if(!mounted) return;

    setState(() {
      _currentListProduct.addAll(listProduct);

      if(listProduct.length < _itemPage){
        _loadingMore = false;
      }
      _nextPage++;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: StrakColor.colorTheme6,width: 2)),image: DecorationImage(image: AssetImage("assets/images_app/logo_strak_red.png"),fit: BoxFit.fitWidth)),
          ),
          SizedBox(width: 30,)
        ],
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          child: Text("${widget.nameCategory}",style: TextStyle(
              color: StrakColor.colorTheme7,
              fontSize:  20,
              fontWeight: FontWeight.bold
          ),),
        ),
        toolbarHeight: 80,
        foregroundColor: Colors.grey,
      ),
      body: SafeArea(child:  CustomScrollView(
        controller: _scrollController,
        slivers: [SliverPadding(padding: EdgeInsets.all(16),sliver: _currentListProduct.length == 0 ?  SliverToBoxAdapter(child:
        Center(
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
              Text("No products or out of stock",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: StrakColor.colorTheme7
              ),)
            ],
          ),
        ),) :SliverGrid(delegate: SliverChildBuilderDelegate(_buildItemProduct,childCount: _currentListProduct.length), gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 165/258,crossAxisCount: 2,mainAxisSpacing: 16,crossAxisSpacing: 16),),)
          ,SliverToBoxAdapter(
              child: _loadingMore ? Container(
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
}