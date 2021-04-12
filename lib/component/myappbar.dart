import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/animetedroute.dart';
import 'package:fooddelivery/component/drawer.dart';
import 'package:fooddelivery/component/searchglobal.dart';
import 'package:fooddelivery/main.dart';

class MyAppBar extends StatefulWidget {
  final currentpage;
  final titlepage;
  final search;
  final data;
  const MyAppBar(
      {Key key, this.currentpage, this.titlepage, this.search, this.data})
      : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    var mdw = MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 1)
                  ]),
              child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.brown,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(SlideBottomRoute(page: MyDrawer()));
                  }),
            ),
            Container(
              margin: EdgeInsets.only(right: sharedPrefs.getString("lang") == "ar" ? 7 : 0 , left: sharedPrefs.getString("lang") == "ar" ? 0 : 7 ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 1)
                  ]),
              child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.brown,
                  ),
                  onPressed: () {
                     Navigator.of(context).pushNamed("messages") ; 
                  }),
            ) , 
         
            Expanded(child: Container()),
            Container(
                child: Text(
              "${widget.titlepage}",
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )),
            Expanded(child: Container()),
            widget.search == null
                ? SizedBox(width: 0)
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300], blurRadius: 1)
                        ]),
                    child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.brown,
                        ),
                        onPressed: () {
                          mySearchAppBar(context, mdw, "${widget.search}");
                        }),
                  ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300], blurRadius: 1)
                  ]),
              child: IconButton(
                  icon: Icon(
                 widget.currentpage == "home" ? Icons.shopping_cart :    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.brown,
                  ),
                  
                  onPressed: () {
                    if (widget.currentpage == "home") {
                      // Navigator.of(context).pushNamed("home");
                      // String mytitle = "تنبيه";
                      // String mybody = "هل تريد الخروج من التطبيق";
                      // showAlert(context, "error", mytitle, mybody, () {}, () {
                      //   exit(0);
                      // });
                      Navigator.of(context).pushNamed("cart");

                    } else {
                      Navigator.of(context).pop();
                    }
                  }),
            )
          ],
        ));
  }

  mySearchAppBar(context, mdw, [type]) {
    if (type == "restaurants") {
      showSearch(
          context: context,
          delegate: DataSearch(type: "restuarants", mdw: mdw));
    } else if (type == "categories") {
      showSearch(
          context: context, delegate: DataSearch(type: "categories", mdw: mdw));
    } else if (type == "searchall") {
      showSearch(
          context: context, delegate: DataSearch(type: "searchall", mdw: mdw));
    } else if (type == "itemsres") {
      showSearch(
          context: context,
          delegate: DataSearch(type: "itemsres", mdw: mdw, resid: widget.data));
    }
  }
}
