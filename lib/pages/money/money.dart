import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';
import 'package:fooddelivery/pages/money/moneylist.dart';
import 'package:fooddelivery/pages/money/recivemoney.dart';

import '../../const.dart';

class Money extends StatefulWidget {
  Money({Key key}) : super(key: key);
  @override
  _MoneyState createState() => _MoneyState();
}

class _MoneyState extends State<Money> {
  Crud crud = new Crud();
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: crud.readData("imagehome"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    MyAppBar(currentpage: "money", titlepage: "الاموال"),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Center(
                        child: Text(
                          "معاملات مالية",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: 190,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildImageTalab(
                              "https://$serverName/upload/home/${snapshot.data['imageshome_charge']}",
                              "${snapshot.data['textcharge']}", () {
                            // Navigator.of(context).pushNamed("hometaxi");
                          }),
                          SizedBox(width: 10),
                          buildImageTalab(
                              "https://$serverName/upload/home/${snapshot.data['imageshome_sa']}",
                              "${snapshot.data['textst']}", () {
                            Navigator.of(context).pushNamed("bill");
                          }),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Center(
                        child: Text(
                          "تحويل الاموال",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    MoneyList(
                      title: "${snapshot.data['textsp']}",
                      url:
                          "https://$serverName/upload/home/${snapshot.data['imageshome_sp']}",
                      body: "",
                      function: () {
                        Navigator.of(context).pushNamed("transfermoney");
                      },
                    ),
                    MoneyList(
                      title: "${snapshot.data['textrq']}",
                      url:
                          "https://$serverName/upload/home/${snapshot.data['imageshome_rq']}",
                      body: "",
                      function: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ReciveMoney(
                            mdw: mdw,
                          );
                        }));
                      },
                    ),
                    MoneyList(
                      title: "${snapshot.data['textsq']}",
                      url:
                          "https://$serverName/upload/home/${snapshot.data['imageshome_sq']}",
                      body: "",
                      function: () {
                        Navigator.of(context).pushNamed("sendmoneyqrcode");
                      },
                    ),
                    SizedBox(height: 20)
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  InkWell buildImageTalab(url, title, navigate()) {
    return InkWell(
        onTap: navigate,
        child: Container(
            child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 110,
                width: 150,
                fit: BoxFit.fill,
              ),
            ),
            Container(child: Text("$title"))
          ],
        )));
  }
}
