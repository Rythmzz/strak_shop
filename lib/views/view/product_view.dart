import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';

class ProductView extends StatelessWidget {
  final Product currentProduct;

  final bool isFavoriteView;

  const ProductView(
      {super.key, required this.currentProduct, required this.isFavoriteView});

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context, snapshot, _) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 3, color: StrakColor.colorTheme6),
          ),
          width: 141,
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              currentProduct.getImageURL[0]),
                          fit: BoxFit.fitWidth)),
                ),
                onTap: () async {},
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentProduct.getName.length < 26
                      ? currentProduct.getName
                      : "${currentProduct.getName.substring(0, 26)}...",
                  style: const TextStyle(
                      color: Colors.indigo,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      currentProduct.getSalePrice == 0
                          ? "\$${currentProduct.getPrice}"
                          : "\$${currentProduct.getSalePrice}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${currentProduct.getPrice}",
                      style: TextStyle(
                        color: currentProduct.getSalePrice == 0
                            ? Colors.transparent
                            : Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 10,
                      )),
                  Text("${currentProduct.promotionPercent()}% Off",
                      style: TextStyle(
                          color: currentProduct.getSalePrice == 0
                              ? Colors.transparent
                              : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  Visibility(
                    visible: isFavoriteView ? true : false,
                    child: IconButton(
                      onPressed: () async {
                        await DatabaseService(snapshot.getListInfoUser?.uid)
                            .updateRemoveIdProduct(currentProduct.getId);
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

// ignore: must_be_immutable
class ProductCartView extends StatefulWidget {
  final Cart currentCart;
  InfoUserModel currentUser;
  final bool isOrder;

  ProductCartView(
      {super.key,
      required this.currentCart,
      required this.currentUser,
      required this.isOrder});

  @override
  State<ProductCartView> createState() => _ProductCartViewState();
}

class _ProductCartViewState extends State<ProductCartView> {
  Product currentProduct = Product();

  void convertProduct(ProductModel snapshot) async {
    for (int i = 0; i < snapshot.getListProduct.length; i++) {
      if (snapshot.getListProduct[i].getId == widget.currentCart.getIdProduct) {
        currentProduct = snapshot.getListProduct[i];
        break;
      }
    }
  }

  void deleteCart() async {
    widget.currentCart.amount = widget.currentCart.getAmount! - 1;
    await DatabaseService(widget.currentUser.getListInfoUser!.uid)
        .removeCart(widget.currentCart);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductModel>(
      builder: (context, snapshot, _) {
        if (snapshot.getListProduct.isNotEmpty) {
          convertProduct(snapshot);
          return Container(
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 3, color: StrakColor.colorTheme6)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              width: 2, color: StrakColor.colorTheme6),
                          image: DecorationImage(
                              image: NetworkImage(currentProduct
                                          .getImageURL[0] !=
                                      ""
                                  ? currentProduct.getImageURL[0]
                                  : 'https://unctad.org/sites/default/files/inline-images/ccpb_workinggroup_productsafety_800x450.jpg'))),
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
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    currentProduct.getName.length <= 26
                                        ? currentProduct.getName
                                        : "${currentProduct.getName.substring(0, 25)}..",
                                    style: TextStyle(
                                        color: StrakColor.colorTheme7,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Visibility(
                                  visible: widget.isOrder ? false : true,
                                  child: InkWell(
                                    child: widget
                                            .currentUser.getListInfoUser!.favorite
                                            .contains(currentProduct.getId)
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Colors.grey,
                                          ),
                                    onTap: () async {
                                      if (!widget
                                          .currentUser.getListInfoUser!.favorite
                                          .contains(currentProduct.getId)) {
                                        await DatabaseService(widget
                                                .currentUser.getListInfoUser!.uid)
                                            .updateAddIdProduct(
                                                currentProduct.getId);
                                      } else {
                                        await DatabaseService(widget
                                                .currentUser.getListInfoUser!.uid)
                                            .updateRemoveIdProduct(
                                                currentProduct.getId);
                                      }
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: widget.isOrder ? false : true,
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                    ),
                                    onTap: () async {
                                      await DatabaseService(widget
                                              .currentUser.getListInfoUser!.uid)
                                          .removeCart(widget.currentCart);
                                    },
                                  ),
                                )
                              ],
                            ),
                            Container(
                              color: StrakColor.colorTheme6,
                              width: double.infinity,
                              child: Text(
                                widget.currentCart.getSize != ""
                                    ? "Type:${widget.currentCart.getSize},${widget.currentCart.getColor}"
                                    : widget.currentCart.getColor != ""
                                        ? "Type:${widget.currentCart.getColor}"
                                        : "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${(widget.currentCart.getPrice! * widget.currentCart.getAmount!).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Visibility(
                                  visible: widget.isOrder ? false : true,
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible:
                                            widget.currentCart.getAmount == 1
                                                ? false
                                                : true,
                                        child: InkWell(
                                          onTap: () async {
                                            await DatabaseService(widget
                                                    .currentUser
                                                    .getListInfoUser!
                                                    .uid)
                                                .updateIndexCart(
                                                    widget.currentCart, -1);
                                            await DatabaseService(widget
                                                    .currentUser
                                                    .getListInfoUser!
                                                    .uid)
                                                .removeIndexCart(
                                                    widget.currentCart, -1);
                                          },
                                          child: Container(
                                            width: 32,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4),
                                                        bottomLeft:
                                                            Radius.circular(4)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: StrakColor
                                                        .colorTheme6)),
                                            child: const Icon(Icons.remove,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 28,
                                        alignment: Alignment.center,
                                        color: StrakColor.colorTheme6,
                                        child: Text(
                                            "${widget.currentCart.getAmount!}"),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await DatabaseService(widget
                                                  .currentUser
                                                  .getListInfoUser!
                                                  .uid)
                                              .updateIndexCart(
                                                  widget.currentCart, 1);
                                          await DatabaseService(widget
                                                  .currentUser
                                                  .getListInfoUser!
                                                  .uid)
                                              .removeIndexCart(
                                                  widget.currentCart, 1);
                                        },
                                        child: Container(
                                          width: 32,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(4),
                                                      bottomRight:
                                                          Radius.circular(4)),
                                              border: Border.all(
                                                  width: 2,
                                                  color:
                                                      StrakColor.colorTheme6)),
                                          child: const Icon(Icons.add,
                                              color: Colors.grey),
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
              ));
        }
        return const SizedBox();
      },
    );
  }
}
