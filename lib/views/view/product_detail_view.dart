import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';
import 'edit_product_view.dart';

class ProductDetailView extends StatefulWidget {
  final Product currentProduct;

  const ProductDetailView({super.key, required this.currentProduct});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _indexActive = 0;

  String _selectSize = "";
  Color? _selectColor;
  final List<Color> _currentListColor = [];

  late Cart _cart;

  @override
  void initState() {
    for (var stringColor in widget.currentProduct.getListColor) {
      String valueString =
          stringColor.split('(0x')[1].split(')')[0]; // kind of hacky..
      int value = int.parse(valueString, radix: 16);
      _selectColor = Color(value);
      _currentListColor.add(_selectColor!);
    }
    if (widget.currentProduct.getListSize.isNotEmpty) {
      _selectSize = widget.currentProduct.getListSize[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context, snapshot, _) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            widget.currentProduct.getName.length < 20
                ? widget.currentProduct.getName
                : "${widget.currentProduct.getName.substring(0, 20)}...",
            style: TextStyle(color: StrakColor.colorTheme7, fontSize: 20),
          ),
          toolbarHeight: 80,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchProductView()));
                },
                icon: const Icon(Icons.search_outlined)),
            snapshot.getListInfoUser?.email == "admin968@gmail.com"
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProductView(
                              currentProduct: widget.currentProduct)));
                    },
                    icon: const Icon(Icons.settings))
                : IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            elevation: 8,
            onPressed: () async {
              // ignore: prefer_if_null_operators, unnecessary_null_comparison
              _cart = Cart(
                  widget.currentProduct.getId,
                  1,
                  widget.currentProduct.getSalePrice == 0
                      ? widget.currentProduct.getPrice
                      : widget.currentProduct.getSalePrice,
                  // ignore: prefer_if_null_operators, unnecessary_null_comparison
                  _selectSize == null ? "" : _selectSize,
                  _selectColor == null ? "" : _selectColor.toString());
              for (int i = 0; i < snapshot.getListCart.length; i++) {
                if (_cart.getIdProduct ==
                        snapshot.getListCart[i].getIdProduct &&
                    _cart.getColor == snapshot.getListCart[i].getColor &&
                    _cart.getSize == snapshot.getListCart[i].getSize) {
                  _cart.amount = snapshot.getListCart[i].getAmount! + 1;
                  DatabaseService(snapshot.getListInfoUser!.uid)
                      .removeCart(snapshot.getListCart[i]);
                  break;
                }
              }
              DatabaseService(snapshot.getListInfoUser!.uid).updateCart(_cart);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add Cart Success")));
            },
            child: Icon(
              Icons.add_shopping_cart,
              size: 30,
              color: StrakColor.colorTheme6,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                  delegate: SliverChildListDelegate(
                [
                  CarouselSlider(
                      items: widget.currentProduct.getListImageURL.map((image) {
                        return Builder(builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(image),
                                      fit: BoxFit.contain),
                                  border: Border.all(
                                      width: 3, color: StrakColor.colorTheme6)),
                            ),
                          );
                        });
                      }).toList(),
                      options: CarouselOptions(
                          height: 206,
                          viewportFraction: 1,
                          autoPlay:
                              widget.currentProduct.getListImageURL.length > 1
                                  ? true
                                  : false,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _indexActive = index;
                            });
                          })),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedSmoothIndicator(
                        activeIndex: _indexActive,
                        count: widget.currentProduct.getListImageURL.length,
                        effect: JumpingDotEffect(
                            dotWidth: 6,
                            dotHeight: 6,
                            dotColor: StrakColor.colorTheme6,
                            activeDotColor: Theme.of(context).primaryColor)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Text(
                          widget.currentProduct.getName,
                          style: TextStyle(
                              color: StrakColor.colorTheme7,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              if (!snapshot.getListInfoUser!.favorite
                                  .contains(widget.currentProduct.getId)) {
                                await DatabaseService(
                                        snapshot.getListInfoUser!.uid)
                                    .updateAddIdProduct(
                                        widget.currentProduct.getId);
                              } else {
                                await DatabaseService(
                                        snapshot.getListInfoUser!.uid)
                                    .updateRemoveIdProduct(
                                        widget.currentProduct.getId);
                              }
                            },
                            icon: snapshot.getListInfoUser?.favorite.contains(
                                        widget.currentProduct.getId) ==
                                    true
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border_outlined),
                            color: Colors.pinkAccent,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.currentProduct.getSalePrice == 0
                        ? "\$${widget.currentProduct.getPrice}"
                        : "\$${widget.currentProduct.getSalePrice}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.currentProduct.getListSize.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Size",
                              style: TextStyle(
                                  color: StrakColor.colorTheme7,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectSize = widget
                                                  .currentProduct
                                                  .getListSize[index];
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                border: Border.all(
                                                    width: 2,
                                                    color: _selectSize ==
                                                            widget.currentProduct
                                                                    .getListSize[
                                                                index]
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : StrakColor
                                                            .colorTheme6)),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(widget.currentProduct
                                                  .getListSize[index]),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount:
                                      widget.currentProduct.getListSize.length,
                                  scrollDirection: Axis.horizontal),
                            )
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  (widget.currentProduct.getListColor).isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Color",
                              style: TextStyle(
                                  color: StrakColor.colorTheme7,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectColor =
                                                  _currentListColor[index];
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 50,
                                            height: 50,
                                            decoration: ShapeDecoration(
                                              shape: CircleBorder(
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: StrakColor
                                                          .colorTheme6)),
                                              color: _currentListColor[index],
                                            ),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: ShapeDecoration(
                                                  shape: const CircleBorder(),
                                                  color: _selectColor ==
                                                          _currentListColor[
                                                              index]
                                                      ? (_selectColor ==
                                                              Colors.white
                                                          ? Colors.black
                                                          : Colors.white)
                                                      : Colors.transparent),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    );
                                  },
                                  itemCount:
                                      widget.currentProduct.getListColor.length,
                                  scrollDirection: Axis.horizontal),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            color: StrakColor.colorTheme7,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("""${widget.currentProduct.getDescription} """)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              StrakColor.colorTheme7)),
                      onPressed: () async {
                        // ignore: unnecessary_null_comparison
                        _cart = Cart(
                            widget.currentProduct.getId,
                            1,
                            widget.currentProduct.getSalePrice == 0
                                ? widget.currentProduct.getPrice
                                : widget.currentProduct.getSalePrice,
                            // ignore: unnecessary_null_comparison
                            _selectSize != null ? "" : _selectSize,
                            _selectColor == null
                                ? ""
                                : _selectColor.toString());
                        for (int i = 0; i < snapshot.getListCart.length; i++) {
                          if (_cart.getIdProduct ==
                                  snapshot.getListCart[i].getIdProduct &&
                              _cart.getColor ==
                                  snapshot.getListCart[i].getColor &&
                              _cart.getSize ==
                                  snapshot.getListCart[i].getSize) {
                            _cart.amount =
                                snapshot.getListCart[i].getAmount! + 1;
                            DatabaseService(snapshot.getListInfoUser!.uid)
                                .removeCart(snapshot.getListCart[i]);
                            break;
                          }
                        }
                        DatabaseService(snapshot.getListInfoUser!.uid)
                            .updateCart(_cart);
                        snapshot.setSelectIndex = 2;
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ))
                ],
              )),
            )
          ],
        )),
      );
    });
  }
}
