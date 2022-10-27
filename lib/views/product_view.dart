import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/product.dart';
import 'package:strak_shop_project/models/product_model.dart';
import 'package:strak_shop_project/services/database.dart';

import '../models/cart.dart';
import '../models/info_user_model.dart';
import '../services/colors.dart';

class ProductView extends StatelessWidget{
  final Product currentProduct;

  final bool isFavoriteView;

   ProductView({super.key,required this.currentProduct,required this.isFavoriteView});

   @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(
      builder: (context,snapshot,_) {
        return Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 3,color: StrakColor.colorTheme6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    width: 109,
                    height: 109,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        image: DecorationImage(image: CachedNetworkImageProvider(currentProduct.getImageURL![0]),fit: BoxFit.fitWidth)
                    ),
                  ),
                  onTap: () async {
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(currentProduct.getName!.length < 26 ? currentProduct.getName! : "${currentProduct.getName!.substring(0,26)}...",style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                ),
          Align(
            alignment: Alignment.centerLeft,
                child: Text(currentProduct.getSalePrice == 0 ? "\$${currentProduct.getPrice}" : "\$${currentProduct.getSalePrice}" ,style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${currentProduct.getPrice}",style: TextStyle(
                      color: currentProduct.getSalePrice == 0 ? Colors.transparent : Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 10,
                    )),
                    Text("${currentProduct.promotionPercent()}% Off",style: TextStyle(
                        color: currentProduct.getSalePrice == 0 ? Colors.transparent : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    )),
                    Visibility(child: IconButton(onPressed: () async{
                      await DatabaseService(snapshot.getListInfoUser?.uid).updateRemoveIdProduct(currentProduct.getId!);
                    }, icon: Icon(Icons.delete_outline),color:Colors.grey,),visible: isFavoriteView ? true : false,)
                  ],
                )

              ],

            ),
            width: 141,
          ),
        );
      }
    );
  }

}


class ProductCartView extends StatefulWidget{
  final Cart currentCart;
  InfoUserModel currentUser;
  final bool isOrder;

  ProductCartView({required this.currentCart,required this.currentUser,required this.isOrder});

  @override
  State<ProductCartView> createState() => _ProductCartViewState();
}

class _ProductCartViewState extends State<ProductCartView> {
  Product currentProduct = Product(0,"", 0.0, 0.0, [], [], ["http://dacon.rwdc.sg/wp-content/uploads/2021/01/test-product.png","","","",""], ["http://dacon.rwdc.sg/wp-content/uploads/2021/01/test-product.png","","","",""], 0, 0, "");

  void convertProduct(ProductModel snapshot) async {
    for(int i = 0 ; i < snapshot.getListProduct.length ; i++){
      if(snapshot.getListProduct[i].getId == widget.currentCart.getIdProduct){
        currentProduct = snapshot.getListProduct[i];
        break;
      }
    }
  }

  void deleteCart() async{


    widget.currentCart.amount = widget.currentCart.getAmount! - 1;
    await DatabaseService(widget.currentUser.getListInfoUser!.uid).removeCart(widget.currentCart);

  }

  @override
  Widget build(BuildContext context) {
   return Consumer<ProductModel>(builder: (context,snapshot,_){
      convertProduct(snapshot);
     return Container(
         height: 140,
         decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(4)),
             border: Border.all(width: 3,color: StrakColor.colorTheme6)
         ),
         child: Padding(
           padding: EdgeInsets.all(8),
           child: Row(
             children: [
               Container(
                 width: 72,
                 height: 72,
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(8)),
                     border: Border.all(width: 2,color: StrakColor.colorTheme6),
                     image: DecorationImage(image: NetworkImage(currentProduct.getImageURL![0]))
                 ),
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Flexible(child:Text(currentProduct.getName!.length <= 26 ? currentProduct.getName! : "${currentProduct.getName!.substring(0,25)}..",style: TextStyle(color: StrakColor.colorTheme7,
                               fontSize: 16,fontWeight: FontWeight.bold),) ,flex: 5,),
                           SizedBox(width: 20,),
                           InkWell(
                             child: widget.currentUser.getListInfoUser!.favorite.contains(currentProduct.getId) ? Icon(Icons.favorite,color: Colors.pink,) : Icon(Icons.favorite_border,color: Colors.grey,),
                             onTap: () async {
                               if(!widget.currentUser.getListInfoUser!.favorite.contains(currentProduct.getId)){
                                 await DatabaseService(widget.currentUser.getListInfoUser!.uid).updateAddIdProduct(currentProduct.getId!);
                               }
                               else {
                                 await DatabaseService(widget.currentUser.getListInfoUser!.uid).updateRemoveIdProduct(currentProduct.getId!);
                               }
                             },
                           ) ,
                           Visibility(
                             visible: widget.isOrder ? false : true,
                             child: InkWell(
                               child: Icon(Icons.delete_outline,color: Colors.grey,),
                               onTap: () async{
                                 await DatabaseService(widget.currentUser.getListInfoUser!.uid).removeCart(widget.currentCart);
                               },
                             ),
                           )
                         ],
                       ),
                     Container(
                       color: StrakColor.colorTheme6,
                       width: double.infinity,
                       child: Text(widget.currentCart.getSize != "" ? "Type:${widget.currentCart.getSize},${widget.currentCart.getColor}" : widget.currentCart.getColor != "" ? "Type:${widget.currentCart.getColor}" : "" ,style: TextStyle(

                           fontWeight: FontWeight.bold,
                           fontSize: 14
                       ),),
                     )
                     ,
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("\$${(widget.currentCart.getPrice! * widget.currentCart.getAmount!).toStringAsFixed(2)}",style: TextStyle(
                               color: Colors.blueAccent,
                               fontWeight: FontWeight.bold,
                               fontSize: 14
                           ),),
                           Visibility(
                             visible: widget.isOrder ? false : true,
                             child: Row(
                               children: [
                                 Visibility(
                                   visible: widget.currentCart.getAmount == 1 ? false : true,
                                   child: InkWell(
                                     onTap: () async {
                                       await DatabaseService(widget.currentUser.getListInfoUser!.uid).updateIndexCart(widget.currentCart,-1);
                                       await DatabaseService(widget.currentUser.getListInfoUser!.uid).removeIndexCart(widget.currentCart,-1);
                                   },
                                     child: Container(
                                       width:32,
                                       child: Icon(Icons.remove,color: Colors.grey),
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                                           border: Border.all(width: 2,color: StrakColor.colorTheme6)
                                       ),
                                     ),
                                   ),
                                 ),
                                 Container(
                                   width: 40,
                                   height: 28,
                                   alignment: Alignment.center,
                                   child: Text("${widget.currentCart.getAmount!}"),
                                   color: StrakColor.colorTheme6,
                                 ),
                                 InkWell(
                                   onTap: () async {
                                     await DatabaseService(widget.currentUser.getListInfoUser!.uid).updateIndexCart(widget.currentCart,1);
                                     await DatabaseService(widget.currentUser.getListInfoUser!.uid).removeIndexCart(widget.currentCart,1);
                                   },
                                   child: Container(
                                     width: 32,
                                     child: Icon(Icons.add,color: Colors.grey),
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                                         border: Border.all(width: 2,color: StrakColor.colorTheme6)
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           )

                         ],
                       )
                     ],
                   ),
                 ),
               )

             ],
           ),
         )
     );
   },);
  }
}