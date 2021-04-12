import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/restaurants/restaurant.dart';

class RestaurantsList extends StatelessWidget {
  final restaurants;

  RestaurantsList({this.restaurants});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Restaurant(
                restaurant: restaurants,
              );
            }));
          },
          child: Container(
            child: Card(
                child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://$serverName/upload/reslogo/${restaurants['res_image']}",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "مطعم ${restaurants['res_name']}",
                              style: TextStyle(color: Colors.brown),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${restaurants['catsres_name']}",
                                    style: TextStyle(color: Colors.brown)),
                                Text(
                                  "العنوان ${restaurants['res_area']}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )),
          ),
        ),
      ],
    );
  }
}
