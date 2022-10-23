import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/info_user_model.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/product_view.dart';

import '../models/product.dart';

class ProductFavoriteView extends StatefulWidget{

  final List<int> listID;


  ProductFavoriteView({required this.listID});

  @override
  State<ProductFavoriteView> createState() => _ProductFavoriteViewState();
}

class _ProductFavoriteViewState extends State<ProductFavoriteView> {
  List<Product> _currentListProduct = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshots,_){
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text("Favorite Product", style: TextStyle(
              fontWeight: FontWeight.bold,
              color: StrakColor.colorTheme7,
              fontSize: 16
          ),),
        ),
        body: SafeArea(child: CustomScrollView(
          slivers: [
            StreamBuilder(stream: Stream.fromFuture(DatabaseService().getProductWithFavorite(id: snapshots.getListInfoUser!.favorite)),
              builder: (context,snapshot){
                  return SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverGrid(delegate:SliverChildBuilderDelegate((context,index){
                      return snapshot?.data == null ? Center(
                        child: Text("Nothing"),
                      )  : ProductView(id: snapshot.data![index].getId!,image: snapshot.data![index].getImageURL![0],
                        name: snapshot.data![index].getName!,
                        price: snapshot.data![index].getPrice!,
                        salePrice: snapshot.data![index].getSalePrice!,
                        promotion: snapshot.data![index].promotionPercent(), isFavoriteView:true,);
                    },childCount: snapshot.data?.length), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 16,crossAxisSpacing: 16,childAspectRatio: 165/248)),
                  );

              },)

          ],
        )),
      );
    });
  }


}