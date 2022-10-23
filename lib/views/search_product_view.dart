import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:strak_shop_project/models/bloc_search.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/product_detail_view.dart';
import 'package:strak_shop_project/views/product_view.dart';

class SearchProductView extends StatelessWidget{
  final _blocSearch = BlocSearch();
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        title: SizedBox(
            height: 50,
            child: Form(
              onChanged: (){
                if(_editingController.text.isNotEmpty){
                  _blocSearch.addChar(_editingController.text);
                }
              },
              child: TextFormField(
                autofocus: true,
                controller: _editingController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    _editingController.clear();
                  }, icon: Icon(Icons.clear)),
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
          IconButton(icon: Icon(Icons.mic),color: Colors.grey,onPressed: (){
          },),
        ],
      ),
      body: SafeArea(child: StreamBuilder(initialData: _blocSearch.getListCurrentSearch,stream: _blocSearch.getStateController.stream,builder:(context,snapshot){
        if(snapshot.hasData){
          return (_editingController.text.isNotEmpty) ? (_blocSearch.getListCurrentSearch.length != 0 ? GridView.builder(itemCount: _blocSearch.getListCurrentSearch.length,gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16,crossAxisSpacing: 16,childAspectRatio: 165/258), itemBuilder: _buildItemProduct) : Center(
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
                Text("Product Not Found",style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: StrakColor.colorTheme7
                ),)

              ],
            ),
          )) : FutureBuilder(future: DatabaseService().getProductMaxView(),builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    DatabaseService().updateViewProduct(snapshot.data![index].getId!);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: snapshot.data![index])));
                  },
                  child: Padding(padding: EdgeInsets.all(16),child: Text(snapshot.data![index].getName!,style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                  ),)),
                );
              }, itemCount: snapshot.data?.length);
            }
            return  Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            );
          });
        }
        else {
          return  Center(
            child: SpinKitChasingDots(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          );
        }
      })),
    );
  }
  Widget _buildItemProduct(BuildContext context,int index){
    return InkWell(
      onTap: (){
        DatabaseService().updateViewProduct(_blocSearch.getListCurrentSearch[index].getId!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailView(currentProduct: _blocSearch.getListCurrentSearch[index])));
      },
      child: ProductView(id: _blocSearch.getListCurrentSearch[index].getId!,image: _blocSearch.getListCurrentSearch[index].getImageURL![0],
        name: _blocSearch.getListCurrentSearch[index].getName!,
        price: _blocSearch.getListCurrentSearch[index].getPrice!,
        salePrice: _blocSearch.getListCurrentSearch[index].getSalePrice!,
        promotion:  (100 - (_blocSearch.getListCurrentSearch[index].getSalePrice!/_blocSearch.getListCurrentSearch[index].getPrice!) * 100).round(),
        isFavoriteView: false,),
    );
  }



}