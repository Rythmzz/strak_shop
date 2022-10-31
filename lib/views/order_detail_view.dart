import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/models/info_user_model.dart';
import 'package:strak_shop_project/models/order.dart';
import 'package:strak_shop_project/models/order_model.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/product_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../models/product_model.dart';
import '../services/colors.dart';
class OrderView extends StatelessWidget{
 String currentUserUid;
 List<Order> _currentListOrder = [];

  OrderView({required this.currentUserUid});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderModel>(builder: (context,snapshot,_){
      snapshot.getListOrder.forEach((element) {
        if(currentUserUid == element.getUid)
          _currentListOrder.add(element);
        else if (currentUserUid == "vepLb8PezZPJfAMbVpDNkePTOef1"){
          _currentListOrder.add(element);
        }
      });
      return Scaffold(
        appBar: AppBar(actions: [
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
            child: Text("Order",style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          ),
          toolbarHeight: 80,
          foregroundColor: Colors.grey,
        ),
        body: SafeArea(child:
        _currentListOrder.isNotEmpty ? ListView.separated(itemBuilder: (context,index){
      return InkWell(onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetail(currentOrder: _currentListOrder[index])));
      },child: OrderDetailView(currentOrder: _currentListOrder[index]));
      }, separatorBuilder: (context,index) => SizedBox(height: 5,), itemCount:_currentListOrder.length) :
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
              Text("You don't have any orders yet",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: StrakColor.colorTheme7
              ),)

            ],
          ),
        )
        ),
      );
    },);
  }
}
class OrderDetail extends StatelessWidget{
  final Order currentOrder;
  List<Cart> currentOrderDetail = [];

  OrderDetail({super.key, required this.currentOrder});
  @override
  Widget build(BuildContext context) {
   return Consumer<InfoUserModel>(builder: (context,snapshot,_){
     currentOrder.getOrderDetail.forEach((element) {
     String data = json.encode(element);
     currentOrderDetail.add(Cart.fromJson(jsonDecode(data)));
   });
     return Scaffold(
       appBar: AppBar(actions: [
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
           child: Text("Order Detail",style: TextStyle(
               color: StrakColor.colorTheme7,
               fontSize:  20,
               fontWeight: FontWeight.bold
           ),),
         ),
         toolbarHeight: 80,
         foregroundColor: Colors.grey,
       ),
       body: SafeArea(child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SfLinearGauge(
                 labelOffset: 20,
                 showTicks: false,
                 minimum: 0,
                 maximum: 115,
                 labelFormatterCallback: (label){
                   if(label == '0'){
                     return "Order Check";
                   }
                   else if (label == '40'){
                     return "Packing";
                   }
                   else if (label == '80'){
                     return "Shipping";
                   }
                   else if (label == '115'){
                     return "Success";
                   }
                   else {
                     return "";
                   }
                 },
                 barPointers: [
                   LinearBarPointer(value: 40,color: Colors.green,),
                 ],
                 markerPointers: [
                   LinearWidgetPointer(value: 0 , child: Container(
                     width: 32,
                     height: 32,
                     decoration: ShapeDecoration(shape: CircleBorder(),color: Colors.green),
                     child: Icon(Icons.check,color: Colors.white,),
                   )),
                   LinearWidgetPointer(value: 40 , child: Container(
                     width: 32,
                     height: 32,
                     decoration: ShapeDecoration(shape: CircleBorder(),color: Colors.green),
                     child: Icon(Icons.check,color: Colors.white,),
                   )),
                   LinearWidgetPointer(value: 80 , child: Container(
                     width: 32,
                     height: 32,
                     decoration: ShapeDecoration(shape: CircleBorder(),color: Colors.grey),
                     child: Icon(Icons.check,color: Colors.white,),
                   )),
                   LinearWidgetPointer(value: 115 , child: Container(
                     width: 32,
                     height: 32,
                     decoration: ShapeDecoration(shape: CircleBorder(),color: Colors.grey),
                     child: Icon(Icons.check,color: Colors.white,),
                   )),
                 ],

               ),
               SizedBox(height: 20,),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Product",style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: StrakColor.colorTheme7
                   ),),
                   SizedBox(height: 5,),
                   Container(
                     height: 325,
                     child: Padding(
                       padding: EdgeInsets.all(16), child: ListView.separated(
                       itemCount: currentOrderDetail.length,
                       itemBuilder: (context,i) => ProductCartView(currentCart: currentOrderDetail[i],currentUser: snapshot,isOrder:true),
                       separatorBuilder: (context,i) => SizedBox(height: 10,),
                     ),),
                   ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text("Shipping",style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: StrakColor.colorTheme7
               ),),
               SizedBox(height: 5,),
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Card(
                   elevation: 8,
                   child: Container(
                     padding: EdgeInsets.all(8.0),
                     decoration: BoxDecoration(
                         border: Border.all(width: 3,color: StrakColor.colorTheme6)
                     ),
                     child: Column(
                       children: [
                       Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Date Shipping",style: TextStyle(
                             color: Colors.grey,
                             fontSize: 14
                         ),),
                         Text("None",style: TextStyle(
                             fontSize: 14
                         ),)
                       ],
                     ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Shipping",style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 14
                             ),),
                             Text("None",style: TextStyle(
                                 fontSize: 14
                             ),)
                           ],
                         ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("No. Resi",style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 14
                             ),),
                             Text("None",style: TextStyle(
                                 fontSize: 14
                             ),)
                           ],
                         ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Flexible(
                               flex: 1,
                               child: Text("Address",style: TextStyle(
                                   color: Colors.grey,
                                   fontSize: 14
                               ),),
                             ),
                             Flexible(flex: 1,
                               child: Text("${currentOrder.getAddress}",style: TextStyle(
                                   fontSize: 14,
                                   color: Colors.red
                               ),),
                             )
                           ],
                         ),
                         SizedBox(height: 20,)
                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Payment Details",style: TextStyle(
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                           color: StrakColor.colorTheme7
                       ),),
                       SizedBox(height: 15,),
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Card(
                           elevation: 8,
                           child: Container(
                             padding: EdgeInsets.all(8.0),
                             decoration: BoxDecoration(
                                 border: Border.all(width: 3,color: StrakColor.colorTheme6)
                             ),
                             child: Column(
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text("Items(${currentOrder.getOrderDetail.length}",style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 14
                                     ),),
                                     Text("\$${currentOrder.getTotalPrice}",style: TextStyle(
                                         fontSize: 14
                                     ),)
                                   ],
                                 ),
                                 SizedBox(height: 20,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text("Shipping",style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 14
                                     ),),
                                     Text("\$0",style: TextStyle(
                                         fontSize: 14
                                     ),)
                                   ],
                                 ),
                                 SizedBox(height: 20,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text("Import charges",style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 14
                                     ),),
                                     Text("\$0",style: TextStyle(
                                         fontSize: 14
                                     ),)
                                   ],
                                 ),
                                 SizedBox(height: 15,),
                                 Divider(color: StrakColor.colorTheme6,height: 3,),
                                 SizedBox(height: 15,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text("Total Price",style: TextStyle(
                                         color: StrakColor.colorTheme7,
                                         fontSize: 14,
                                       fontWeight: FontWeight.bold
                                     ),),
                                     Text("${currentOrder.getTotalPrice}",style: TextStyle(
                                         fontSize: 14,
                                         color: Colors.lightBlueAccent
                                         ,fontWeight: FontWeight.bold
                                     ),)
                                   ],
                                 ),
                                 SizedBox(height: 20,)
                               ],
                             ),
                           ),
                         ),
                       ),
                     ],
                   )


                 ],
               )
             ],
           ),
         ),
       )),
     );
   },);
  }

}

class OrderDetailView extends StatelessWidget{
  final Order currentOrder;

  OrderDetailView({required this.currentOrder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3,color: StrakColor.colorTheme6)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${currentOrder.getOrderCode}",style: TextStyle(
                          color: StrakColor.colorTheme7,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 10,),
                      Text("Order at: ${currentOrder.getOrderDate}",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                      ),)

                    ],
                  ),
                  SizedBox(width:50,height:50,child: CircleAvatar(backgroundImage: AssetImage("assets/images_app/logo_strak.png"),backgroundColor: Colors.white,)),
                ],
              ),
              SizedBox(height: 15,),
              Divider(color: StrakColor.colorTheme6,height: 3,),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Status",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),),
                  Text("Packing",style: TextStyle(
                      fontSize: 14
                  ),)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Items",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),),
                  Text("${currentOrder.getOrderDetail.length} Items purchased",style: TextStyle(
                      fontSize: 14
                  ),)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),),
                  Text("\$${currentOrder.getTotalPrice}",style: TextStyle(
                      fontSize: 14,
                    color: Colors.lightBlueAccent
                  ),)
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }



}