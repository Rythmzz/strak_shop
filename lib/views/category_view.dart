import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/category_model.dart';
import 'package:strak_shop_project/views/product_category_view.dart';

import '../services/colors.dart';

class CategoryView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
        return Consumer<CategoryModel>(builder: (context,snapshot,_){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                child: Text("Category",style: TextStyle(
                    color: StrakColor.colorTheme7,
                    fontSize:  20,
                    fontWeight: FontWeight.bold
                ),),
              ),
              toolbarHeight: 80,
              foregroundColor: Colors.grey,
            ),
            body: SafeArea(child:
                ListView.separated(itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductCategoryView(idCategory: snapshot.getListCategory[index].getId, nameCategory:snapshot.getListCategory[index].getName)));
                      },
                      child: ListTile(
                        title: Text(snapshot.getListCategory[index].getName,style: TextStyle(
                          color: StrakColor.colorTheme7,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),),
                        leading: SizedBox(width: 50,height: 50,child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(snapshot.getListCategory[index].getImageURL),)),
                      ),
                    ),
                  );
                }, separatorBuilder: (context,index) => Divider(height: 3,color: StrakColor.colorTheme6,), itemCount: snapshot.getListCategory.length)
            )
          );
        },);
  }

}