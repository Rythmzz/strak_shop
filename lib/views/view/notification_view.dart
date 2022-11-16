import 'package:flutter/material.dart';

import 'package:strak_shop_project/services/service.dart';

class ActivityPageView extends StatelessWidget {
  const ActivityPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(color: StrakColor.colorTheme6, width: 2)),
                image: const DecorationImage(
                    image: AssetImage("assets/images_app/logo_strak_red.png"),
                    fit: BoxFit.fitWidth)),
          ),
          const SizedBox(
            width: 30,
          )
        ],
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Text(
          "Activity",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: StrakColor.colorTheme7,
              fontSize: 20),
        ),
        toolbarHeight: 80,
      ),
      body: const SafeArea(child: Text("Activity")),
    );
  }
}

class FeedPageView extends StatelessWidget {
  const FeedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            "Feed",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: StrakColor.colorTheme7,
                fontSize: 16),
          )),
      body: const SafeArea(child: Text("Activity")),
    );
  }
}

class OfferPageView extends StatelessWidget {
  const OfferPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            "Offer",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: StrakColor.colorTheme7,
                fontSize: 16),
          )),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.local_offer_outlined,
                color: Colors.blue,
              ),
              title: const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text("The Best Title")),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                      """ Culpa cillum consectetur labore nulla nulla magna irure. Id veniam culpa officia aute dolor amet deserunt ex proident commodo """),
                  SizedBox(
                    height: 10,
                  ),
                  Text("April 30, 2014 1:01 PM")
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.local_offer_outlined,
                color: Colors.blue,
              ),
              title: const Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Text("SUMMER OFFER 98% Cashback")),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                      """ Culpa cillum consectetur labore nulla nulla magna irure. Id veniam culpa officia aute dolor"""),
                  SizedBox(
                    height: 10,
                  ),
                  Text("April 30, 2014 1:01 PM")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationPageView extends StatelessWidget {
  const NotificationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          title: Text(
            "Notification",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: StrakColor.colorTheme7,
                fontSize: 16),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OfferPageView()));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.local_offer_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("Offer"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FeedPageView()));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.feed_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("Feed"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ActivityPageView()));
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("Activity"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
