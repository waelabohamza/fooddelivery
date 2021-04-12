import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/location.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/component/getnotify.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/pages/offers/offers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';

final List<String> imgList = [
  'https://$serverName/upload/offers/1.jpg',
  'https://$serverName/upload/offers/2.jpeg',
];

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Start For Slider

  Crud crud = new Crud();

  LocationPermission permission;

  CarouselController buttonCarouselController = CarouselController();

  Future getCategories() async {
    var responsebody = await crud.readData("categories");
    return responsebody;
  }

  Future getRestaurants() async {
    var responsebody = await crud.readData("restaurants");
    return responsebody;
  }

  Future getImageHome() async {
    var responsebody = await crud.readData("imagehome");
    return responsebody;
  }

  checkRequestLocation() async {
    permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  }

  setLocal() async {
    var lang = sharedPrefs.getString("lang");
    if (lang == "ar") {
      await Jiffy.locale("ar");
    }
    // final String defaultLocale = Platform.localeName;
    // print("=============== Locale");
    // print(defaultLocale);
  }

  updateBalance() async {
       var responsebody = await crud.readDataWhere("balance" , sharedPrefs.getString("id"));
       sharedPrefs.setString("balance", responsebody['user_balance']);
       setState(() {
         
       });
       print( "=========================== Balance" ) ; 
       print( responsebody['user_balance']  ) ; 
  }

  @override
  void initState(){
    updateBalance()  ;
    setLocal();
    checkRequestLocation();
    requestPermissionLocation(context);
    getNotify(context);
    requestPermissons();
    getLocalNotification();
    requestLocalPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      return showAlert(
              context, "error", "اغلاق", "هل تريد الخروج من التطبيق", () {},
              () {
            exit(0);
          }) ??
          false;
    }

    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
          child: ListView(
            children: <Widget>[
              MyAppBar(
                currentpage: "home",
                titlepage: "الصفحة الرئيسية",
                search: "searchall",
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "ماذا تريد ان تطلب",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 190,
                width: MediaQuery.of(context).size.width / 3,
                child: FutureBuilder(
                  future: getImageHome(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: 10),
                          buildImageTalab(
                              "https://$serverName/upload/home/${snapshot.data['imagehome_talabpay']}",
                              "${snapshot.data['textpay']}", () {
                            Navigator.of(context).pushNamed("money");
                          }),
                          SizedBox(width: 10),
                          buildImageTalab(
                              "https://$serverName/upload/home/${snapshot.data['imagehome_food']}",
                              "${snapshot.data['textfood']}", () {
                            Navigator.of(context).pushNamed("homefood");
                          }),
                          SizedBox(width: 10),
                          buildImageTalab(
                              "https://$serverName/upload/home/${snapshot.data['imagehome_taxi']}",
                              "${snapshot.data['texttaxi']}", () {
                            Navigator.of(context).pushNamed("hometaxi");
                          }),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    "العروض",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              FutureBuilder(
                future: crud.readData("offers"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: OffersList(offers: snapshot.data[i]));
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              SizedBox(height: 20)
            ],
          ),
          onWillPop: onWillPop),
    );
  }

  InkWell buildImageTalab(url, title, navigate()) {
    return InkWell(
        onTap: navigate,
        child: Container(
            child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 110,
                  width: 150,
                  fit: BoxFit.fill,
                )),
            Container(child: Text("$title"))
          ],
        )));
  }

  // Container buildRestaurantsRecommendations(res) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 10),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(15),
  //           child: CachedNetworkImage(
  //             imageUrl: "https://$serverName/upload/reslogo/${res['res_image']}",
  //             placeholder: (context, url) => CircularProgressIndicator(),
  //             errorWidget: (context, url, error) => Icon(Icons.error),
  //             height: 120,
  //             width: 240,
  //             fit: BoxFit.fill,
  //           ),
  //         ),
  //         Container(child: Text("مطعم : ${res['res_name']} "))
  //       ],
  //     ),
  //   );
  // }
}
