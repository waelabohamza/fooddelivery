import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/items/itemscatres.dart';
import 'package:fooddelivery/pages/restaurants/refreshpartcat.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:cached_network_image/cached_network_image.dart';
// My Import
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/pages/items/itemdetails.dart';
import 'package:badges/badges.dart';

class Restaurant extends StatefulWidget {
  final restaurant;
  Restaurant({this.restaurant});
  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  Crud crud = new Crud();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey[500], blurRadius: 2)]),
          // color: Colors.grey[50],
          child: MaterialButton(
              minWidth: 200,
              color: Colors.grey[50],
              onPressed: () {
                Navigator.of(context).pushNamed("cart");
              },
              child: Consumer<AddToCart>(builder: (context, addtocart, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Badge(
                      position: BadgePosition.topEnd(end: 15, top: -20),
                      badgeContent: Text(
                        '${addtocart.count}',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(Icons.add_shopping_cart),
                    ),
                    SizedBox(width: 20),
                    Text(
                      " السلة ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                );
              }))),
      body: WillPopScope(
          child: ListView(
            children: <Widget>[
              MyAppBar(
                currentpage: "resturant",
                titlepage: "مطعم  ${widget.restaurant['res_name']}",
                search: "itemsres",
                data: widget.restaurant['res_id'],
              ),
              Container(
                  padding: EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "الاقسام",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      BuildListHorizontal(
                          restaurant: widget.restaurant, crud: crud),

                      Consumer<RefreshPartPageCat>(
                          builder: (context, refresh, child) {
                        return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                "  ${refresh.catname} ",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ));
                      }),
                      SizedBox(height: 20),
                      Consumer<RefreshPartPageCat>(
                          builder: (context, refresh, child) {
                        return ItemCatRes(
                          catname: refresh.catname,
                          resid: widget.restaurant['res_id'],
                          resname: "ss",
                        );
                      })

                      // FutureBuilder(
                      //   future: crud.readDataWhere("items", widget.restaurant['res_id']),
                      //   builder:
                      //       (BuildContext context, AsyncSnapshot snapshot) {
                      //     if (snapshot.hasData) {
                      //       if (snapshot.data[0] == "faild") {
                      //         return Image.asset("images/notfound.jpg");
                      //       } else {
                      //         return ListView.builder(
                      //             shrinkWrap: true,
                      //             physics: NeverScrollableScrollPhysics(),
                      //             itemCount: snapshot.data.length,
                      //             itemBuilder: (context, i) {
                      //               return buildListItems(snapshot.data[i]);
                      //             });
                      //       }
                      //     }
                      //     return Center(child: CircularProgressIndicator());
                      //   },
                      // )
                    ],
                  ))
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pushNamed("homefood");
            return;
          }),
    );
  }

  Transform buildTopRaduis(mdw) {
    return Transform.scale(
        scale: 2,
        child: Transform.translate(
          offset: Offset(0, -200),
          child: Container(
            height: mdw,
            width: mdw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(mdw)),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ));
  }

  Padding buildTopText(mdw, restaurant) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "home");
                  }),
              Text("TalabPay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Expanded(child: Container()),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: DataSearch(
                            type: "itemsres",
                            mdw: mdw,
                            resid: restaurant['res_id']));
                  })
            ],
          ),
        ],
      ),
    );
  }

  Container buildListItems(Map items) {
    return Container(
      child: InkWell(
        onTap: () {
          return Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return ItemDetails(
              id: items['item_id'],
              // name: items['item_name'],
              // description: items['item_description'],
              image: items['item_image'],
              // price: items['item_price'],
              items: items,
              // deliveryprice: items['res_price_delivery'],
              // deliveytime: items['res_time_delivery'],
            );
          }));
        },
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl:
                    "https://$serverName/upload/items/${items['item_image']}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                height: 90,
              ),
            ),
            Expanded(
                flex: 3,
                child: ListTile(
                  trailing: Container(
                    width: 85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          " ${items['item_price']} ",
                          style: TextStyle(fontSize: 13),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0),
                        ),
                        Consumer<AddToCart>(
                          builder: (context, addtocart, child) {
                            return Container(
                                decoration: BoxDecoration(
                                    color:
                                        addtocart.active[items['item_id']] != 1
                                            ? Colors.black
                                            : Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                                child: InkWell(
                                  onTap: () {
                                    addtocart.active[items['item_id']] != 1
                                        ? addtocart.add(items)
                                        : addtocart.reset(items);

                                    if (addtocart.showalert == true) {
                                      showdialogall(context, "تنبيه",
                                          "لا يمكن اضافة وجبة من اكثر من مطعم بوقت واحد");
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  title: Text(
                    "${items['item_name']}",
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${items['cat_name']}",
                          style: TextStyle(fontSize: 14)),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Color(0xffFFD700),
                            size: 16,
                          ),
                          Text(
                            " 4.8   ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 16,
                          ),
                          Text(
                              " ${items['res_time_delivery']} - ${int.parse(items['res_time_delivery']) + 15} دقيقة   ",
                              style: TextStyle(fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        )),
      ),
    );
  }
}

class BuildListHorizontal extends StatelessWidget {
  final restaurant;
  final crud;
  BuildListHorizontal({Key key, this.restaurant, this.crud}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 150,
      child: FutureBuilder(
        future: crud.readData("categories"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Consumer<RefreshPartPageCat>(
                    builder: (context, refreshpartpage, child) {
                  return InkWell(
                    onTap: () {
                      refreshpartpage
                          .refreshcatid("${snapshot.data[i]['cat_id']}");
                      refreshpartpage
                          .refreshcatname("${snapshot.data[i]['cat_name']}");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://$serverName/upload/categories/${snapshot.data[i]['cat_photo']}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 100,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text("${snapshot.data[i]['cat_name']}")
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
