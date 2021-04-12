import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/categories/categorieslistsearch.dart';
import 'package:fooddelivery/pages/items/itemdetails.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:fooddelivery/pages/items/itemslist.dart';
import 'package:fooddelivery/pages/restaurants/restaurant.dart';
import 'package:fooddelivery/pages/restaurants/restaurantslist.dart';

class DataSearch extends SearchDelegate<Future<Widget>> {
  List<dynamic> list;
  final type;
  final mdw;
  // for items to all categories
  final cat;
  // for items to all categories
  final resid;
  DataSearch({this.type, this.mdw, this.cat, this.resid});
  Crud crud = new Crud();
  @override
  List<Widget> buildActions(BuildContext context) {
    // Action for AppBar
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon Leading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("yes");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searchers for something
    if (query.isEmpty) {
      return Center(
        child: Stack(
          children: [
            Positioned(
                left: mdw - 85 / 100 * mdw,
                top: mdw - 50 / 100 * mdw,
                child: Image.asset(
                  "images/search.png",
                  width: mdw,
                  height: mdw,
                ))
          ],
        ),
      );
    } else {
      return FutureBuilder(
        future: type == "categories"
            ? crud.readDataWhere("searchcats", query.toString())
            : type == "itemscat"
                ? crud.writeData("searchitems",
                    {"search": query.toString(), "catid": cat.toString()})
                : type == "itemsres"
                    ? crud.writeData("searchitems",
                        {"search": query.toString(), "resid": resid.toString()})
                    : type == "itemscatres"
                        ? crud.writeData("searchitems", {
                            "search": query.toString(),
                            "catid": cat.toString(),
                            "resid": resid
                          })
                        : type == "users"
                            ? crud.readDataWhere(
                                "searchusers", query.toString())
                            : type == "restuarants"
                                ? crud.readDataWhere("searchrestaurants",
                                    query.toString().trim())
                                : type == "searchall"
                                    ? crud.readDataWhere(
                                        "searchall", query.toString().trim())
                                    : "",
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data[0] == "faild") {
              return Image.asset("images/notfounditem.jpg");
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  if (type == "categories") {
                    return CategoriesListSearch(categories: snapshot.data[i]);
                  } else if (type == "itemscat") {
                    return ItemsList(
                      items: snapshot.data[i],
                    );
                  } else if (type == "itemsres") {
                    return ItemsList(
                      items: snapshot.data[i],
                    );
                  } else if (type == "itemscatres") {
                    return ItemsList(
                      items: snapshot.data[i],
                    );
                  } else if (type == "restuarants") {
                    return RestaurantsList(restaurants: snapshot.data[i]);
                  } else if (type == "searchall") {
                    return SearchAll(
                      list: snapshot.data[i],
                      type: snapshot.data[i]['type'],
                    );
                  }
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}

class SearchAll extends StatelessWidget {
  final list;

  final type;
  const SearchAll({Key key, this.list, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          return Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            if (list['type'] == 'categories') {
              return ItemsCat(
                  catid: list['type_id'], catname: list['type_name']);
            } else if (list['type'] == "items") {
              return ItemDetails(
                items: list['data'],
                image: list['data']['item_image'],
                id: list['type_id'],
              );
            } else {
              return Restaurant(
                restaurant: list['data'],
              );
            }
          }));

          // return ItemDetails(
          //   id: items['item_id'],
          //   name: items['item_name'],
          //   description: items['item_description'],
          //   image: items['item_image'],
          //   price: items['item_price'],
          //   items: items,
          //   deliveryprice: items['res_price_delivery'],
          //   deliveytime: items['res_time_delivery'],
          // );
        },
        child: Card(
            child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: list['type'] == 'categories'
                    ? "https://$serverName/upload/categories/${list['data']['cat_image']}"
                    : list['type'] == 'items'
                        ? "https://$serverName/upload/items/${list['data']['item_image']}"
                        : "https://$serverName/upload/reslogo/${list['data']['res_image']}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
                height: 100,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                trailing: Container(
                    child: Text(
                        "${list['type'] == 'categories' ? 'قسم' : list['type'] == 'items' ? 'وجبة' : 'مطعم'}")),
                isThreeLine: true,
                title: Container(
                  margin: EdgeInsets.only(top: 14),
                  child: Text(
                    " ${list['type_name']}",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(" ", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
