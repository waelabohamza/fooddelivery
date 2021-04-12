import 'package:flutter/material.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesList extends StatelessWidget {
  final mdw;
  final crud;
  final categories;
  CategoriesList({this.categories, this.crud, this.mdw});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemsCat(
              catid: categories['cat_id'], catname: categories['cat_name']);
        }));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl:
                    "https://$serverName/upload/categories/${categories['cat_photo']}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: mdw / 3,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "${categories['cat_name']}",
            style: TextStyle(fontSize: 17, color: Colors.black),
          )
        ],
      ),
    );
  }
}
