import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

class DetailCartPage extends StatefulWidget {
  const DetailCartPage({super.key});

  @override
  State<DetailCartPage> createState() => _DetailCartPageState();
}

class _DetailCartPageState extends State<DetailCartPage> {
  final Order _order = Order();

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context, snapshot, _) {
      return Consumer<OrderModel>(builder: (context, snapshotOr, _) {
        return snapshot.getListCart.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.getListCart.length,
                        itemBuilder: (context, i) => ProductCartView(
                            currentCart: snapshot.getListCart[i],
                            currentUser: snapshot,
                            isOrder: false),
                        separatorBuilder: (context, i) => const SizedBox(
                          height: 10,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Items (${snapshot.getListCart.length})",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    "\$${snapshot.totalPrice().toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Shipping",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    "\$0",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Import Charges",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    "\$0",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 10,
                                color: StrakColor.colorTheme7,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: TextStyle(
                                        color: StrakColor.colorTheme7,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${snapshot.totalPrice().toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        StrakColor
                                                            .colorTheme7)),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Cancel")),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (snapshotOr
                                                                    .getListOrder !=
                                                                []) {
                                                              _order
                                                                  .id = snapshotOr
                                                                      .getListOrder
                                                                      .last
                                                                      .getId +
                                                                  1;
                                                            }
                                                            _order.uid = snapshot
                                                                .getListInfoUser!
                                                                .uid;
                                                            _order.orderCode =
                                                                "#TM${_order.getId}";
                                                            _order.orderDate =
                                                                DateFormat
                                                                        .yMEd()
                                                                    .add_jms()
                                                                    .format(DateTime
                                                                        .now());
                                                            _order.totalPrice =
                                                                double.tryParse(snapshot
                                                                    .totalPrice()
                                                                    .toStringAsFixed(
                                                                        2))!;
                                                            _order.setOrderDetail =
                                                                <Cart>[];
                                                            for (var cart
                                                                in snapshot
                                                                    .getListCart) {
                                                              _order.addCart(
                                                                  cart);
                                                            }
                                                            DatabaseService()
                                                                .createNewOrder(
                                                              _order,
                                                            );
                                                            DatabaseService(
                                                                    _order
                                                                        .getUid)
                                                                .removeAllCart();
                                                            await Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            3))
                                                                .then((value) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("Buy Success")));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: const Text(
                                                              "Confirm")),
                                                    ],
                                                    elevation: 24,
                                                    title: const Text(
                                                        "Order Confirmation"),
                                                    content: SizedBox(
                                                      width: 250,
                                                      height: 250,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              onChanged: (val) {
                                                                _order.address =
                                                                    val;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: StrakColor
                                                                            .colorTheme6,
                                                                        width:
                                                                            3)),
                                                                border: const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            width:
                                                                                3)),
                                                                hintText:
                                                                    "Enter Your Address",
                                                              ),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            TextField(
                                                              onChanged: (val) {
                                                                _order.orderNote =
                                                                    val;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: StrakColor
                                                                            .colorTheme6,
                                                                        width:
                                                                            3)),
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              3),
                                                                ),
                                                                hintText:
                                                                    "Note",
                                                              ),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              minLines: 5,
                                                              maxLines: 5,
                                                              maxLength: 100,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text("Buy Now")),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const ShapeDecoration(
                          shape: CircleBorder(), color: Colors.blue),
                      child: const Icon(Icons.clear,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Cart is empty",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: StrakColor.colorTheme7),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                StrakColor.colorTheme7)),
                        onPressed: () {
                          snapshot.setSelectIndex = 0;
                        },
                        child: const Text(
                          "Back To Shopping",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ))
                  ],
                ),
              );
      });
    });
  }
}
