import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:strak_shop_project/models/model.dart';
import 'package:strak_shop_project/services/service.dart';
import 'package:strak_shop_project/views/view.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String? uid;

  HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearch = true;
  String _labelPage = "";
  late List<Widget> _selectPage;
  bool _isExit = false;

  @override
  void initState() {
    _selectPage = [
      Consumer<CategoryModel>(builder: (context, snapshot, _) {
        return Navigator(
          onGenerateRoute: (setting) {
            Widget page = const DetailHomePage();
            for (int i = 0; i < snapshot.getListCategory.length; i++) {
              if (setting.name ==
                  "category/${snapshot.getListCategory[i].getId}") {
                page = ProductCategoryView(
                    idCategory: snapshot.getListCategory[i].getId,
                    nameCategory: snapshot.getListCategory[i].getName);
                break;
              }
            }
            return MaterialPageRoute(builder: (context) => page);
          },
        );
      }),
      const DetailExplorePage(),
      const DetailCartPage(),
      DetailUserPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoUserModel>(builder: (context, snapshot, _) {
      if(snapshot.getListInfoUser != null){
        return WillPopScope(
          onWillPop: () async {
            if (_isExit == false) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Press again to exit the screen")));
              _isExit = true;
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: _isSearch
                ? AppBar(
              backgroundColor: Colors.white,
              title: SizedBox(
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchProductView()));
                      _isExit = false;
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "Search Product",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: StrakColor.colorTheme6, width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: StrakColor.colorTheme6, width: 3)),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  )),
              toolbarHeight: 80,
              actions: [
                IconButton(
                  icon: Badge(
                    showBadge: snapshot.getListInfoUser!.favorite.isEmpty
                        ? false
                        : true,
                    child: const Icon(Icons.favorite_border_outlined),
                  ),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductFavoriteView(
                          listID:
                          snapshot.getListInfoUser?.favorite == null
                              ? []
                              : snapshot.getListInfoUser!.favorite,
                        )));
                    _isExit = false;
                  },
                ),
                IconButton(
                  icon: Badge(
                    child: const Icon(Icons.notifications_none_outlined),
                  ),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                        const NotificationPageView()));
                    _isExit = false;
                  },
                ),
              ],
            )
                : AppBar(
              backgroundColor: Colors.white,
              actions: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                              color: StrakColor.colorTheme6, width: 2)),
                      image: const DecorationImage(
                          image: AssetImage(
                              "assets/images_app/logo_strak_red.png"),
                          fit: BoxFit.fitWidth)),
                ),
                const SizedBox(
                  width: 30,
                )
              ],
              title: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                child: Text(
                  _labelPage,
                  style: TextStyle(
                      color: StrakColor.colorTheme7,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: Visibility(
              visible:
              snapshot.getListInfoUser?.uid == "vepLb8PezZPJfAMbVpDNkePTOef1"
                  ? true
                  : false,
              child: FloatingActionButton(
                  backgroundColor: StrakColor.colorTheme6,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (contextr) => const CreateNewProducts()));
                    _isExit = false;
                  },
                  child: const Icon(
                    Icons.add_business_outlined,
                    size: 30,
                    color: Colors.blueAccent,
                  )),
            ),
            body: SafeArea(
              child: _selectPage.elementAt(snapshot.getSelectIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 24),
                  label: "Home",
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined, size: 24),
                    label: "Explore"),
                BottomNavigationBarItem(
                    icon: Badge(
                      badgeContent: Text(
                        "${snapshot.getListCart.length}",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      showBadge: snapshot.getListCart.isEmpty ? false : true,
                      child: const Icon(Icons.shopping_cart_outlined),
                    ),
                    label: "Cart"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined, size: 24),
                    label: "Account")
              ],
              currentIndex: snapshot.getSelectIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: (val) => handleClickMenu(val, snapshot),
            ),
          ),
        );
      }
      return const Scaffold(
        body: Center(
          child: SpinKitChasingDots(
            size: 50,
            color: Colors.blue,
          ),
        ),
      );
    });
  }

  void handleClickMenu(int val, InfoUserModel snapshot) {
    snapshot.setSelectIndex = val;
    setState(() {
      if (val == 2 || val == 3) {
        setState(() {
          _isSearch = false;
          if (val == 2) {
            _labelPage = "Your Cart";
          } else {
            _labelPage = "Your Account";
          }
        });
      } else {
        setState(() {
          _isSearch = true;
        });
      }
    });
  }
}

class SliderLabel extends StatefulWidget {
  const SliderLabel({super.key});

  @override
  State<SliderLabel> createState() => _SliderLabelState();
}

class _SliderLabelState extends State<SliderLabel> {
  DateTime now = DateTime.now();
  late Duration _countDownDuration;
  Duration _duration = const Duration();
  Timer? timer;
  final bool _isCountDown = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => addTime());
  }

  void addTime() {
    final addSeconds = _isCountDown ? -1 : 1;
    setState(() {
      final seconds = _duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() {
    setState(() {
      _duration = _countDownDuration;
    });
  }

  @override
  void initState() {
    _countDownDuration =
        Duration(hours: now.hour, minutes: now.minute, seconds: now.second);
    super.initState();
    startTimer();
    reset();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildTimeCard({required String time}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        time,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String twoDits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDits(_duration.inHours).toString();
    String minutes = twoDits(_duration.inMinutes.remainder(60)).toString();
    String seconds = twoDits(_duration.inSeconds.remainder(60)).toString();

    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Super Flash Sale 50% Off",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    buildTimeCard(time: hours),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        ":",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ),
                    buildTimeCard(time: minutes),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        ":",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                    ),
                    buildTimeCard(time: seconds)
                  ],
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox())
      ],
    );
  }
}
