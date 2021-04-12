import 'package:flutter/material.dart';
import 'package:fooddelivery/component/myappbar.dart';

class ChooseOrders extends StatefulWidget {
  ChooseOrders({Key key}) : super(key: key);

  @override
  _ChooseOrdersState createState() => _ChooseOrdersState();
}

class _ChooseOrdersState extends State<ChooseOrders> {
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;

    return Scaffold(
        body: WillPopScope(
            child: Column(children: <Widget>[
              MyAppBar(
                currentpage: "chooseorders",
                titlepage: "الطلبات",
              ),
              SizedBox(height: 50),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: mdw / 20),
                  child: Row(
                    children: [
                      CardChoose(
                          image: "images/food.png", text: "طعام", type: "food"),
                      Expanded(child: Container()),
                      CardChoose(
                          image: "images/taxi.png",
                          text: "تكاسي",
                          type: "taxi"),
                    ],
                  ))
            ]),
            onWillPop: () {
              Navigator.of(context).pushReplacementNamed("home");
              return;
            }));
  }
}

class CardChoose extends StatelessWidget {
  final image;
  final text;
  final type;
  CardChoose({this.image, this.text, this.type});
  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (type == "food") {
          Navigator.of(context).pushNamed("myorders");
        } else {
          Navigator.of(context).pushNamed("myorderstaxi");
        }
      },
      child: Container(
        height: 210,
        child: Card(
          child: Column(
            children: <Widget>[
              Image.asset(
                image,
                width: mdw / 2.4,
                height: 140,
                fit: BoxFit.contain,
              ),
              Text(
                "${text}",
                style: Theme.of(context).textTheme.headline5,
              ),

              // Text(
              //   "23",
              //   style: TextStyle(
              //       fontSize: 25),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
