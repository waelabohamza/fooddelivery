import 'package:flutter/material.dart';
// My Import
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/pages/orderstaxi/delivery.dart';
import 'package:jiffy/jiffy.dart';
class OrdersTaxiWait extends StatefulWidget {
  OrdersTaxiWait({Key key}) : super(key: key);
  @override
  _OrdersTaxiWaitState createState() => _OrdersTaxiWaitState();
}
class _OrdersTaxiWaitState extends State<OrdersTaxiWait> {
  Crud crud = new Crud();
  Map data;
  var userid = sharedPrefs.getString("id");
  @override
  void initState() {
    super.initState();
    data = {"userid": userid};
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            child: userid == null
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      MyAppBar(
                        currentpage: "orderstaxiwait",
                        titlepage: "طلبات التكاسي",
                      ),
                      FutureBuilder(
                        future: crud.writeData("orderstaxi", data),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data[0] == "faild") {
                              return Center(
                                  child: Text(
                                "لا يوجد اي طلب ",
                                style:
                                    TextStyle(color: Colors.brown, fontSize: 30),
                              ));
                            }
                            return ListView.builder(
                              shrinkWrap: true ,
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Delivery(
            orderid: orders['orderstaxi_id'],
            statusorders: 1.toString(),
            lat: orders['orderstaxi_lat'],
            long: orders['orderstaxi_long'],
            destlat: orders['orderstaxi_lat_dest'],
            destlong: orders['orderstaxi_long_dest'],
            taxiid: orders['orderstaxi_taxi'],
          );
        }));
      },
      child: Container(
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
                      "معرف الطلبية : ${orders['orderstaxi_id']}",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "اسم السائق : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['taxi_username']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: "هاتف السائق : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "${orders['taxi_phone']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ])),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                            children: <TextSpan>[
                          TextSpan(
                              text: " السعر الكلي : ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text:
                                  " ${double.parse(orders['orderstaxi_price']).toStringAsFixed(3)} د.ك",
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w600))
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
                        "${Jiffy(orders['orderstaxi_date']).fromNow()}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            Container(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: int.parse(orders['orderstaxi_status']) == 0 ||
                      int.parse(orders['orderstaxi_status']) == 1
                  ? Text(
                      "بانتظار الموافقة ",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  : Text(
                      "تم  التوصيل ",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
            )
          ],
        ),
      )),
    );
  }
}
