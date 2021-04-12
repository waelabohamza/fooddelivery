import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/addtocart.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/const.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  final id;
  // final name;
  // final description;
  final image;
  // final price;
  final items;
  // final deliveryprice;
  // final deliveytime;
  ItemDetails({
    Key key,
    this.items,
    this.id,
    // this.name,
    this.image,
    // this.description,
    // this.price,
    // this.deliveryprice,
    // this.deliveytime
  }) : super(key: key);
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  var quanitity;

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey[500], blurRadius: 3)]),
            child: Consumer<AddToCart>(builder: (context, addtocart, child) {
              return MaterialButton(
                height: 50,
                minWidth: 200,
                color: Colors.brown,
                onPressed: () {
                  // addtocart.add(widget.items);
                  // if (addtocart.showalert == true) {
                  //   showAlert(
                  //       context,
                  //       "warning",
                  //       "تنبيه",
                  //       "لا  يمكن اضافة وجبة من اكثر من مطعم هل تريد انشاء طلب جديد",
                  //       () {}, () {
                  //     addtocart.removeAll();
                  //   });
                  // }
                  Navigator.of(context).pushNamed("cart");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      " السلة         ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("cart");
                      },
                      child: Badge(
                        position: BadgePosition.topEnd(end: 15, top: -10),
                        badgeContent: Text(
                          '${addtocart.count}',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              );
            })),
        body: ListView(
          children: <Widget>[
            MyAppBar(currentpage: "itemdetails", titlepage: "تفاصيل الوجبة"),
            buildImageItem(),
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${widget.items['item_name']}",
                        style: TextStyle(fontSize: 20, color: Colors.brown),
                      ),
                      Expanded(child: Container()),
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            " ${widget.items['item_price']} KD ",
                            style: TextStyle(fontSize: 20, color: Colors.brown),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        size: 20,
                        color: Colors.brown,
                      ),
                      Text(
                        "  ${widget.items['res_time_delivery']} -  ${int.parse(widget.items['res_time_delivery']) + 15} دقيقة   ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        Icons.local_shipping, //directions_bike
                        size: 20,
                        color: Colors.brown,
                      ),
                      Text(
                        double.parse(widget.items['res_price_delivery']) == 0
                            ? " مجانا "
                            : " ${widget.items['res_price_delivery']} د.ك",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "${widget.items['item_description']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Text("الكمية "),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        decoration: BoxDecoration(
                            // borderRadius:
                            //     BorderRadius.all(Radius.circular(10)) ,
                            border: Border.all()),
                        child: Consumer<AddToCart>(
                          builder: (context, addtocart, child) {
                            if (addtocart.quantity[widget.id] != null) {
                              return Text("${addtocart.quantity[widget.id]}");
                            } else {
                              return Text("0");
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Consumer<AddToCart>(builder: (context, addtocart, child) {
                        return InkWell(
                          onTap: () {
                            addtocart.remove(widget.items);
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.brown,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        );
                      }),
                      SizedBox(
                        width: 10,
                      ),
                      Consumer<AddToCart>(
                        builder: (context, addtocart, child) {
                          return InkWell(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.brown,
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)))),
                            onTap: () {
                              addtocart.add(widget.items);
                              if (addtocart.showalert == true) {
                                showAlert(
                                    context,
                                    "warning",
                                    "تنبيه",
                                    "لا  يمكن اضافة وجبة من اكثر من مطعم هل تريد انشاء طلب جديد",
                                    () {}, () {
                                  addtocart.removeAll();
                                });
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ));
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

  Padding buildTopText(mdw) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20),
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
                    Navigator.pop(context);
                  }),
              Text("TalabPay",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Expanded(child: Container()),
              Consumer<AddToCart>(
                builder: (context, addtocart, child) {
                  return Row(
                    children: [
                      Directionality(
                          textDirection: TextDirection.ltr,
                          child: addtocart.totalprice == null
                              ? Text(
                                  "${0} K.D",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "${addtocart.totalprice.toStringAsFixed(3)} K.D",
                                  style: TextStyle(color: Colors.white),
                                )),
                      IconButton(
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            return Navigator.of(context).pushNamed("cart");
                          }),
                    ],
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Container buildImageItem() {
    Crud crud = new Crud();
    return Container(
      width: double.infinity,
      height: 330,
      margin: EdgeInsets.only(top: 0, left: 0, right: 0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        child: Image.network(
          "https://$serverName/upload/items/${widget.image}",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
