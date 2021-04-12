import 'package:flutter/material.dart';
// My Import
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersWait extends StatefulWidget {
  OrdersWait({Key key}) : super(key: key);

  @override
  _OrdersWaitState createState() => _OrdersWaitState();
}

class _OrdersWaitState extends State<OrdersWait> {
  Crud crud = new Crud();
  Map data;
  var userid;
  setLocal() async {
    await Jiffy.locale("ar");
  }

  getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("id");
      print(userid);
    });
    data = {"userid": userid , "status" : "wait" } ;
  }

  @override
  void initState() {
    super.initState();
    setLocal();
    getuserid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            child: userid == null
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      MyAppBar(currentpage: "ordersdone",titlepage: "طلبات الطعام",)  , 
                      FutureBuilder(
                        future: crud.writeData("orders", data),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data[0] == "faild") {
                              return Center(
                                  child: Text(
                                "لا يوجد اي طلب ",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 30),
                              ));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListOrders(orders: snapshot.data[index]);
                              },
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  ),
            onWillPop: () {
              Navigator.pushNamed(context, "chooseoreders");
              return null;
            }));
  }
}

class ListOrders extends StatelessWidget {
  final orders;
  const ListOrders({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Container(
              margin: EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "معرف الطلبية : ${orders['orders_id']}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "اسم المطعم : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['res_name']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
                        RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "نوع الطلبية : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['orders_type']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])),
               orders['orders_type'] == "tableqrcode" ?     RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: "رقم الطاولة: ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text: "${orders['orders_table']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ])) : SizedBox() ,
                  RichText(
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            text: " السعر الكلي : ",
                            style: TextStyle(color: Colors.grey)),
                        TextSpan(
                            text:
                                " ${double.parse(orders['orders_total']).toStringAsFixed(3)} د.ك",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600))
                      ])),
                ],
              ),
            ),
            trailing: Container(
                margin: EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${Jiffy(orders['orders_date']).fromNow()}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
          ),
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.brown,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            child: Row(
              children: [
                Text(
                  "الوجبة",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Expanded(child: Container()),
                Text("الكميه",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          FutureBuilder(
            future: Crud().readDataWhere("orderdetails", orders['orders_id']),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(snapshot.data[i]['item_name']),
                                Expanded(child: Container()),
                                Text(snapshot.data[i]['details_quantity']),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            child:   Text(
                    "بانتظار الموافقة ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
               
          )
        ],
      ),
    ));
  }
}
