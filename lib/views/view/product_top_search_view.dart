import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

class ProductTopSearchView extends StatefulWidget {
  const ProductTopSearchView({super.key});

  @override
  State<ProductTopSearchView> createState() => _ProductTopSearchViewState();
}

class _ProductTopSearchViewState extends State<ProductTopSearchView> {
  int _nextPage = 1;
  static const int _itemPage = 6;
  static const int _reachedLimitPage = 200;

  final List<Product> _currentListProduct = [];

  bool _loading = true;

  bool _loadingMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients || _loading) return;
      final thresholdReached =
          _scrollController.position.extentAfter < _reachedLimitPage;
      if (thresholdReached) {
        getProductTopView();
      }
    });

    getProductTopView();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getProductTopView() async {
    _loading = true;
    final listProduct = await DatabaseService()
        .getProductWithView(page: _nextPage, limit: _itemPage);

    if (!mounted) return;

    setState(() {
      _currentListProduct.addAll(listProduct);

      if (listProduct.length < _itemPage) {
        _loadingMore = false;
      }
      _nextPage++;
      _loading = false;
    });
  }

  Widget _buildItemProduct(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        DatabaseService().updateViewProduct(_currentListProduct[index].getId);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailView(currentProduct: _currentListProduct[index])));
      },
      child: ProductView(
        currentProduct: _currentListProduct[index],
        isFavoriteView: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          child: Text(
            "Popular",
            style: TextStyle(
                color: StrakColor.colorTheme7,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        toolbarHeight: 80,
        foregroundColor: Colors.grey,
      ),
      body: SafeArea(
          child: CustomScrollView(
        controller: _scrollController,
        slivers: [
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
              child: _loadingMore
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
}
