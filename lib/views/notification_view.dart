import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/colors.dart';


class ActivityPageView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return Scaffold(appBar: AppBar(
         foregroundColor: Colors.grey,
         backgroundColor: Colors.white,
         title: Text("Activity", style: TextStyle(
             fontWeight: FontWeight.bold,
             color: StrakColor.colorTheme7,
             fontSize: 16
         ),)),
       body:SafeArea(child: Text("Activity")),
     );
  }
  
}

class FeedPageView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Text("Feed", style: TextStyle(
            fontWeight: FontWeight.bold,
            color: StrakColor.colorTheme7,
            fontSize: 16
        ),)),
      body:SafeArea(child: Text("Activity")),
    );
  }
}

class OfferPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Text("Offer", style: TextStyle(
            fontWeight: FontWeight.bold,
            color: StrakColor.colorTheme7,
            fontSize: 16
        ),)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.local_offer_outlined,color: Colors.blue,),
              title: Padding(padding: EdgeInsets.only(top: 16,bottom: 16),child: Text("The Best Title")),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(""" Culpa cillum consectetur labore nulla nulla magna irure. Id veniam culpa officia aute dolor amet deserunt ex proident commodo """),
                  SizedBox(height: 10,),
                  Text("April 30, 2014 1:01 PM")
                ],
              ),),
            ListTile(leading: Icon(Icons.local_offer_outlined,color: Colors.blue,),
              title: Padding(padding: EdgeInsets.only(top: 16,bottom: 16),child: Text("SUMMER OFFER 98% Cashback")),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(""" Culpa cillum consectetur labore nulla nulla magna irure. Id veniam culpa officia aute dolor"""),
                  SizedBox(height: 10,),
                  Text("April 30, 2014 1:01 PM")
                ],
              ),)
          ],
        ),
      ),
    );
  }
}

class NotificationPageView  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Text("Notification", style: TextStyle(
        fontWeight: FontWeight.bold,
        color: StrakColor.colorTheme7,
        fontSize: 16
    ),)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfferPageView()));
                },
                child: ListTile(
                  leading: Icon(Icons.local_offer_outlined,color: Colors.blue,),
                  title: Text("Offer"),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FeedPageView()));
                },
                child: ListTile(
                  leading: Icon(Icons.feed_outlined,color: Colors.blue,),
                  title: Text("Feed"),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityPageView()));
                },
                child: ListTile(
                  leading: Icon(Icons.notifications_none_outlined,color: Colors.blue,),
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