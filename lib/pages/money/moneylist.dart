import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoneyList extends StatelessWidget {
  final String url;
  final String title;
  final String body;
  final Function function;
  MoneyList({this.url, this.body, this.title, this.function});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: function,
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
                          imageUrl: url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill)),
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
                              "$title",
                              style:
                                  TextStyle(color: Colors.brown, fontSize: 14),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "$body",
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
