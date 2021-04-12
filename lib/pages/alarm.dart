import 'package:flutter/material.dart';
import 'package:fooddelivery/component/alert.dart';
import 'package:fooddelivery/component/crud.dart';
import 'package:fooddelivery/component/myappbar.dart';

class Alerm extends StatefulWidget {
  final resid;
  final ordersid;
  final table;

  Alerm({Key key, this.ordersid, this.table, this.resid}) : super(key: key);

  @override
  _AlermState createState() => _AlermState();
}

class _AlermState extends State<Alerm> {
  Crud crud = new Crud();
  Map data;

  @override
  void initState() {
    data = {
      "resid": widget.resid,
      "ordersid": widget.ordersid,
      "table": widget.table
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            MyAppBar(currentpage: "alerm", titlepage: "الجرس"),
            InkWell(
                onTap: () async {
                  showLoading(context) ; 
                  await crud.writeData("alerm", data);
                  Navigator.of(context).pop() ; 
                },
                child: Image.asset("images/alerm.jpg"))
          ],
        ),
      ),
    );
  }
}
