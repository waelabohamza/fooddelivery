import 'package:flutter/material.dart';
import 'package:fooddelivery/component/applocal.dart';
import 'package:fooddelivery/component/location.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/food/refreshparttype.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery/component/getnotify.dart';
import 'package:fooddelivery/pages/restaurants/restaurantslist.dart';
import 'package:provider/provider.dart';

class HomeFood extends StatefulWidget {
  HomeFood({Key key}) : super(key: key);

  @override
  _HomeFoodState createState() => _HomeFoodState();
}

class _HomeFoodState extends State<HomeFood> {
  Crud crud = new Crud();

  Future getRestaurants() async {
    var responsebody = await crud.readData("restaurants");
    return responsebody;
  }

  @override
  void initState() {
    // checkSignIn();
    requestPermissionLocation(context);
    getNotify(context);
    requestPermissons();
    getLocalNotification();
    requestLocalPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.grey[50],
      //   elevation: 3.0,
      //   title: Text(
      //     "الطعام",
      //     style: Theme.of(context).textTheme.headline5,
      //   ),
      //   actions: [
      //     IconButton(
      //         icon: Icon(
      //           Icons.search,
      //           color: Colors.black,
      //         ),
      //         onPressed: () {
      //           showSearch(
      //               context: context,
      //               delegate: DataSearch(type: "restuarants", mdw: mdw));
      //         })
      //   ],
      // ),
      body: WillPopScope(
          child: ListView(
            children: <Widget>[
              MyAppBar(
                currentpage: "homepage",
                titlepage: "${getLang(context, "restaurant")}",
                search: "restaurants",
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "${getLang(context, "restaurant_type")}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              BuildListHorizontal(
                crud: crud,
              ),
              Consumer<RefreshPartPageType>(
                  builder: (context, refreshtype, child) {
                return Padding(
                    padding: EdgeInsets.only(top: 10, right: 15),
                    child: Center(
                      child: Center(
                        child: Text(
                          " ${refreshtype.typename} ",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ));
              }),
              Consumer<RefreshPartPageType>(
                  builder: (context, refreshtype, child) {
                return Container(
                  margin: EdgeInsets.only(top: 10, right: 15),
                  child: FutureBuilder(
                    future: crud.readDataWhere(
                        "restaurantstype", "${refreshtype.typeid}"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data[0] == "faild") {
                          return Center(
                              child:
                                  Text("${getLang(context, "no_rest_found")}"));
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              print("======================");
                              print(snapshot.data);
                              return RestaurantsList(
                                  restaurants: snapshot.data[i]); //
                            });
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              }),
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pushNamed("home");
            return null;
          }),
    );
  }
}

class BuildListHorizontal extends StatelessWidget {
  final crud;
  const BuildListHorizontal({Key key, this.crud}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 150,
      child: FutureBuilder(
        future: crud.readData("catsres"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Consumer<RefreshPartPageType>(
                    builder: (context, refreshtpe, child) {
                  return InkWell(
                    onTap: () {
                      refreshtpe
                          .refreshtypeid("${snapshot.data[i]['catsres_id']}");
                      refreshtpe.refreshtypename(
                          "${snapshot.data[i]['catsres_name']}");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://$serverName/upload/catsres/${snapshot.data[i]['catsres_image']}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 100,
                              width: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text("${snapshot.data[i]['catsres_name']}")
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
