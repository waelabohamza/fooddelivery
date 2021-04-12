import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery/const.dart';

class OffersList extends StatelessWidget {
  final offers;
  OffersList({this.offers});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {},
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
                            "https://$serverName/upload/offers/${offers['offers_image']}",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 110,
                        fit: BoxFit.cover,
                      )),
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
                              "${offers['offers_title']}",
                              style: TextStyle(color: Colors.brown),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${offers['offers_body']}",
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
