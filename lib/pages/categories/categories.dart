import 'package:flutter/material.dart';
import 'package:fooddelivery/component/applocal.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/pages/categories/categorieslist.dart';

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
          child: ListView(
            children: <Widget>[
              MyAppBar(
                currentpage: "categories",
                titlepage: "${getLang(context, "categories")}",
                search: "categories",
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: crud.readData("categories"),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, i) {
                                return CategoriesList(
                                    categories: snapshot.data[i],
                                    crud: crud,
                                    mdw: MediaQuery.of(context).size.width);
                              });
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          onWillPop: () {
            Navigator.of(context).pushNamed("home");
            return null;
          }),
    );
  }
}
