import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

class DetailHomePage extends StatefulWidget {
  const DetailHomePage({super.key});

  @override
  State<DetailHomePage> createState() => _DetailHomePageState();
}

class _DetailHomePageState extends State<DetailHomePage> {
  int _indexActive = 0;

  static const int _endReachedThreshold = 200;

  static const int _itemPageFlashSale = 3;
  int _nextPageFlashSale = 1;
  bool _loadingMoreFlashSale = true;
  bool _loadingFlashSale = true;
  final List<Product> _currentListProductFlashSale = [];
  final ScrollController _scrollControllerFlashSale = ScrollController();

  static const int _itemPageTopView = 3;
  int _nextPageTopView = 1;
  bool _loadingMoreTopView = true;
  bool _loadingTopView = true;
  final List<Product> _currentListProductTopView = [];
  final ScrollController _scrollControllerTopView = ScrollController();

  static const int _itemsPerPage = 4;
  final ScrollController _scrollController = ScrollController();
  final List<Product> _currentListProduct = [];
  int _nextPage = 1;
  bool _loading = true;
  bool _canLoadMore = true;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildImageTransition(),
                _buildIndicator(),
                _buildListCategory(),
                _buildListFlashSale(),
                _buildListTopView(),
                _buildImageRecommendProduct(),
              ])
        ])),
        _buildGridLoadDataProduct(),
        _buildLoading(),
      ],
    );
  }

  @override
  void initState() {
    _scrollControllerFlashSale.addListener(() {
      if (!_scrollControllerFlashSale.hasClients || _loadingFlashSale) return;

      final thresholdReached = _scrollControllerFlashSale.position.extentAfter <
          _endReachedThreshold;

      if (thresholdReached) {
        getProductFlashSale();
      }
    });
    getProductFlashSale();

    _scrollControllerTopView.addListener(() {
      if (!_scrollControllerTopView.hasClients || _loadingTopView) return;

      final threholdReached =
          _scrollControllerTopView.position.extentAfter < _endReachedThreshold;

      if (threholdReached) {
        getProductTopView();
      }
    });
    getProductTopView();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients || _loading) return;

      final thresholdReached =
          _scrollController.position.extentAfter < _endReachedThreshold;

      if (thresholdReached) {
        _getProducts();
      }
    });
    _getProducts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerFlashSale.dispose();
    _scrollControllerTopView.dispose();
    super.dispose();
  }

  Future<void> getProductTopView() async {
    _loadingTopView = true;

    final listProduct = await DatabaseService()
        .getProductWithView(page: _nextPageTopView, limit: _itemPageTopView);

    if (!mounted) return;

    setState(() {
      _currentListProductTopView.addAll(listProduct);
      _nextPageTopView++;

      if (listProduct.length < _itemPageTopView) {
        _loadingMoreTopView = false;
      }
      _loadingTopView = false;
    });
  }

  Future<void> getProductFlashSale() async {
    _loadingFlashSale = true;
    final listProduct = await DatabaseService().getProductWithFlashSale(
        page: _nextPageFlashSale, limit: _itemPageFlashSale);

    if (!mounted) return;

    setState(() {
      _currentListProductFlashSale.addAll(listProduct);
      _nextPageFlashSale++;

      if (listProduct.length < _itemPageFlashSale) {
        _loadingMoreFlashSale = false;
      }
      _loadingFlashSale = false;
    });
  }

  Future<void> _getProducts() async {
    _loading = true;
    final newProducts = await DatabaseService()
        .getPageProducts(page: _nextPage, limit: _itemsPerPage);

    if (!mounted) return;
    setState(() {
      _currentListProduct.addAll(newProducts);

      _nextPage++;

      if (newProducts.length < _itemsPerPage) {
        _canLoadMore = false;
      }

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

  Widget circleCategory(String image, String textCategory) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(image),
            foregroundColor: StrakColor.colorTheme6,
          ),
          const SizedBox(
            height: 5,
          ),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(textCategory,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  )))
        ],
      ),
    );
  }

  Widget _buildImageTransition() {
    return CarouselSlider(
        items: [1, 2, 3, 4, 5, 6, 7].map((i) {
          return Builder(builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: i != 1
                    ? Image.asset(
                        "assets/images_wallpaper/slider_image$i.png",
                        fit: BoxFit.fill,
                      )
                    : Stack(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProductFlashSaleView(
                                        sliderTime: const SliderLabel()))),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images_wallpaper/slider_image$i.png"),
                                      fit: BoxFit.fill,
                                      opacity: 0.85)),
                            ),
                          ),
                          const SliderLabel(),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
              ),
            );
          });
        }).toList(),
        options: CarouselOptions(
            height: 206,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _indexActive = index;
              });
            }));
  }

  Widget _buildIndicator() {
    return AnimatedSmoothIndicator(
        activeIndex: _indexActive,
        count: 7,
        effect: JumpingDotEffect(
            dotWidth: 6,
            dotHeight: 6,
            dotColor: StrakColor.colorTheme6,
            activeDotColor: Theme.of(context).primaryColor));
  }

  Widget _buildListCategory() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Category",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              InkWell(
                child: Text("More Category",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CategoryView()));
                },
              )
            ],
          ),
        ),
        Consumer<CategoryModel>(builder: (context, snapshot, _) {
          return _listCatergory(context, snapshot);
        })
      ],
    );
  }

  Widget _listCatergory(BuildContext context, CategoryModel snapshot) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      'category/${snapshot.getListCategory[index].getId}');
                },
                child: index <= 10
                    ? circleCategory(
                        snapshot.getListCategory[index].getImageURL,
                        snapshot.getListCategory[index].getName)
                    : const SizedBox());
          },
          itemCount: snapshot.getListCategory.length,
          padding: const EdgeInsets.all(16),
          scrollDirection: Axis.horizontal),
    );
  }

  Widget _buildProductItemFlashSale(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        await DatabaseService()
            .updateViewProduct(_currentListProductFlashSale[index].getId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailView(
                currentProduct: _currentListProductFlashSale[index])));
      },
      child: ProductView(
        currentProduct: _currentListProductFlashSale[index],
        isFavoriteView: false,
      ),
    );
  }

  Widget _buildListFlashSale() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Flash Sale",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              InkWell(
                child: Text("See More",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductFlashSaleView(
                          sliderTime: _buildImageTransition())));
                },
              )
            ],
          ),
        ),
        Container(
            height: 250,
            padding: const EdgeInsets.all(14),
            child: ListView(
              controller: _scrollControllerFlashSale,
              scrollDirection: Axis.horizontal,
              children: [
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => index <= 10
                        ? _buildProductItemFlashSale(context, index)
                        : const SizedBox(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemCount: _currentListProductFlashSale.length),
                _loadingMoreFlashSale
                    ? Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.center,
                        child: SpinKitChasingDots(
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : const SizedBox()
              ],
            ))
      ],
    );
  }

  Widget _buildProductItemTopView(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        DatabaseService()
            .updateViewProduct(_currentListProductTopView[index].getId);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailView(
                currentProduct: _currentListProductTopView[index])));
      },
      child: ProductView(
        currentProduct: _currentListProductTopView[index],
        isFavoriteView: false,
      ),
    );
  }

  Widget _buildListTopView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Search",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              InkWell(
                child: Text("See More",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProductTopSearchView()));
                },
              )
            ],
          ),
        ),
        Container(
            height: 250,
            padding: const EdgeInsets.all(14),
            child: ListView(
              controller: _scrollControllerTopView,
              scrollDirection: Axis.horizontal,
              children: [
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => index <= 10
                        ? _buildProductItemTopView(context, index)
                        : const SizedBox(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemCount: _currentListProductTopView.length),
                _loadingMoreTopView
                    ? Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.center,
                        child: SpinKitChasingDots(
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : const SizedBox()
              ],
            ))
      ],
    );
  }

  Widget _buildImageRecommendProduct() {
    return Container(
      height: 206,
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage("assets/images_wallpaper/slider_image8.png"),
                    fit: BoxFit.fill,
                    opacity: 0.85)),
          ),
          Row(
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Recommend Product",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "We recommend the best for you",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: SizedBox())
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGridLoadDataProduct() {
    return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 165 / 258,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          delegate: SliverChildBuilderDelegate(_buildItemProduct,
              childCount: _currentListProduct.length),
        ));
  }

  Widget _buildLoading() {
    return SliverToBoxAdapter(
        child: _canLoadMore
            ? Container(
                padding: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                child: SpinKitChasingDots(
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : const SizedBox());
  }
}
