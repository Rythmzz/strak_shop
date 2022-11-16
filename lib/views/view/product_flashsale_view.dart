import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:strak_shop_project/views/view.dart';
import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';

// ignore: must_be_immutable
class ProductFlashSaleView extends StatefulWidget {
  Widget sliderTime;

  ProductFlashSaleView({super.key, required this.sliderTime});

  @override
  State<ProductFlashSaleView> createState() => _ProductFlashSaleViewState();
}

class _ProductFlashSaleViewState extends State<ProductFlashSaleView> {
  static const int _itemPage = 4;
  static const int _reachedLimit = 100;

  int _nextPage = 1;
  final List<Product> _currentListProduct = [];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isLoadingMore = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients || _isLoading) return;

      final thresholdReached =
          _scrollController.position.extentAfter < _reachedLimit;

      if (thresholdReached) {
        _getProduct();
      }
    });

    _getProduct();
    super.initState();
  }

  Widget _buildItemProduct(BuildContext context, int index) {
    return ProductView(
        currentProduct: _currentListProduct[index], isFavoriteView: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Super Flash Sale",
          style: TextStyle(color: StrakColor.colorTheme7),
        ),
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        actions: const [
          InkWell(
            child: Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SafeArea(
          child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images_wallpaper/slider_image1.png"),
                                fit: BoxFit.fill,
                                opacity: 0.85),
                          ),
                        ),
                        Container(
                          child: widget.sliderTime,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )
          ])),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(_buildItemProduct,
                  childCount: _currentListProduct.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 165 / 258,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16),
            ),
          ),
          SliverToBoxAdapter(
              child: _isLoadingMore
                  ? Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      child: SpinKitChasingDots(
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : const SizedBox())
        ],
      )),
    );
  }

  Future<void> _getProduct() async {
    _isLoading = true;

    final List<Product> listProduct = await DatabaseService()
        .getProductWithFlashSale(page: _nextPage, limit: _itemPage);

    if (!mounted) return;

    setState(() {
      _currentListProduct.addAll(listProduct);

      if (listProduct.length < _itemPage) {
        _isLoadingMore = false;
      }

      _nextPage++;
      _isLoading = false;
    });
  }
}
