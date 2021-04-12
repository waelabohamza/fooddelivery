import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/pages/items/itemslist.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery/component/addtocart.dart';


class ItemsCat extends StatefulWidget {
  final catid;
  final catname;
  ItemsCat({Key key, this.catid, this.catname}) : super(key: key);
  @override
  _ItemsCatState createState() => _ItemsCatState();
}

class _ItemsCatState extends State<ItemsCat> {
  Crud crud = new Crud();
  Map data;

  @override
  void initState() {
    data = {"catid": widget.catid};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width ; 
    return  Scaffold(
        //   appBar: AppBar(
        //      iconTheme: IconThemeData(color: Colors.black),
        // backgroundColor: Colors.grey[50],
        // elevation: 3.0,
        //     title: Text('${widget.catname}' ,  style: Theme.of(context).textTheme.headline5),
        //     actions: [
        //        IconButton(
        //           icon: Icon(
        //             Icons.search,
        //             color: Colors.black,
        //           ),
        //           onPressed: () {
        //             showSearch(context: context, delegate: DataSearch( type:  "itemscat" , mdw: mdw  ,cat: widget.catid));
        //           })
        //     ],
        //   ),
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
                      position: BadgePosition.topEnd(end: 15 , top: -20),

                      badgeContent: Text('${addtocart.count}' , style: TextStyle(color: Colors.white),),
                      child: Icon(Icons.add_shopping_cart),
                    ),
                    SizedBox(width: 20) , 
                    Text(
                      " السلة ",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                 
                  ],
                );
              }))),
          body:ListView(children: [
            MyAppBar(titlepage: "${widget.catname}",currentpage: "itemscat")  , 
             Container(
            child: FutureBuilder(
              future: crud.writeData("items", data),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                     if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                  if (snapshot.data[0] == "faild") {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, bottom: 50, left: 10, right: 10),
                          child: Text("لا يوجد وجبات في هذا القسم",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 25)),
                        ),
                        Image.asset("images/notfound.jpg")
                      ],
                    );
                  }  
                    return ListView.builder(
                      shrinkWrap: true ,
                      physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return ItemsList(items: snapshot.data[i]);
                        });         
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
          ],),
        );
  }

  
}
