import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

class ProductFavoriteView extends StatefulWidget {
  final List<int> listID;

  const ProductFavoriteView({super.key, required this.listID});

  @override
  State<ProductFavoriteView> createState() => _ProductFavoriteViewState();
}

class _ProductFavoriteViewState extends State<ProductFavoriteView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context, snapshots, _) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            "Favorite Product",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: StrakColor.colorTheme7,
                fontSize: 20),
          ),
          toolbarHeight: 80,
        ),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            StreamBuilder(
              stream: Stream.fromFuture(DatabaseService()
                  .getProductWithFavorite(
                      id: snapshots.getListInfoUser!.favorite)),
              builder: (context, snapshot) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return snapshot.data == null
                            ? Center(
                                child: SpinKitChasingDots(
                                  color: Theme.of(context).primaryColor,
                                  size: 50,
                                ),
                              )
                            : ProductView(
                                currentProduct: snapshot.data![index],
                                isFavoriteView: true,
                              );
                      }, childCount: snapshot.data?.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 165 / 248)),
                );
              },
            )
          ],
        )),
      );
    });
  }
}
