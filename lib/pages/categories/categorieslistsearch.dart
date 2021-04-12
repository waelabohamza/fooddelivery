import 'package:flutter/material.dart';
import 'package:fooddelivery/const.dart';
import 'package:fooddelivery/pages/items/itemscat.dart';

class CategoriesListSearch extends StatelessWidget {
  final categories;
  CategoriesListSearch({this.categories});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemsCat(
              catid: categories['cat_id'], catname: categories['cat_name']);
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          child: Row(
            children: [
              Image.network(
                "https://$serverName/upload/categories/${categories['cat_photo']}",
                height: 100,
                width: 130,
                fit: BoxFit.fill,
              ),
              Text(
                "  ${categories['cat_name']}",
                style: TextStyle(fontSize: 20, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
