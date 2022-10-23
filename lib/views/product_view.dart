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
  final int id;
  final String image;
  final String name;
  final double price;
  final double salePrice;
  final int promotion;

  final bool isFavoriteView;

   ProductView({super.key,required this.id,required this.isFavoriteView,required this.image, required this.name, required this.price, required this.salePrice,required this.promotion});

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
                        image: DecorationImage(image: NetworkImage(image),fit: BoxFit.fitWidth)
                    ),
                  ),
                  onTap: () async {
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(name.length < 26 ? name : "${name.substring(0,26)}...",style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                ),
          Align(
            alignment: Alignment.centerLeft,
                child: Text(salePrice == 0 ? "\$$price" : "\$$salePrice" ,style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$$price",style: TextStyle(
                      color: salePrice == 0 ? Colors.transparent : Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 10,
                    )),
                    Text("$promotion% Off",style: TextStyle(
                        color: salePrice == 0 ? Colors.transparent : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                    )),
                    Visibility(child: IconButton(onPressed: () async{
                      await DatabaseService(snapshot.getListInfoUser?.uid).updateRemoveIdProduct(id);
                    }, icon: Icon(Icons.delete_outline),color: StrakColor.colorTheme6,),visible: isFavoriteView ? true : false,)
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

  ProductCartView({required this.currentCart,required this.currentUser});

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

  @override
  Widget build(BuildContext context) {
   return Consumer<ProductModel>(builder: (context,snapshot,_){
      convertProduct(snapshot);
     return Container(
         height: 160,
         decoration: BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(4)),
             border: Border.all(width: 3,color: StrakColor.colorTheme6)
         ),
         child: Padding(
           padding: EdgeInsets.all(16),
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
                           Flexible(child:Text(currentProduct.getName!.length <= 29 ? currentProduct.getName! : "${currentProduct.getName!.substring(0,29)}..",style: TextStyle(color: StrakColor.colorTheme7,
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
                           InkWell(
                             child: Icon(Icons.delete_outline,color: Colors.grey,),
                             onTap: () async {
                                await DatabaseService(widget.currentUser.getListInfoUser!.uid).removeCart(widget.currentCart);
                             },
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
                           Text("\$${currentProduct.getSalePrice == 0 ? "${(currentProduct.getPrice! * widget.currentCart.getAmount!).toStringAsFixed(2)}" : "${(currentProduct.getSalePrice! * widget.currentCart.getAmount!).toStringAsFixed(2)}"}",style: TextStyle(
                               color: Colors.blueAccent,
                               fontWeight: FontWeight.bold,
                               fontSize: 14
                           ),),
                           Row(
                             children: [
                               Container(
                                 width:32,
                                 child: Icon(Icons.remove,color: Colors.grey),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                                     border: Border.all(width: 2,color: StrakColor.colorTheme6)
                                 ),
                               ),
                               Container(
                                 width: 40,
                                 height: 28,
                                 alignment: Alignment.center,
                                 child: Text("${widget.currentCart.getAmount!}"),
                                 color: StrakColor.colorTheme6,
                               ),
                               Container(
                                 width: 32,
                                 child: Icon(Icons.add,color: Colors.grey),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                                     border: Border.all(width: 2,color: StrakColor.colorTheme6)
                                 ),
                               )
                             ],
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