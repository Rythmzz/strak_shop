import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/views/product_view.dart';

import '../models/info_user_model.dart';
import '../models/order.dart';
import '../models/order_model.dart';
import '../services/colors.dart';
import '../services/database.dart';

class DetailCartPage extends StatefulWidget{

  @override
  State<DetailCartPage> createState() => _DetailCartPageState();
}

class _DetailCartPageState extends State<DetailCartPage> {
  Order _order = Order(0,"","","","",0.0,"",[]);



  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context,snapshot,_){
      return Consumer<OrderModel>(builder:(context,snapshotOr,_){
        return snapshot.getListCart.isNotEmpty ? SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16), child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.getListCart.length,
                    itemBuilder: (context,i) => ProductCartView(currentCart: snapshot.getListCart[i],currentUser: snapshot,isOrder: false),
                    separatorBuilder: (context,i) => SizedBox(height: 10,),
                  ),),SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                    child: Card(elevation: 8,
                      child: Container(
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
                                    ),onPressed: () {
                                      showDialog(context: context, builder: (context) {
                                        return AlertDialog(
                                          title: Text("Order Confirmation"),
                                          content: Container(
                                            width: 250,
                                            height: 250,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextField(onChanged: (val){
                                                    _order.address = val;
                                                  },
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(width:3)
                                                      ),
                                                      hintText: "Enter Your Address",
                                                    ),style: TextStyle(
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  SizedBox(height: 12,)
                                                  ,
                                                  TextField(
                                                    onChanged: (val) {
                                                      _order.orderNote = val;
                                                    },
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(width:3),
                                                      ),
                                                      hintText: "Note",
                                                    ),
                                                    style: TextStyle(fontSize: 12),
                                                    keyboardType: TextInputType.multiline,
                                                    minLines: 5,
                                                    maxLines: 5,
                                                    maxLength: 100,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(onPressed: () {
                                                        Navigator.of(context).pop();
                                                      }, child: Text("Cancel")),
                                                      SizedBox(width: 15,),
                                                      ElevatedButton(onPressed: () async {
                                                        if(snapshotOr.getListOrder != []){
                                                          _order.id = snapshotOr.getListOrder.last.getId + 1;
                                                        }
                                                        _order.uid = snapshot.getListInfoUser!.uid;
                                                        _order.orderCode = "#TM${_order.getId}";
                                                        _order.orderDate = DateFormat.yMEd().add_jms().format(DateTime.now());
                                                        _order.totalPrice = double.tryParse(snapshot.totalPrice().toStringAsFixed(2))!;
                                                        snapshot.getListCart.forEach((element) {
                                                          String data = json.encode(element);
                                                          _order.addObject(jsonDecode(data));
                                                        });
                                                        await DatabaseService(_order.getUid).createNewOrder(_order.getId, _order.getOrderDate, _order.getOrderCode, _order.getOrderNote, _order.getTotalPrice, _order.getAddress, _order.getOrderDetail);
                                                        await DatabaseService(_order.getUid).removeAllCart();
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Buy Success")));
                                                        Navigator.of(context).pop();
                                                      }, child: Text("Confirm"))
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                      },);
                                    }, child: Text("Buy Now")),
                                  )
                                ],
                              )

                            ],)
                          ],
                        ),
                      ),
                    ),
                  ),

                ])) : Center(
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
              Text("Cart is empty",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: StrakColor.colorTheme7
              ),),
              SizedBox(height: 15,),
              ElevatedButton(style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(StrakColor.colorTheme7)
              ),onPressed: (){
                snapshot.setSelectIndex = 0;

              }, child: Text("Back To Shopping",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white
              ),))

            ],
          ),
        );
      });
    });
  }
}