import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

class DetailExplorePage extends StatelessWidget {
  const DetailExplorePage({super.key});

  Widget circleCategory(String image, String textCategory) {
    return SizedBox(
      width: 60,
      height: 100,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: StrakColor.colorTheme6,
            backgroundImage: CachedNetworkImageProvider(image),
            foregroundColor: StrakColor.colorTheme6,
            maxRadius: 28.0,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(builder: (context, snapshot, _) {
      return SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Man Fashion",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for (var x in snapshot.getListCategory)
                  if (x.getGenderStyle == "male")
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductCategoryView(
                                  idCategory: x.getId,
                                  nameCategory: x.getName)));
                        },
                        child: circleCategory(x.getImageURL, x.getName))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Woman Fashion",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for (var x in snapshot.getListCategory)
                  if (x.getGenderStyle == "female")
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductCategoryView(
                                  idCategory: x.getId,
                                  nameCategory: x.getName)));
                        },
                        child: circleCategory(x.getImageURL, x.getName))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Other",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                for (var x in snapshot.getListCategory)
                  if (x.getGenderStyle == "both")
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductCategoryView(
                                  idCategory: x.getId,
                                  nameCategory: x.getName)));
                        },
                        child: circleCategory(x.getImageURL, x.getName))
              ],
            ),
          )
        ],
      ));
    });
  }
}
